Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab2CUQs3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 12:48:29 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42800 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024Ab2CUQs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 12:48:28 -0400
From: Robert Lee <rob.lee@linaro.org>
To: len.brown@intel.com, nsekhar@ti.com
Cc: khilman@ti.com, amit.kucheria@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-dev@lists.linaro.org,
        patches@linaro.org
Subject: [PATCH] ARM: davinci: Fix for cpuidle consolidation changes
Date: Wed, 21 Mar 2012 11:48:25 -0500
Message-Id: <1332348505-28780-1-git-send-email-rob.lee@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent cpuidle consolidation changes erroneously omitted one
critical line of code.

Signed-off-by: Robert Lee <rob.lee@linaro.org>
---
 arch/arm/mach-davinci/cpuidle.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-davinci/cpuidle.c b/arch/arm/mach-davinci/cpuidle.c
index 93ae096..9107691 100644
--- a/arch/arm/mach-davinci/cpuidle.c
+++ b/arch/arm/mach-davinci/cpuidle.c
@@ -55,10 +55,11 @@ static int davinci_enter_idle(struct cpuidle_device *dev,
 #define DAVINCI_CPUIDLE_FLAGS_DDR2_PWDN	BIT(0)
 
 static struct cpuidle_driver davinci_idle_driver = {
-	.name		= "cpuidle-davinci",
-	.owner		= THIS_MODULE,
-	.states[0]	= ARM_CPUIDLE_WFI_STATE,
-	.states[1]	= {
+	.name			= "cpuidle-davinci",
+	.owner			= THIS_MODULE,
+	.en_core_tk_irqen	= 1,
+	.states[0]		= ARM_CPUIDLE_WFI_STATE,
+	.states[1]		= {
 		.enter			= davinci_enter_idle,
 		.exit_latency		= 10,
 		.target_residency	= 100000,
-- 
1.7.4.1

