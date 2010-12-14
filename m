Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759330Ab0LNPKM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:10:12 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:39839 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759026Ab0LNPKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:10:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Egt91DcwujjdbbSvHgbaJ1A8mHuJh6Re4HgTb9Oy49Fhf4AfHPooVzaAMWXrsRURk1
         YWMuVS3vZBR9SvHYdQMdwIeTKbvK2CFb/ANGNsqk+oOgL7AvKXfeAK7ME3QsmsKrgXjz
         jp5TCg2o+ZIB0wy51RaTk8SpPEpfM1LloN/yg=
From: Hans Ulli Kroll <ulli.kroll@googlemail.com>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Hans Ulli Kroll <ulli.kroll@googlemail.com>
Subject: [PATCH 2/2] ARM: Gemini: add platform support for Gemini RTC
Date: Tue, 14 Dec 2010 16:08:27 +0100
Message-Id: <1292339307-14336-3-git-send-email-ulli.kroll@googlemail.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1292339307-14336-1-git-send-email-ulli.kroll@googlemail.com>
References: <1292339307-14336-1-git-send-email-ulli.kroll@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adds rtc support for all Gemini SoC boards
nas4220b, rut1xx, wbd111, wbd222

Signed-off-by: Hans Ulli Kroll <ulli.kroll@googlemail.com>
---
 arch/arm/mach-gemini/board-nas4220b.c |    1 +
 arch/arm/mach-gemini/board-rut1xx.c   |    1 +
 arch/arm/mach-gemini/board-wbd111.c   |    1 +
 arch/arm/mach-gemini/board-wbd222.c   |    1 +
 arch/arm/mach-gemini/common.h         |    1 +
 arch/arm/mach-gemini/devices.c        |   26 ++++++++++++++++++++++++++
 6 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-gemini/board-nas4220b.c b/arch/arm/mach-gemini/board-nas4220b.c
index 2ba096d..0cf7a07 100644
--- a/arch/arm/mach-gemini/board-nas4220b.c
+++ b/arch/arm/mach-gemini/board-nas4220b.c
@@ -98,6 +98,7 @@ static void __init ib4220b_init(void)
 	platform_register_pflash(SZ_16M, NULL, 0);
 	platform_device_register(&ib4220b_led_device);
 	platform_device_register(&ib4220b_key_device);
+	platform_register_rtc();
 }
 
 MACHINE_START(NAS4220B, "Raidsonic NAS IB-4220-B")
diff --git a/arch/arm/mach-gemini/board-rut1xx.c b/arch/arm/mach-gemini/board-rut1xx.c
index a9a0d8b..4fa09af 100644
--- a/arch/arm/mach-gemini/board-rut1xx.c
+++ b/arch/arm/mach-gemini/board-rut1xx.c
@@ -82,6 +82,7 @@ static void __init rut1xx_init(void)
 	platform_register_pflash(SZ_8M, NULL, 0);
 	platform_device_register(&rut1xx_leds);
 	platform_device_register(&rut1xx_keys_device);
+	platform_register_rtc();
 }
 
 MACHINE_START(RUT100, "Teltonika RUT100")
diff --git a/arch/arm/mach-gemini/board-wbd111.c b/arch/arm/mach-gemini/board-wbd111.c
index 8b88d50..af7b68a 100644
--- a/arch/arm/mach-gemini/board-wbd111.c
+++ b/arch/arm/mach-gemini/board-wbd111.c
@@ -130,6 +130,7 @@ static void __init wbd111_init(void)
 				 wbd111_num_partitions);
 	platform_device_register(&wbd111_leds_device);
 	platform_device_register(&wbd111_keys_device);
+	platform_register_rtc();
 }
 
 MACHINE_START(WBD111, "Wiliboard WBD-111")
diff --git a/arch/arm/mach-gemini/board-wbd222.c b/arch/arm/mach-gemini/board-wbd222.c
index 1eebcec..99e5bbe 100644
--- a/arch/arm/mach-gemini/board-wbd222.c
+++ b/arch/arm/mach-gemini/board-wbd222.c
@@ -130,6 +130,7 @@ static void __init wbd222_init(void)
 		wbd222_num_partitions);
 	platform_device_register(&wbd222_leds_device);
 	platform_device_register(&wbd222_keys_device);
+	platform_register_rtc();
 }
 
 MACHINE_START(WBD222, "Wiliboard WBD-222")
diff --git a/arch/arm/mach-gemini/common.h b/arch/arm/mach-gemini/common.h
index 9392834..7670c39 100644
--- a/arch/arm/mach-gemini/common.h
+++ b/arch/arm/mach-gemini/common.h
@@ -18,6 +18,7 @@ extern void gemini_map_io(void);
 extern void gemini_init_irq(void);
 extern void gemini_timer_init(void);
 extern void gemini_gpio_init(void);
+extern void platform_register_rtc(void);
 
 /* Common platform devices registration functions */
 extern int platform_register_uart(void);
diff --git a/arch/arm/mach-gemini/devices.c b/arch/arm/mach-gemini/devices.c
index 6b52525..5cff298 100644
--- a/arch/arm/mach-gemini/devices.c
+++ b/arch/arm/mach-gemini/devices.c
@@ -90,3 +90,29 @@ int platform_register_pflash(unsigned int size, struct mtd_partition *parts,
 
 	return platform_device_register(&pflash_device);
 }
+
+static struct resource gemini_rtc_resources[] = {
+	[0] = {
+		.start  = GEMINI_RTC_BASE,
+		.end    = GEMINI_RTC_BASE + 0x24,
+		.flags  = IORESOURCE_MEM,
+	},
+	[1] = {
+		.start  = IRQ_RTC,
+		.end    = IRQ_RTC,
+		.flags  = IORESOURCE_IRQ,
+	},
+};
+
+static struct platform_device gemini_rtc_device = {
+	.name		= "rtc-gemini",
+	.id		= 0,
+	.num_resources	= ARRAY_SIZE(gemini_rtc_resources),
+	.resource	= gemini_rtc_resources,
+};
+
+int __init platform_register_rtc(void)
+{
+	return platform_device_register(&gemini_rtc_device);
+}
+
-- 
1.7.3.2

