Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab2CURzn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:55:43 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:41901 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030Ab2CURzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:55:42 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-5.tower-209.messagelabs.com!1332352517!1250983!32
X-Originating-IP: [216.166.12.97]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] rtc: ep93xx: Use readl/writel for io
Date: Wed, 21 Mar 2012 10:55:31 -0700
User-Agent: KMail/1.9.9
CC: <rtc-linux@googlegroups.com>, <a.zummo@towertech.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201203211055.31653.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drivers should not be using the __raw_* io accessors.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>

---

diff --git a/drivers/rtc/rtc-ep93xx.c b/drivers/rtc/rtc-ep93xx.c
index 14a42a1..60ea585 100644
--- a/drivers/rtc/rtc-ep93xx.c
+++ b/drivers/rtc/rtc-ep93xx.c
@@ -45,7 +45,7 @@ static int ep93xx_rtc_get_swcomp(struct device *dev, unsigned short *preload,
 	struct ep93xx_rtc *ep93xx_rtc = dev->platform_data;
 	unsigned long comp;
 
-	comp = __raw_readl(ep93xx_rtc->mmio_base + EP93XX_RTC_SWCOMP);
+	comp = readl(ep93xx_rtc->mmio_base + EP93XX_RTC_SWCOMP);
 
 	if (preload)
 		*preload = (comp & EP93XX_RTC_SWCOMP_INT_MASK)
@@ -63,7 +63,7 @@ static int ep93xx_rtc_read_time(struct device *dev, struct rtc_time *tm)
 	struct ep93xx_rtc *ep93xx_rtc = dev->platform_data;
 	unsigned long time;
 
-	 time = __raw_readl(ep93xx_rtc->mmio_base + EP93XX_RTC_DATA);
+	 time = readl(ep93xx_rtc->mmio_base + EP93XX_RTC_DATA);
 
 	rtc_time_to_tm(time, tm);
 	return 0;
@@ -73,7 +73,7 @@ static int ep93xx_rtc_set_mmss(struct device *dev, unsigned long secs)
 {
 	struct ep93xx_rtc *ep93xx_rtc = dev->platform_data;
 
-	__raw_writel(secs + 1, ep93xx_rtc->mmio_base + EP93XX_RTC_LOAD);
+	writel(secs + 1, ep93xx_rtc->mmio_base + EP93XX_RTC_LOAD);
 	return 0;
 }
 
