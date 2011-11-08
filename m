Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933101Ab1KHSeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 13:34:20 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8128 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933063Ab1KHSeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 13:34:18 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6524"; a="135802403"
From: Stephen Boyd <sboyd@codeaurora.org>
To: David Brown <davidb@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/8] MSM timer fixes and cleanups
Date: Tue,  8 Nov 2011 10:34:02 -0800
Message-Id: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.8.rc0.46.g5ae0f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently the MSM timers use the same physical counter
for the clockevent and clocksource. This works as long
as the clocksource isn't stopped from ticking during normal
operation but unfortunately that isn't the case and the
clocksource is stopped when the clockevent is shutdown.
Even worse, switching the clocksource via sysfs at runtime will
hang the system.

This series reorganizes the MSM timer code so that one counter
is only used for either a clocksource or a clockevent, and not 
both. In the process we reduce the lines of code and fix
a few long-standing bugs.

I plan to add sched_clock support on top of this series once the
ARM generic patches are posted again (hopefully next week).

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Marc Zyngier <marc.zyngier@arm.com>

Stephen Boyd (8):
  msm: timer: Tighten #ifdef for local timer support
  msm: timer: Cleanup #includes and #defines
  msm: timer: Use GPT for clockevents and DGT for clocksource
  msm: timer: Fix ONESHOT mode interrupts
  msm: timer: Remove msm_clocks[] and simplify code
  msm: timer: Remove SoC specific #ifdefs
  msm: timer: Setup interrupt after registering clockevent
  msm: timer: Use clockevents_config_and_register()

 arch/arm/mach-msm/timer.c |  347 ++++++++++++++++-----------------------------
 1 files changed, 124 insertions(+), 223 deletions(-)

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

