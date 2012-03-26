Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab2CZGw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 02:52:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35478 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274Ab2CZGwX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 02:52:23 -0400
MIME-Version: 1.0
In-Reply-To: <4f66c337.473f440a.7ece.2904@mx.google.com>
References: <4f66c337.473f440a.7ece.2904@mx.google.com>
From: Yang Bai <hamo.by@gmail.com>
Date: Mon, 26 Mar 2012 14:52:01 +0800
Message-ID: <CAO_0yfMVQzrRcq99yOfh923+6KP5nvPt6z2E5vQWMAcbfRpN1g@mail.gmail.com>
Subject: Re: [PATCH][RESEND] scripts: refactor remove structure forward declarations
To: mmarek@suse.cz, rostedt@goodmis.org, sboyd@codeaurora.org,
        adobriyan@gmail.com, imunsie@au1.ibm.com
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Yang Bai <hamo.by@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping.

Any comment?

On Mon, Mar 19, 2012 at 1:24 PM,  <hamo.by@gmail.com> wrote:
> From: Yang Bai <hamo.by@gmail.com>
>
> Since now it has some problems when generate TAGS,
> refactor this code. Now it will not show the error
> message and will remove declarations using emacs etags.
>
> Signed-off-by: Yang Bai <hamo.by@gmail.com>
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  scripts/tags.sh |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
>
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 833813a..2b377fc 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -166,9 +166,6 @@ exuberant()
>        all_defconfigs | xargs -r $1 -a                         \
>        --langdef=dotconfig --language-force=dotconfig          \
>        --regex-dotconfig='/^#?[[:blank:]]*(CONFIG_[[:alnum:]_]+)/\1/'
> -
> -       # Remove structure forward declarations.
> -       LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
>  }
>
>  emacs()
> @@ -233,6 +230,7 @@ if [ "${ARCH}" = "um" ]; then
>        fi
>  fi
>
> +remove_structs=
>  case "$1" in
>        "cscope")
>                docscope
> @@ -245,10 +243,17 @@ case "$1" in
>        "tags")
>                rm -f tags
>                xtags ctags
> +               remove_structs=y
>                ;;
>
>        "TAGS")
>                rm -f TAGS
>                xtags etags
> +               remove_structs=y
>                ;;
>  esac
> +
> +# Remove structure forward declarations.
> +if [ -n $remove_structs ]; then
> +    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
> +fi
> --
> 1.7.9.1
>



-- 
    """
    Keep It Simple,Stupid.
    """

Chinese Name: 白杨
Nick Name: Hamo
Homepage: http://hamobai.com/
GPG KEY ID: 0xA4691A33
Key fingerprint = 09D5 2D78 8E2B 0995 CF8E  4331 33C4 3D24 A469 1A33
