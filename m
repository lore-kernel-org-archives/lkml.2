Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008Ab1JVHSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 03:18:00 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:62367 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107Ab1JVHR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 03:17:59 -0400
From: Josh Wu <josh.wu@atmel.com>
To: g.liakhovetski@gmx.de, linux-media@vger.kernel.org, plagnioj@jcrosoft.com
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        nicolas.ferre@atmel.com, s.nawrocki@samsung.com,
        Josh Wu <josh.wu@atmel.com>
Subject: [RESEND][PATCH v4 2/3] at91: add parameters for at91_add_device_isi function
Date: Sat, 22 Oct 2011 15:17:39 +0800
Message-Id: <1319267860-32367-1-git-send-email-josh.wu@atmel.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 22 Oct 2011 07:17:41.0932 (UTC) FILETIME=[AFFC0EC0:01CC908A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josh Wu <josh.wu@atmel.com>
---
fix codeing style
using bool instead of int for boolean type


 arch/arm/mach-at91/at91sam9263_devices.c |   13 ++++++++++---
 arch/arm/mach-at91/include/mach/board.h  |    4 +++-
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index a050f41..29d5c01 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -885,7 +885,8 @@ static struct platform_device at91sam9263_isi_device = {
 	.num_resources	= ARRAY_SIZE(isi_resources),
 };
 
-void __init at91_add_device_isi(void)
+void __init at91_add_device_isi(struct isi_platform_data *data,
+		bool use_pck_as_mck)
 {
 	at91_set_A_periph(AT91_PIN_PE0, 0);	/* ISI_D0 */
 	at91_set_A_periph(AT91_PIN_PE1, 0);	/* ISI_D1 */
@@ -898,14 +899,20 @@ void __init at91_add_device_isi(void)
 	at91_set_A_periph(AT91_PIN_PE8, 0);	/* ISI_PCK */
 	at91_set_A_periph(AT91_PIN_PE9, 0);	/* ISI_HSYNC */
 	at91_set_A_periph(AT91_PIN_PE10, 0);	/* ISI_VSYNC */
-	at91_set_B_periph(AT91_PIN_PE11, 0);	/* ISI_MCK (PCK3) */
 	at91_set_B_periph(AT91_PIN_PE12, 0);	/* ISI_PD8 */
 	at91_set_B_periph(AT91_PIN_PE13, 0);	/* ISI_PD9 */
 	at91_set_B_periph(AT91_PIN_PE14, 0);	/* ISI_PD10 */
 	at91_set_B_periph(AT91_PIN_PE15, 0);	/* ISI_PD11 */
+
+	if (use_pck_as_mck) {
+		at91_set_B_periph(AT91_PIN_PE11, 0);	/* ISI_MCK (PCK3) */
+
+		/* TODO: register the PCK for ISI_MCK and set its parent */
+	}
 }
 #else
-void __init at91_add_device_isi(void) {}
+void __init at91_add_device_isi(struct isi_platform_data *data,
+		bool use_pck_as_mck) {}
 #endif
 
 
diff --git a/arch/arm/mach-at91/include/mach/board.h b/arch/arm/mach-at91/include/mach/board.h
index ed544a0..731c449 100644
--- a/arch/arm/mach-at91/include/mach/board.h
+++ b/arch/arm/mach-at91/include/mach/board.h
@@ -183,7 +183,9 @@ extern void __init at91_add_device_lcdc(struct atmel_lcdfb_info *data);
 extern void __init at91_add_device_ac97(struct ac97c_platform_data *data);
 
  /* ISI */
-extern void __init at91_add_device_isi(void);
+struct isi_platform_data;
+extern void __init at91_add_device_isi(struct isi_platform_data *data,
+		bool use_pck_as_mck);
 
  /* Touchscreen Controller */
 struct at91_tsadcc_data {
-- 
1.6.3.3

