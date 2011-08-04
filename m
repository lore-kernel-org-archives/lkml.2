Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1HDW5R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 18:57:17 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:50393 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753556Ab1HDW5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 18:57:11 -0400
From: Kevin Hilman <khilman@ti.com>
To: Len Brown <lenb@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [GIT PULL] idle patches for Linux 3.1
Organization: Texas Instruments, Inc.
References: <alpine.LFD.2.02.1108031627060.19398@x980>
	<CA+55aFxikiro4cEwGEOMCGUswyPsaAwyspP1cFUviJ5OUKOZJw@mail.gmail.com>
	<alpine.LFD.2.02.1108040030550.29492@x980>
Date: Thu, 04 Aug 2011 15:57:07 -0700
In-Reply-To: <alpine.LFD.2.02.1108040030550.29492@x980> (Len Brown's message
	of "Thu, 04 Aug 2011 01:03:40 -0400 (EDT)")
Message-ID: <87bow423b0.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len Brown <lenb@kernel.org> writes:

> and I'm here to support them if anything goes wrong.

Here's your first opportuntity for support. :)

I see Linus has already pulled this, but it doesn't compile on ARM or
SH as I just found out, and Trinabh poined out in reply to patch 5/5.

Here's a fix.

Kevin

>From f8c825215f824b01a3f33416198def2fd685c7cf Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@ti.com>
Date: Thu, 4 Aug 2011 15:49:51 -0700
Subject: [PATCH] cpuidle: ARM/SH: fix use of cpuidle_idle_call()

commit a0bfa1373859e9d11dc92561a8667588803e42d8 (cpuidle: stop
depending on pm_idle) introduced a call to cpuidle_call_idle() in the
ARM and SH idle paths, but this function doesn't exist.  Use
cpuidle_idle_call()

Reported-by: Trinabh Gupta <trinabh@linux.vnet.ibm.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Kevin Hilman <khilman@ti.com>
---
 arch/arm/kernel/process.c |    2 +-
 arch/sh/kernel/idle.c     |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/process.c b/arch/arm/kernel/process.c
index d7ee0d4..1a347f4 100644
--- a/arch/arm/kernel/process.c
+++ b/arch/arm/kernel/process.c
@@ -197,7 +197,7 @@ void cpu_idle(void)
 				cpu_relax();
 			} else {
 				stop_critical_timings();
-				if (cpuidle_call_idle())
+				if (cpuidle_idle_call())
 					pm_idle();
 				start_critical_timings();
 				/*
diff --git a/arch/sh/kernel/idle.c b/arch/sh/kernel/idle.c
index 3c45de1..32114e0 100644
--- a/arch/sh/kernel/idle.c
+++ b/arch/sh/kernel/idle.c
@@ -101,7 +101,7 @@ void cpu_idle(void)
 			local_irq_disable();
 			/* Don't trace irqs off for idle */
 			stop_critical_timings();
-			if (cpuidle_call_idle())
+			if (cpuidle_idle_call())
 				pm_idle();
 			/*
 			 * Sanity check to ensure that pm_idle() returns
-- 
1.7.6
