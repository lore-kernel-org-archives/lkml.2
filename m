Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab0HDXXI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 19:23:08 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2615 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759372Ab0HDXXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 19:23:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6064"; a="49900642"
Message-ID: <4C59F656.3010701@codeaurora.org>
Date: Wed, 04 Aug 2010 16:23:02 -0700
From: Patrick Pannuto <ppannuto@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12pre) Gecko/20100715 Shredder/3.0.7pre
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        joe@perches.com, akpm@linux-foundation.org, tglx@linutronix.de,
        ppannuto@codeaurora.org
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] Checkpatch: Prefer usleep_range over udelay
References: <1280786467-26999-4-git-send-email-ppannuto@codeaurora.org> <tip-022d60db2ab6e97f93c98808d08fd883003048c7@git.kernel.org>
In-Reply-To: <tip-022d60db2ab6e97f93c98808d08fd883003048c7@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 02:25 AM, tip-bot for Patrick Pannuto wrote:
> Commit-ID:  022d60db2ab6e97f93c98808d08fd883003048c7
> Gitweb:     http://git.kernel.org/tip/022d60db2ab6e97f93c98808d08fd883003048c7
> Author:     Patrick Pannuto <ppannuto@codeaurora.org>
> AuthorDate: Mon, 2 Aug 2010 15:01:06 -0700
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 4 Aug 2010 11:00:45 +0200
> 
> Checkpatch: Prefer usleep_range over udelay
> 
> When possible, sleeping is (usually) better than delaying;
> however, don't bother callers of udelay < 10us, as those
> cases are generally not worth the switch to usleep
> 
> Signed-off-by: Patrick Pannuto <ppannuto@codeaurora.org>
> Cc: apw@canonical.com
> Cc: corbet@lwn.net
> Cc: arjan@linux.intel.com
> Cc: Joe Perches <joe@perches.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> LKML-Reference: <1280786467-26999-4-git-send-email-ppannuto@codeaurora.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  scripts/checkpatch.pl |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index bd88f11..1698c63 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2570,6 +2570,14 @@ sub process {
>  			}
>  		}
>  
> +# prefer usleep_range over udelay
> +		if (($line =~ /\budelay\s*\(\s*(\w+)\s*\)/ {
> +			# ignore udelay's < 10, however
> +			if (! (($1 =~ /(\d+)/) && ($1 < 10)) ) {
> +				CHK("usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $line);
> +			}
> +		}
> +
>  # warn about #ifdefs in C files
>  #		if ($line =~ /^.\s*\#\s*if(|n)def/ && ($realfile =~ /\.c$/)) {
>  #			print "#ifdef in C files should be avoided\n";


Andrew Morton's patch to fix the parentheses imbalance in the original
patch was missed (sorry for the initial error).  This breaks checkpatch
in tip; could you pull in this too from -mm to tip?

Sorry for the extra trouble

-Pat


(FROM ANDREW):

The patch titled
     checkpatch-prefer-usleep_range-over-udelay-fix
has been added to the -mm tree.  Its filename is
     checkpatch-prefer-usleep_range-over-udelay-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: checkpatch-prefer-usleep_range-over-udelay-fix
From: Andrew Morton <akpm@linux-foundation.org>

syntax error at scripts/checkpatch.pl line 2598, near "/\budelay\s*\(\s*(\w+)\s*\)/ {"

mismatched parentheses?

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-prefer-usleep_range-over-udelay-fix scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-prefer-usleep_range-over-udelay-fix
+++ a/scripts/checkpatch.pl
@@ -2595,7 +2595,7 @@ sub process {
 		}
 
 # prefer usleep_range over udelay
-		if (($line =~ /\budelay\s*\(\s*(\w+)\s*\)/ {
+		if ($line =~ /\budelay\s*\(\s*(\w+)\s*\)/) {
 			# ignore udelay's < 10, however
 			if (! (($1 =~ /(\d+)/) && ($1 < 10)) ) {
 				CHK("usleep_range is preferred over udelay; see Documentation/timers/timers-howto.txt\n" . $line);



-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
