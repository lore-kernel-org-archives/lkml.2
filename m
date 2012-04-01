Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791Ab2DAMTO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 08:19:14 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:33362 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab2DAMTM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 08:19:12 -0400
MIME-Version: 1.0
In-Reply-To: <4F77F883.5050207@codeaurora.org>
References: <1331540451-2380-1-git-send-email-hamo.by@gmail.com>
 <CANE52KjOF2G_WQmms8+Xu9m2RXmb0=Bc5E94UUFvMc2xhhJ9mA@mail.gmail.com> <4F77F883.5050207@codeaurora.org>
From: Yang Bai <hamo.by@gmail.com>
Date: Sun, 1 Apr 2012 20:18:51 +0800
Message-ID: <CAO_0yfO+AZUWARb9t3myhO937dDGqLsaDddjqdMQBN2vTABjew@mail.gmail.com>
Subject: Re: [PATCH] scripts: refactor remove structure forward declarations
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Jike Song <albcamus@gmail.com>, mmarek@suse.cz, rostedt@goodmis.org,
        adobriyan@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 2:41 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 3/31/2012 6:59 PM, Jike Song wrote:
>> Seems broke cscope build:
>>
>> $ make cscope
>>   GEN     cscope
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
>  scripts/tags.sh |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 0d6004e..cf7b12f 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -254,6 +254,6 @@ case "$1" in
>  esac
>
>  # Remove structure forward declarations.
> -if [ -n $remove_structs ]; then
> +if [ -n "$remove_structs" ]; then
>     LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
>  fi
>
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>

Acked-by: Yang Bai <hamo.by@gmail.com>

-- 
    """
    Keep It Simple,Stupid.
    """

Chinese Name: 白杨
Nick Name: Hamo
Homepage: http://hamobai.com/
GPG KEY ID: 0xA4691A33
Key fingerprint = 09D5 2D78 8E2B 0995 CF8E  4331 33C4 3D24 A469 1A33
