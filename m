Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab1BZEGW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 23:06:22 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39256 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab1BZEGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 23:06:21 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6268"; a="76816637"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        trivial@kernel.org
Subject: [PATCH] ARM: hw_breakpoint: Fix newlines in WARNings
Date: Fri, 25 Feb 2011 20:06:03 -0800
Message-Id: <1298693163-18269-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.4.1.57.g0466
In-Reply-To: <1298633466.32588.1.camel@e102144-lin.cambridge.arm.com>
References: <1298633466.32588.1.camel@e102144-lin.cambridge.arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These warnings are missing newlines and spaces causing confusing
looking output when they trigger.

Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---

Will Deacon wrote:
> > I'd prefer the message text not to be line wrapped, even if it
> > violates the general line length rule, because that makes it easier to
> > grep for the message in the source code.
>
> Ok, that's understandable. Moving the text onto its own line will limit
> the damage to the line length too. Stephen - are you happy to make these
> changes as part of your previous patch?

Sure.

 arch/arm/kernel/hw_breakpoint.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/hw_breakpoint.c b/arch/arm/kernel/hw_breakpoint.c
index d600bd3..6da9132 100644
--- a/arch/arm/kernel/hw_breakpoint.c
+++ b/arch/arm/kernel/hw_breakpoint.c
@@ -238,8 +238,8 @@ static int enable_monitor_mode(void)
 	ARM_DBG_READ(c1, 0, dscr);
 
 	/* Ensure that halting mode is disabled. */
-	if (WARN_ONCE(dscr & ARM_DSCR_HDBGEN, "halting debug mode enabled."
-				"Unable to access hardware resources.")) {
+	if (WARN_ONCE(dscr & ARM_DSCR_HDBGEN,
+			"halting debug mode enabled. Unable to access hardware resources.\n")) {
 		ret = -EPERM;
 		goto out;
 	}
@@ -377,7 +377,7 @@ int arch_install_hw_breakpoint(struct perf_event *bp)
 		}
 	}
 
-	if (WARN_ONCE(i == max_slots, "Can't find any breakpoint slot")) {
+	if (WARN_ONCE(i == max_slots, "Can't find any breakpoint slot\n")) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -423,7 +423,7 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
 		}
 	}
 
-	if (WARN_ONCE(i == max_slots, "Can't find any breakpoint slot"))
+	if (WARN_ONCE(i == max_slots, "Can't find any breakpoint slot\n"))
 		return;
 
 	/* Reset the control register. */
@@ -635,7 +635,7 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
 	if (WARN_ONCE(!bp->overflow_handler &&
 		(arch_check_bp_in_kernelspace(bp) || !core_has_mismatch_brps()
 		 || !bp->hw.bp_target),
-			"overflow handler required but none found")) {
+			"overflow handler required but none found\n")) {
 		ret = -EINVAL;
 	}
 out:
@@ -916,8 +916,8 @@ static int __init arch_hw_breakpoint_init(void)
 	ARM_DBG_READ(c1, 0, dscr);
 	if (dscr & ARM_DSCR_HDBGEN) {
 		max_watchpoint_len = 4;
-		pr_warning("halting debug mode enabled. Assuming maximum "
-			   "watchpoint size of %u bytes.", max_watchpoint_len);
+		pr_warning("halting debug mode enabled. Assuming maximum watchpoint size of %u bytes.\n",
+			   max_watchpoint_len);
 	} else {
 		/* Work out the maximum supported watchpoint length. */
 		max_watchpoint_len = get_max_wp_len();
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

