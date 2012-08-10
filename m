Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759880Ab2HJV5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 17:57:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21470 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758879Ab2HJV5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 17:57:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6799"; a="224141452"
From: Rohit Vaswani <rvaswani@codeaurora.org>
To: marc.zyngier@arm.com, Russell King <linux@arm.linux.org.uk>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH 1/2] ARM: local timers: Unmask interrupt before new TVAL is set
Date: Fri, 10 Aug 2012 14:57:34 -0700
Message-Id: <1344635854-5033-1-git-send-email-rvaswani@codeaurora.org>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Level triggered interrupt is deasserted when a new TVAL is written
only when the interrupt is unmasked. Make sure that the interrupt
is unmasked in CTL register before TVAL is written.
If this order is not followed, there are chances that on some
hardware you would not receive any timer interrupts.

Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
---
 arch/arm/kernel/arch_timer.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/kernel/arch_timer.c b/arch/arm/kernel/arch_timer.c
index dd58035..1d0d9df 100644
--- a/arch/arm/kernel/arch_timer.c
+++ b/arch/arm/kernel/arch_timer.c
@@ -126,8 +126,8 @@ static int arch_timer_set_next_event(unsigned long evt,
 	ctrl |= ARCH_TIMER_CTRL_ENABLE;
 	ctrl &= ~ARCH_TIMER_CTRL_IT_MASK;
 
-	arch_timer_reg_write(ARCH_TIMER_REG_TVAL, evt);
 	arch_timer_reg_write(ARCH_TIMER_REG_CTRL, ctrl);
+	arch_timer_reg_write(ARCH_TIMER_REG_TVAL, evt);
 
 	return 0;
 }
-- 
Sent by an employee of the Qualcomm Innovation Center,Inc
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

