Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757389Ab1EXX4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 19:56:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45075 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab1EXX43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 19:56:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6356"; a="93421554"
From: David Brown <davidb@codeaurora.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [PATCH v6 00/18] ARM: Add support for the Large Physical Address Extensions
References: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
Date: Tue, 24 May 2011 16:56:28 -0700
In-Reply-To: <1306273164-18217-1-git-send-email-catalin.marinas@arm.com>
	(Catalin Marinas's message of "Tue, 24 May 2011 22:39:06 +0100")
Message-ID: <8yapqn7fyab.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24 2011, Catalin Marinas wrote:

> This set of patches adds support for the Large Physical Extensions on
> the ARM architecture (available with the Cortex-A15 processor). LPAE
> comes with a 3-level page table format (compared to 2-level for the
> classic one), allowing up to 40-bit physical address space.

Do you expect non LPAE targets to be able to boot with these changes
applied (and LPAE enabled)?  I am able to build this tree for the
MSM8660 (with a minor patch below), but it fails to boot with LPAE
enabled.  It seems to work fine with LPAE not enabled.

I did have to fix the msm timer code to get the branch you mentioned to
compile.  The return type of the function changed back to 'void' without
changing the returns:

---
 arch/arm/mach-msm/timer.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/timer.c b/arch/arm/mach-msm/timer.c
index 50cc0bc..6e659e4 100644
--- a/arch/arm/mach-msm/timer.c
+++ b/arch/arm/mach-msm/timer.c
@@ -268,7 +268,7 @@ static void __cpuinit msm_local_timer_setup(struct clock_event_device *evt)
 
 	/* Use existing clock_event for cpu 0 */
 	if (!smp_processor_id())
-		return 0;
+		return;
 
 	writel(DGT_CLK_CTL_DIV_4, MSM_TMR_BASE + DGT_CLK_CTL);
 
@@ -296,7 +296,8 @@ static void __cpuinit msm_local_timer_setup(struct clock_event_device *evt)
 	if (res) {
 		pr_err("local_timer_setup: request_irq failed for %s\n",
 		       clock->clockevent.name);
-		return res;
+		/* TODO: How to handle this error. */
+		return;
 	}
 
 	clockevents_register_device(evt);

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
