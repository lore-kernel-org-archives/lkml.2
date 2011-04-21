Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755663Ab1DUXEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 19:04:22 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23589 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab1DUXEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 19:04:21 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6323"; a="87027665"
From: Stephen Boyd <sboyd@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH] ARM: Mark broadcast_timer_setup() __cpuinit
Date: Thu, 21 Apr 2011 16:03:57 -0700
Message-Id: <1303427037-12413-1-git-send-email-sboyd@codeaurora.org>
X-Mailer: git-send-email 1.7.5.rc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function is only called by percpu_timer_setup() which is
also __cpuinit marked. Thus it's safe to mark this function as
__cpuinit too.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
---
 arch/arm/kernel/smp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 8fe05ad..f29b8a2 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -479,7 +479,7 @@ static void broadcast_timer_set_mode(enum clock_event_mode mode,
 {
 }
 
-static void broadcast_timer_setup(struct clock_event_device *evt)
+static void __cpuinit broadcast_timer_setup(struct clock_event_device *evt)
 {
 	evt->name	= "dummy_timer";
 	evt->features	= CLOCK_EVT_FEAT_ONESHOT |
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

