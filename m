Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab2CLRbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:31:47 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55802 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab2CLRbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:31:46 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6647"; a="169418315"
Message-ID: <4F5E32F2.5030000@codeaurora.org>
Date: Mon, 12 Mar 2012 10:31:30 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Yang Bai <hamo.by@gmail.com>
CC: mmarek@suse.cz, rostedt@goodmis.org, adobriyan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: refactor remove structure forward declarations
References: <1331540451-2380-1-git-send-email-hamo.by@gmail.com>
In-Reply-To: <1331540451-2380-1-git-send-email-hamo.by@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/12 01:20, Yang Bai wrote:
> Since now it has some problems when generate TAGS,
> refactor this code. Now it will not show the error
> message and will remove declarations using emacs etags.
>
> Signed-off-by: Yang Bai <hamo.by@gmail.com>

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

> ---
>  scripts/tags.sh |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 833813a..2b377fc 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -166,9 +166,6 @@ exuberant()
>  	all_defconfigs | xargs -r $1 -a                         \
>  	--langdef=dotconfig --language-force=dotconfig          \
>  	--regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'
> -
> -	# Remove structure forward declarations.
> -	LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
>  }
>  
>  emacs()
> @@ -233,6 +230,7 @@ if [ "${ARCH}" = "um" ]; then
>  	fi
>  fi
>  
> +remove_structs=
>  case "$1" in
>  	"cscope")
>  		docscope
> @@ -245,10 +243,17 @@ case "$1" in
>  	"tags")
>  		rm -f tags
>  		xtags ctags
> +		remove_structs=y
>  		;;
>  
>  	"TAGS")
>  		rm -f TAGS
>  		xtags etags
> +		remove_structs=y
>  		;;
>  esac
> +
> +# Remove structure forward declarations.
> +if [ -n $remove_structs ]; then
> +    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
> +fi


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

