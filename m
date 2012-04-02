Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751658Ab2DBJb3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 05:31:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39745 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751082Ab2DBJb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 05:31:28 -0400
Message-ID: <4F7971EE.9040405@suse.cz>
Date: Mon, 02 Apr 2012 11:31:26 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Jike Song <albcamus@gmail.com>, Yang Bai <hamo.by@gmail.com>,
        rostedt@goodmis.org, adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: refactor remove structure forward declarations
References: <1331540451-2380-1-git-send-email-hamo.by@gmail.com> <CANE52KjOF2G_WQmms8+Xu9m2RXmb0=Bc5E94UUFvMc2xhhJ9mA@mail.gmail.com> <4F77F883.5050207@codeaurora.org>
In-Reply-To: <4F77F883.5050207@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1.4.2012 08:41, Stephen Boyd wrote:
> On 3/31/2012 6:59 PM, Jike Song wrote:
>> Seems broke cscope build:
>>
>> $ make cscope
>>   GEN     cscope
>> sed: can't read cscope: No such file or directory
>> make: *** [cscope] Error 2
>>
>> with V=1:
> [snip]
>> + cscope -b -f cscope.out
>> + '[' -n ']'
>> + LANG=C
>> + sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct
>> \1;.*\$\/;"\tx$/d' cscope
>> sed: can't read cscope: No such file or directory
>> make: *** [cscope] Error 2
> 
> Ah yes. Forgot the quotes.
> 
> ---->8------
> 
> Subject: [PATCH] tags.sh: Add missing quotes
> 
> When $remove_structs is empty a test for empty string will turn
> into test -n with no arguments meaning true. Add quotes so an
> empty string is tested and so that make cscope works again.
> 
> Reported-by: Jike Song <albcamus@gmail.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  scripts/tags.sh |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 0d6004e..cf7b12f 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -254,6 +254,6 @@ case "$1" in
>  esac
> 
>  # Remove structure forward declarations.
> -if [ -n $remove_structs ]; then
> +if [ -n "$remove_structs" ]; then
>      LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
>  fi
> 

Applied to kbuild.git#rc-fixes, thanks.

Michal
