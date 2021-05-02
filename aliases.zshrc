alias reload="source ~/.zshrc"
alias pent='eval "$(pyenv init -)" && eval "$(pyenv virtualenv-init -)"'
alias brails="bin/rails"
alias brs="bin/rails s"
alias brc="bin/rails c"

alias copy="xclip -selection clipboard"
alias paste="xclip -selection clipboard -o"

# on mac
alias mongostart="brew services start mongodb-community"

RED="\033[1;31m"
GREEN="\033[1;32m"
NOCOLOR="\033[0m"
function confirm() {
    echo "Are you sure you want to run: $*? [y/n]"
    read -q
    echo
    if test "$REPLY" = "y" -o "$REPLY" = "Y"; then
        echo -e "Running ${GREEN}$*${NOCOLOR}"
        "$@"
    else
        echo "Cancelled by user"
    fi
}

alias gfo="git fetch origin"

alias gpomr="git pull origin master"
alias gfomr="git fetch origin/master"
alias gmomr="git merge origin/master"
alias gsomr="git push origin master"
alias gymr="git checkout master"
alias gcpomr="git checkout master && git pull origin master"

alias gpom="git pull origin main"
alias gfom="git fetch origin/main"
alias gmom="git merge origin/main"
alias gsom="git push origin main"
alias gym="git checkout main"
alias gcpom="git checkout main && git pull origin main"

alias gs="git status"
alias gco="git cola"
alias gcu="git rev-parse --abbrev-ref HEAD"
function gpoc() {
    confirm git pull origin $(gcu) $@
}

function gsoc() {
    confirm git push origin $(gcu) $@
}
function gbdel() {
    if [ \( "$#" -lt 1 \) -o \( "$#" -gt 1 -a "$2" != "-e" \) -o \( "$2" = "-e" -a "$#" -lt 3 \) -o \( "$1" = "-h" \) -o \( "$1" = "-help" \) ]; then
        if [ "$#" -lt 1 ]; then
            echo "gmbd: illegal option"
        fi
        echo "Usage: gmbd <include-pattern> [-e <exclude-patterns>]"
        echo "Example(search only hotfix): gmbd hotfix"
        echo "Example(search ma but exclude master and main): gmbd ma -e master main"
        return 0
    fi

    cb=$(gcu)
    if [ "$cb" = "" ]; then
        echo "${RED}This folder does not have a git repository${NOCOLOR}"
        return 0
    fi
    command="git branch | grep $1 | grep -v $cb"
    exclude_patterns=( "${@:3}" )
    echo "Checking branches with keyword: ${GREEN}$1${NOCOLOR}"
    if [ "$exclude_patterns" != "" ]; then
        echo "Excluding branches with keywords: ${RED}$cb${NOCOLOR}"
    fi
    echo
    echo "The following branches will be deleted:"

    for word in $exclude_patterns
    do
        command="$command | grep -v $word"
    done
    echo ${RED}
    eval $command
    echo ${NOCOLOR}


    echo "Are you sure you want to delete these branches? [y/n]"
    read -q
    echo
    if test "$REPLY" = "y" -o "$REPLY" = "Y"; then
        command="$command | xargs git branch -D"
        echo -e "Running command: ${GREEN}$command${NOCOLOR}"
        eval $command
        echo -e "${RED}Deleted successfully. ${GREEN}Displaying existing branch:${NOCOLOR}"
        eval "git branch"
    else
        echo "Cancelled by user"
    fi
}

alias grubomod='git ls-files -m | xargs ls -1 2>/dev/null | grep .rb | xargs rubocop -a'
alias rubomod='git ls-files -m | xargs ls -1 2>/dev/null | grep .rb | xargs bin/rubocop -a'
alias rubomodu='git ls-files --others --exclude-standard | xargs ls -1 2>/dev/null | grep .rb | xargs bin/rubocop -a'

function rubodiff() {
    git diff $1 --name-only | grep .rb | xargs bin/rubocop -a
}
