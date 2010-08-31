Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755981Ab0HaASc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 20:18:32 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53596 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab0HaASa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 20:18:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6090"; a="52801944"
From: Gregory Bean <gbean@codeaurora.org>
To: dwalker@codeaurora.org
Cc: linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Gregory Bean <gbean@codeaurora.org>
Subject: [PATCH 2/2] msm: gpio: Add gpiomux calls to request and free.
Date: Mon, 30 Aug 2010 17:18:26 -0700
Message-Id: <1283213906-17671-2-git-send-email-gbean@codeaurora.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>
References: <1283213906-17671-1-git-send-email-gbean@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add gpiomux get and put calls to msmgpio request and free,
in order to allow gpio lines to be properly reference-counted
and power-managed.

Signed-off-by: Gregory Bean <gbean@codeaurora.org>
---
 arch/arm/mach-msm/gpio.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-msm/gpio.c b/arch/arm/mach-msm/gpio.c
index fd899a1..ea93ecb 100644
--- a/arch/arm/mach-msm/gpio.c
+++ b/arch/arm/mach-msm/gpio.c
@@ -21,6 +21,7 @@
 #include <linux/irq.h>
 #include <linux/module.h>
 #include "gpio_hw.h"
+#include "gpiomux.h"
 #include "proc_comm.h"
 #include "smd_private.h"
 
@@ -157,6 +158,16 @@ static int msm_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
 	return MSM_GPIO_TO_INT(chip->base + offset);
 }
 
+static int msm_gpio_request(struct gpio_chip *chip, unsigned offset)
+{
+        return msm_gpiomux_get(chip->base + offset);
+}
+
+static void msm_gpio_free(struct gpio_chip *chip, unsigned offset)
+{
+        msm_gpiomux_put(chip->base + offset);
+}
+
 struct msm_gpio_chip msm_gpio_chips[] = {
 	{
 		.regs = {
@@ -177,6 +188,8 @@ struct msm_gpio_chip msm_gpio_chips[] = {
 			.direction_input = msm_gpio_direction_input,
 			.direction_output = msm_gpio_direction_output,
 			.to_irq = msm_gpio_to_irq,
+			.request = msm_gpio_request,
+			.free = msm_gpio_free,
 		}
 	},
 	{
@@ -202,6 +215,8 @@ struct msm_gpio_chip msm_gpio_chips[] = {
 			.direction_input = msm_gpio_direction_input,
 			.direction_output = msm_gpio_direction_output,
 			.to_irq = msm_gpio_to_irq,
+			.request = msm_gpio_request,
+			.free = msm_gpio_free,
 		}
 	},
 	{
@@ -228,6 +243,8 @@ struct msm_gpio_chip msm_gpio_chips[] = {
 			.direction_input = msm_gpio_direction_input,
 			.direction_output = msm_gpio_direction_output,
 			.to_irq = msm_gpio_to_irq,
+			.request = msm_gpio_request,
+			.free = msm_gpio_free,
 		}
 	},
 	{
@@ -249,6 +266,8 @@ struct msm_gpio_chip msm_gpio_chips[] = {
 			.direction_input = msm_gpio_direction_input,
 			.direction_output = msm_gpio_direction_output,
 			.to_irq = msm_gpio_to_irq,
+			.request = msm_gpio_request,
+			.free = msm_gpio_free,
 		}
 	},
 	{
@@ -274,6 +293,8 @@ struct msm_gpio_chip msm_gpio_chips[] = {
 			.direction_input = msm_gpio_direction_input,
 			.direction_output = msm_gpio_direction_output,
 			.to_irq = msm_gpio_to_irq,
+			.request = msm_gpio_request,
+			.free = msm_gpio_free,
 		}
 	},
 	{
@@ -306,6 +327,8 @@ struct msm_gpio_chip msm_gpio_chips[] = {
 			.direction_input = msm_gpio_direction_input,
 			.direction_output = msm_gpio_direction_output,
 			.to_irq = msm_gpio_to_irq,
+			.request = msm_gpio_request,
+			.free = msm_gpio_free,
 		}
 	},
 #if defined(CONFIG_ARCH_QSD8X50) || defined(CONFIG_ARCH_MSM7X30)
@@ -333,6 +356,8 @@ struct msm_gpio_chip msm_gpio_chips[] = {
 			.direction_input = msm_gpio_direction_input,
 			.direction_output = msm_gpio_direction_output,
 			.to_irq = msm_gpio_to_irq,
+			.request = msm_gpio_request,
+			.free = msm_gpio_free,
 		}
 	},
 	{
@@ -359,6 +384,8 @@ struct msm_gpio_chip msm_gpio_chips[] = {
 			.direction_input = msm_gpio_direction_input,
 			.direction_output = msm_gpio_direction_output,
 			.to_irq = msm_gpio_to_irq,
+			.request = msm_gpio_request,
+			.free = msm_gpio_free,
 		}
 	},
 #endif
-- 
1.7.0.4

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
