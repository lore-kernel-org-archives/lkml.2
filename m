Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab2BQRwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 12:52:31 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:30744 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534Ab2BQRul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 12:50:41 -0500
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: plagnioj@jcrosoft.com, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/18] ARM: at91/rtc-at91sam9: pass the GPBR to use via ressources
Date: Fri, 17 Feb 2012 18:50:05 +0100
Message-Id: <8187feb330895bf9e077ede21e68cc81a72438cc.1329500622.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
References: <1329501010-30468-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
References: <0d78171672a30e8ec8084f54a557e9948260356d.1329500622.git.nicolas.ferre@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>

The GPBR registers are used for storing RTC values. The GPBR registers
to use are now provided using standard resource entry. The array is
filled in SoC specific code.
rtc-at91sam9 RTT as RTC driver is modified to retrieve this information.

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 arch/arm/mach-at91/at91sam9260_devices.c      |   10 +++++++-
 arch/arm/mach-at91/at91sam9261_devices.c      |    8 ++++++-
 arch/arm/mach-at91/at91sam9263_devices.c      |   16 +++++++++++--
 arch/arm/mach-at91/at91sam9g45_devices.c      |    8 ++++++-
 arch/arm/mach-at91/at91sam9rl_devices.c       |    8 ++++++-
 arch/arm/mach-at91/include/mach/at91sam9260.h |    5 +--
 arch/arm/mach-at91/include/mach/at91sam9261.h |    5 +--
 arch/arm/mach-at91/include/mach/at91sam9263.h |    5 +--
 arch/arm/mach-at91/include/mach/at91sam9g45.h |    5 +--
 arch/arm/mach-at91/include/mach/at91sam9rl.h  |    2 +-
 drivers/rtc/rtc-at91sam9.c                    |   29 +++++++++++++++++++++---
 11 files changed, 76 insertions(+), 25 deletions(-)

diff --git a/arch/arm/mach-at91/at91sam9260_devices.c b/arch/arm/mach-at91/at91sam9260_devices.c
index 2071017..ae2b648 100644
--- a/arch/arm/mach-at91/at91sam9260_devices.c
+++ b/arch/arm/mach-at91/at91sam9260_devices.c
@@ -718,14 +718,16 @@ static struct resource rtt_resources[] = {
 		.start	= AT91SAM9260_BASE_RTT,
 		.end	= AT91SAM9260_BASE_RTT + SZ_16 - 1,
 		.flags	= IORESOURCE_MEM,
-	}
+	}, {
+		.flags	= IORESOURCE_MEM,
+	},
 };
 
 static struct platform_device at91sam9260_rtt_device = {
 	.name		= "at91_rtt",
 	.id		= 0,
 	.resource	= rtt_resources,
-	.num_resources	= ARRAY_SIZE(rtt_resources),
+	.num_resources	= 1,
 };
 
 
@@ -733,6 +735,10 @@ static struct platform_device at91sam9260_rtt_device = {
 static void __init at91_add_device_rtt_rtc(void)
 {
 	at91sam9260_rtt_device.name = "rtc-at91sam9";
+	at91sam9260_rtt_device.num_resources++;
+	rtt_resources[1].start = AT91SAM9260_BASE_GPBR +
+				 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
+	rtt_resources[1].end = rtt_resources[1].start + 3;
 }
 #else
 static void __init at91_add_device_rtt_rtc(void) {}
diff --git a/arch/arm/mach-at91/at91sam9261_devices.c b/arch/arm/mach-at91/at91sam9261_devices.c
index b3ceb97..57dca50 100644
--- a/arch/arm/mach-at91/at91sam9261_devices.c
+++ b/arch/arm/mach-at91/at91sam9261_devices.c
@@ -604,6 +604,8 @@ static struct resource rtt_resources[] = {
 		.start	= AT91SAM9261_BASE_RTT,
 		.end	= AT91SAM9261_BASE_RTT + SZ_16 - 1,
 		.flags	= IORESOURCE_MEM,
+	}, {
+		.flags	= IORESOURCE_MEM,
 	}
 };
 
@@ -611,13 +613,17 @@ static struct platform_device at91sam9261_rtt_device = {
 	.name		= "at91_rtt",
 	.id		= 0,
 	.resource	= rtt_resources,
-	.num_resources	= ARRAY_SIZE(rtt_resources),
+	.num_resources	= 1,
 };
 
 #if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
 static void __init at91_add_device_rtt_rtc(void)
 {
 	at91sam9261_rtt_device.name = "rtc-at91sam9";
+	at91sam9261_rtt_device.num_resources++;
+	rtt_resources[1].start = AT91SAM9261_BASE_GPBR +
+				 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
+	rtt_resources[1].end = rtt_resources[1].start + 3;
 }
 #else
 static void __init at91_add_device_rtt_rtc(void) {}
diff --git a/arch/arm/mach-at91/at91sam9263_devices.c b/arch/arm/mach-at91/at91sam9263_devices.c
index b4a6adb..d042f91 100644
--- a/arch/arm/mach-at91/at91sam9263_devices.c
+++ b/arch/arm/mach-at91/at91sam9263_devices.c
@@ -967,6 +967,8 @@ static struct resource rtt0_resources[] = {
 		.start	= AT91SAM9263_BASE_RTT0,
 		.end	= AT91SAM9263_BASE_RTT0 + SZ_16 - 1,
 		.flags	= IORESOURCE_MEM,
+	}, {
+		.flags	= IORESOURCE_MEM,
 	}
 };
 
@@ -974,7 +976,7 @@ static struct platform_device at91sam9263_rtt0_device = {
 	.name		= "at91_rtt",
 	.id		= 0,
 	.resource	= rtt0_resources,
-	.num_resources	= ARRAY_SIZE(rtt0_resources),
+	.num_resources	= 1,
 };
 
 static struct resource rtt1_resources[] = {
@@ -982,6 +984,8 @@ static struct resource rtt1_resources[] = {
 		.start	= AT91SAM9263_BASE_RTT1,
 		.end	= AT91SAM9263_BASE_RTT1 + SZ_16 - 1,
 		.flags	= IORESOURCE_MEM,
+	}, {
+		.flags	= IORESOURCE_MEM,
 	}
 };
 
@@ -989,28 +993,34 @@ static struct platform_device at91sam9263_rtt1_device = {
 	.name		= "at91_rtt",
 	.id		= 1,
 	.resource	= rtt1_resources,
-	.num_resources	= ARRAY_SIZE(rtt1_resources),
+	.num_resources	= 1,
 };
 
 #if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
 static void __init at91_add_device_rtt_rtc(void)
 {
 	struct platform_device *pdev;
+	struct resource *r;
 
 	switch (CONFIG_RTC_DRV_AT91SAM9_RTT) {
 	case 0:
 		pdev = &at91sam9263_rtt0_device;
+		r = rtt0_resources;
 		break;
 	case 1:
 		pdev = &at91sam9263_rtt1_device;
+		r = rtt1_resources;
 		break;
 	default:
 		pr_err("at91sam9263: support only 2 RTT (%d)\n",
-			 CONFIG_RTC_DRV_AT91SAM9_RTT);
+		       CONFIG_RTC_DRV_AT91SAM9_RTT);
 		return;
 	}
 
+	r[1].start = AT91SAM9263_BASE_GPBR + 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
+	r[1].end = r[1].start + 3;
 	pdev->name = "rtc-at91sam9";
+	pdev->num_resources++;
 }
 #else
 static void __init at91_add_device_rtt_rtc(void) {}
diff --git a/arch/arm/mach-at91/at91sam9g45_devices.c b/arch/arm/mach-at91/at91sam9g45_devices.c
index 81d1adf..d184ae4 100644
--- a/arch/arm/mach-at91/at91sam9g45_devices.c
+++ b/arch/arm/mach-at91/at91sam9g45_devices.c
@@ -1194,6 +1194,8 @@ static struct resource rtt_resources[] = {
 		.start	= AT91SAM9G45_BASE_RTT,
 		.end	= AT91SAM9G45_BASE_RTT + SZ_16 - 1,
 		.flags	= IORESOURCE_MEM,
+	}, {
+		.flags	= IORESOURCE_MEM,
 	}
 };
 
@@ -1201,13 +1203,17 @@ static struct platform_device at91sam9g45_rtt_device = {
 	.name		= "at91_rtt",
 	.id		= 0,
 	.resource	= rtt_resources,
-	.num_resources	= ARRAY_SIZE(rtt_resources),
+	.num_resources	= 1,
 };
 
 #if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
 static void __init at91_add_device_rtt_rtc(void)
 {
 	at91sam9g45_rtt_device.name = "rtc-at91sam9";
+	at91sam9g45_rtt_device.num_resources++;
+	rtt_resources[1].start = AT91SAM9G45_BASE_GPBR +
+				 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
+	rtt_resources[1].end = rtt_resources[1].start + 3;
 }
 #else
 static void __init at91_add_device_rtt_rtc(void) {}
diff --git a/arch/arm/mach-at91/at91sam9rl_devices.c b/arch/arm/mach-at91/at91sam9rl_devices.c
index dd248c8..285dc6b 100644
--- a/arch/arm/mach-at91/at91sam9rl_devices.c
+++ b/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -683,6 +683,8 @@ static struct resource rtt_resources[] = {
 		.start	= AT91SAM9RL_BASE_RTT,
 		.end	= AT91SAM9RL_BASE_RTT + SZ_16 - 1,
 		.flags	= IORESOURCE_MEM,
+	}, {
+		.flags	= IORESOURCE_MEM,
 	}
 };
 
@@ -690,13 +692,17 @@ static struct platform_device at91sam9rl_rtt_device = {
 	.name		= "at91_rtt",
 	.id		= 0,
 	.resource	= rtt_resources,
-	.num_resources	= ARRAY_SIZE(rtt_resources),
+	.num_resources	= 1,
 };
 
 #if IS_ENABLED(CONFIG_RTC_DRV_AT91SAM9)
 static void __init at91_add_device_rtt_rtc(void)
 {
 	at91sam9rl_rtt_device.name = "rtc-at91sam9";
+	at91sam9rl_rtt_device.num_resources++;
+	rtt_resources[1].start = AT91SAM9RL_BASE_GPBR +
+				 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR;
+	rtt_resources[1].end = rtt_resources[1].start + 3;
 }
 #else
 static void __init at91_add_device_rtt_rtc(void) {}
diff --git a/arch/arm/mach-at91/include/mach/at91sam9260.h b/arch/arm/mach-at91/include/mach/at91sam9260.h
index 1524e87..2e47b6d 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9260.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9260.h
@@ -78,10 +78,8 @@
 #define AT91SAM9260_BASE_ADC		0xfffe0000
 
 /*
- * System Peripherals (offset from AT91_BASE_SYS)
+ * System Peripherals
  */
-#define AT91_GPBR	(0xfffffd50 - AT91_BASE_SYS)
-
 #define AT91SAM9260_BASE_ECC	0xffffe800
 #define AT91SAM9260_BASE_SDRAMC	0xffffea00
 #define AT91SAM9260_BASE_SMC	0xffffec00
@@ -95,6 +93,7 @@
 #define AT91SAM9260_BASE_RTT	0xfffffd20
 #define AT91SAM9260_BASE_PIT	0xfffffd30
 #define AT91SAM9260_BASE_WDT	0xfffffd40
+#define AT91SAM9260_BASE_GPBR	0xfffffd50
 
 #define AT91_USART0	AT91SAM9260_BASE_US0
 #define AT91_USART1	AT91SAM9260_BASE_US1
diff --git a/arch/arm/mach-at91/include/mach/at91sam9261.h b/arch/arm/mach-at91/include/mach/at91sam9261.h
index a6a3c1d..44fbdc1 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9261.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9261.h
@@ -63,10 +63,8 @@
 
 
 /*
- * System Peripherals (offset from AT91_BASE_SYS)
+ * System Peripherals
  */
-#define AT91_GPBR	(0xfffffd50 - AT91_BASE_SYS)
-
 #define AT91SAM9261_BASE_SMC	0xffffec00
 #define AT91SAM9261_BASE_MATRIX	0xffffee00
 #define AT91SAM9261_BASE_SDRAMC	0xffffea00
@@ -79,6 +77,7 @@
 #define AT91SAM9261_BASE_RTT	0xfffffd20
 #define AT91SAM9261_BASE_PIT	0xfffffd30
 #define AT91SAM9261_BASE_WDT	0xfffffd40
+#define AT91SAM9261_BASE_GPBR	0xfffffd50
 
 #define AT91_USART0	AT91SAM9261_BASE_US0
 #define AT91_USART1	AT91SAM9261_BASE_US1
diff --git a/arch/arm/mach-at91/include/mach/at91sam9263.h b/arch/arm/mach-at91/include/mach/at91sam9263.h
index dda083d..d96cbb2 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9263.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9263.h
@@ -72,10 +72,8 @@
 #define AT91SAM9263_BASE_2DGE		0xfffc8000
 
 /*
- * System Peripherals (offset from AT91_BASE_SYS)
+ * System Peripherals
  */
-#define AT91_GPBR	(0xfffffd60 - AT91_BASE_SYS)
-
 #define AT91SAM9263_BASE_ECC0	0xffffe000
 #define AT91SAM9263_BASE_SDRAMC0 0xffffe200
 #define AT91SAM9263_BASE_SMC0	0xffffe400
@@ -95,6 +93,7 @@
 #define AT91SAM9263_BASE_PIT	0xfffffd30
 #define AT91SAM9263_BASE_WDT	0xfffffd40
 #define AT91SAM9263_BASE_RTT1	0xfffffd50
+#define AT91SAM9263_BASE_GPBR	0xfffffd60
 
 #define AT91_USART0	AT91SAM9263_BASE_US0
 #define AT91_USART1	AT91SAM9263_BASE_US1
diff --git a/arch/arm/mach-at91/include/mach/at91sam9g45.h b/arch/arm/mach-at91/include/mach/at91sam9g45.h
index a824e15..d052abc 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9g45.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9g45.h
@@ -84,10 +84,8 @@
 #define AT91SAM9G45_BASE_TC5		0xfffd4080
 
 /*
- * System Peripherals (offset from AT91_BASE_SYS)
+ * System Peripherals
  */
-#define AT91_GPBR	(0xfffffd60 - AT91_BASE_SYS)
-
 #define AT91SAM9G45_BASE_ECC	0xffffe200
 #define AT91SAM9G45_BASE_DDRSDRC1 0xffffe400
 #define AT91SAM9G45_BASE_DDRSDRC0 0xffffe600
@@ -106,6 +104,7 @@
 #define AT91SAM9G45_BASE_PIT	0xfffffd30
 #define AT91SAM9G45_BASE_WDT	0xfffffd40
 #define AT91SAM9G45_BASE_RTC	0xfffffdb0
+#define AT91SAM9G45_BASE_GPBR	0xfffffd60
 
 #define AT91_USART0	AT91SAM9G45_BASE_US0
 #define AT91_USART1	AT91SAM9G45_BASE_US1
diff --git a/arch/arm/mach-at91/include/mach/at91sam9rl.h b/arch/arm/mach-at91/include/mach/at91sam9rl.h
index 2d7176a..e0073eb 100644
--- a/arch/arm/mach-at91/include/mach/at91sam9rl.h
+++ b/arch/arm/mach-at91/include/mach/at91sam9rl.h
@@ -70,7 +70,6 @@
  * System Peripherals (offset from AT91_BASE_SYS)
  */
 #define AT91_SCKCR	(0xfffffd50 - AT91_BASE_SYS)
-#define AT91_GPBR	(0xfffffd60 - AT91_BASE_SYS)
 
 #define AT91SAM9RL_BASE_DMA	0xffffe600
 #define AT91SAM9RL_BASE_ECC	0xffffe800
@@ -87,6 +86,7 @@
 #define AT91SAM9RL_BASE_RTT	0xfffffd20
 #define AT91SAM9RL_BASE_PIT	0xfffffd30
 #define AT91SAM9RL_BASE_WDT	0xfffffd40
+#define AT91SAM9RL_BASE_GPBR	0xfffffd60
 #define AT91SAM9RL_BASE_RTC	0xfffffe00
 
 #define AT91_USART0	AT91SAM9RL_BASE_US0
diff --git a/drivers/rtc/rtc-at91sam9.c b/drivers/rtc/rtc-at91sam9.c
index 08b69fd..d49feff 100644
--- a/drivers/rtc/rtc-at91sam9.c
+++ b/drivers/rtc/rtc-at91sam9.c
@@ -57,6 +57,7 @@ struct sam9_rtc {
 	void __iomem		*rtt;
 	struct rtc_device	*rtcdev;
 	u32			imr;
+	void __iomem		*gpbr;
 };
 
 #define rtt_readl(rtc, field) \
@@ -65,9 +66,9 @@ struct sam9_rtc {
 	__raw_writel((val), (rtc)->rtt + AT91_RTT_ ## field)
 
 #define gpbr_readl(rtc) \
-	at91_sys_read(AT91_GPBR + 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR)
+	__raw_readl((rtc)->gpbr)
 #define gpbr_writel(rtc, val) \
-	at91_sys_write(AT91_GPBR + 4 * CONFIG_RTC_DRV_AT91SAM9_GPBR, (val))
+	__raw_writel((val), (rtc)->gpbr)
 
 /*
  * Read current time and date in RTC
@@ -289,14 +290,17 @@ static const struct rtc_class_ops at91_rtc_ops = {
  */
 static int __devinit at91_rtc_probe(struct platform_device *pdev)
 {
-	struct resource	*r;
+	struct resource	*r, *r_gpbr;
 	struct sam9_rtc	*rtc;
 	int		ret;
 	u32		mr;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r)
+	r_gpbr = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+	if (!r || !r_gpbr) {
+		dev_err(&pdev->dev, "need 2 ressources\n");
 		return -ENODEV;
+	}
 
 	rtc = kzalloc(sizeof *rtc, GFP_KERNEL);
 	if (!rtc)
@@ -314,6 +318,20 @@ static int __devinit at91_rtc_probe(struct platform_device *pdev)
 		goto fail;
 	}
 
+	rtc->rtt = ioremap(r->start, resource_size(r));
+	if (!rtc->rtt) {
+		dev_err(&pdev->dev, "failed to map registers, aborting.\n");
+		ret = -ENOMEM;
+		goto fail;
+	}
+
+	rtc->gpbr = ioremap(r_gpbr->start, resource_size(r_gpbr));
+	if (!rtc->gpbr) {
+		dev_err(&pdev->dev, "failed to map gpbr registers, aborting.\n");
+		ret = -ENOMEM;
+		goto fail_gpbr;
+	}
+
 	mr = rtt_readl(rtc, MR);
 
 	/* unless RTT is counting at 1 Hz, re-initialize it */
@@ -356,6 +374,8 @@ static int __devinit at91_rtc_probe(struct platform_device *pdev)
 	return 0;
 
 fail_register:
+	iounmap(rtc->gpbr);
+fail_gpbr:
 	iounmap(rtc->rtt);
 fail:
 	platform_set_drvdata(pdev, NULL);
@@ -377,6 +397,7 @@ static int __devexit at91_rtc_remove(struct platform_device *pdev)
 
 	rtc_device_unregister(rtc->rtcdev);
 
+	iounmap(rtc->gpbr);
 	iounmap(rtc->rtt);
 	platform_set_drvdata(pdev, NULL);
 	kfree(rtc);
-- 
1.7.9

