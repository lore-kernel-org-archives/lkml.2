Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab2DAGlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 02:41:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3090 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab2DAGlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 02:41:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6666"; a="177788619"
Message-ID: <4F77F883.5050207@codeaurora.org>
Date: Sat, 31 Mar 2012 23:41:07 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Jike Song <albcamus@gmail.com>
CC: Yang Bai <hamo.by@gmail.com>, mmarek@suse.cz, rostedt@goodmis.org,
        adobriyan@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: refactor remove structure forward declarations
References: <1331540451-2380-1-git-send-email-hamo.by@gmail.com> <CANE52KjOF2G_WQmms8+Xu9m2RXmb0=Bc5E94UUFvMc2xhhJ9mA@mail.gmail.com>
In-Reply-To: <CANE52KjOF2G_WQmms8+Xu9m2RXmb0=Bc5E94UUFvMc2xhhJ9mA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/31/2012 6:59 PM, Jike Song wrote:
> Seems broke cscope build:
>
> $ make cscope
>   GEN     cscope
> sed: can't read cscope: No such file or directory
> make: *** [cscope] Error 2
>
> with V=1:
[snip]
> + cscope -b -f cscope.out
> + '[' -n ']'
> + LANG=C
> + sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct
> \1;.*\$\/;"\tx$/d' cscope
> sed: can't read cscope: No such file or directory
> make: *** [cscope] Error 2

Ah yes. Forgot the quotes.

---->8------

Subject: [PATCH] tags.sh: Add missing quotes

When $remove_structs is empty a test for empty string will turn
into test -n with no arguments meaning true. Add quotes so an
empty string is tested and so that make cscope works again.

Reported-by: Jike Song <albcamus@gmail.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 scripts/tags.sh |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/tags.sh b/scripts/tags.sh
index 0d6004e..cf7b12f 100755
--- a/scripts/tags.sh
+++ b/scripts/tags.sh
@@ -254,6 +254,6 @@ case "$1" in
 esac

 # Remove structure forward declarations.
-if [ -n $remove_structs ]; then
+if [ -n "$remove_structs" ]; then
     LANG=C sed -i -e '/^\([a-zA-Z_][a-zA-Z0-9_]*\)\t.*\t\/\^struct \1;.*\$\/;"\tx$/d' $1
 fi

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

