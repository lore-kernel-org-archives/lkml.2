Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751673Ab2DAL4t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 07:56:49 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56609 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab2DAL4r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 07:56:47 -0400
MIME-Version: 1.0
In-Reply-To: <1333279918-29466-1-git-send-email-prarit@redhat.com>
References: <1333279918-29466-1-git-send-email-prarit@redhat.com>
From: Yang Bai <hamo.by@gmail.com>
Date: Sun, 1 Apr 2012 19:56:26 +0800
Message-ID: <CAO_0yfNV+rabyL95=i8EHJb0BgY+QCGS_30_9eebx9AKEOOnbQ@mail.gmail.com>
Subject: Re: [PATCH] scripts, Fix 'make cscope'
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        Michal Marek <mmarek@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 7:31 PM, Prarit Bhargava <prarit@redhat.com> wrote:
> commit 66979224c0d288331edcadb1e6ebd978d920d476, scripts: refactor remove
>  structure forward declarations, breaks 'make cscope' which now gives the
>  following error:
>
> [prarit@prarit linux-2.6]$ make cscope
>  GEN     cscope
>  sed: can't read cscope: No such file or directory
>  make: *** [cscope] Error 2
>
Thanks for pointing this out.

> Fix a typo in the commit.
>
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Cc: Yang Bai <hamo.by@gmail.com>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Michal Marek <mmarek@suse.cz>
> ---
>  scripts/tags.sh |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index 0d6004e..b501e84 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -255,5 +255,5 @@ esac
>
>  # Remove structure forward declarations.
>  if [ -n $remove_structs ]; then
> -    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
> +    LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' tags
>  fi
> --
> 1.7.1
>

But this does not fix the real problem and introduce the origin
problem of make TAGS back.

Could you try this patch?

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 0d6004e..cf7b12f 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -254,6 +254,6 @@ case "$1" in
 esac

 # Remove structure forward declarations.
-if [ -n $remove_structs ]; then
+if [ -n "$remove_structs" ]; then
     LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct
\1;.*\$\/;"\tx$/d' $1
 fi


-- 
    """
    Keep It Simple,Stupid.
    """

Chinese Name: 白杨
Nick Name: Hamo
Homepage: http://hamobai.com/
GPG KEY ID: 0xA4691A33
Key fingerprint = 09D5 2D78 8E2B 0995 CF8E  4331 33C4 3D24 A469 1A33
