Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab0KLVuP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 16:50:15 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48800 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422Ab0KLVuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 16:50:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6165"; a="61777440"
From: David Brown <davidb@codeaurora.org>
To: linux-arm-msm@vger.kernel.org, Daniel Walker <dwalker@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>
Subject: [PATCH 2/3] msm: smd: Warning cleanup
Date: Fri, 12 Nov 2010 13:49:52 -0800
Message-Id: <1289598593-8974-2-git-send-email-davidb@codeaurora.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1289598593-8974-1-git-send-email-davidb@codeaurora.org>
References: <1289598593-8974-1-git-send-email-davidb@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Put some variables inside of the same ifdef as the code that uses
them.

arch/arm/mach-msm/smd_debug.c: In function 'smsm_print_sleep_info':
arch/arm/mach-msm/smd_debug.c:274: warning: unused variable 'int_info'
arch/arm/mach-msm/smd_debug.c:273: warning: unused variable 'gpio'

Signed-off-by: David Brown <davidb@codeaurora.org>
---
 arch/arm/mach-msm/smd_debug.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/smd_debug.c b/arch/arm/mach-msm/smd_debug.c
index f91c3b7..8736aff 100644
--- a/arch/arm/mach-msm/smd_debug.c
+++ b/arch/arm/mach-msm/smd_debug.c
@@ -270,8 +270,10 @@ void smsm_print_sleep_info(void)
 {
 	unsigned long flags;
 	uint32_t *ptr;
+#ifndef CONFIG_ARCH_MSM_SCORPION
 	struct tramp_gpio_smem *gpio;
 	struct smsm_interrupt_info *int_info;
+#endif
 
 
 	spin_lock_irqsave(&smem_lock, flags);
-- 
1.7.3.2

Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
