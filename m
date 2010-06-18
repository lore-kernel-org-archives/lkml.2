Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720Ab0FRS0N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 14:26:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26336 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760062Ab0FRS0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 14:26:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6017"; a="44710066"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH] msm: 7x30: Fix init order of 7x30 devices.
Date: Fri, 18 Jun 2010 11:26:05 -0700
Message-Id: <1276885565-28490-1-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the initialization order of MSM7x30 devices to correctly configure
the GPIO lines for the serial UART before probing the device.
If the device tries to come up and use the GPIO line before their
TLMM configuration is done, strange and unpleasant things can happen.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/board-msm7x30.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-msm/board-msm7x30.c b/arch/arm/mach-msm/board-msm7x30.c
index e329819..edd5983 100644
--- a/arch/arm/mach-msm/board-msm7x30.c
+++ b/arch/arm/mach-msm/board-msm7x30.c
@@ -69,11 +69,10 @@ static void __init msm7x30_init_irq(void)
 
 static void __init msm7x30_init(void)
 {
-	platform_add_devices(devices, ARRAY_SIZE(devices));
 #ifdef CONFIG_SERIAL_MSM_CONSOLE
 	msm7x30_init_uart2();
 #endif
-
+	platform_add_devices(devices, ARRAY_SIZE(devices));
 }
 
 static void __init msm7x30_map_io(void)
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
