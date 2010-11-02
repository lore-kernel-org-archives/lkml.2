Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374Ab0KBBwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 21:52:13 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56411 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704Ab0KBBwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 21:52:08 -0400
Date: Tue, 02 Nov 2010 10:52:01 +0900
From: Kyungmin Park <kmpark@infradead.org>
Subject: [PATCH] rtc: rtc-s3c: Fix type mismatch of alarm_irq_enable
To: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Message-id: <20101102015201.GA6974@july>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 02 Nov 2010 01:52:05.0240 (UTC)
 FILETIME=[8CF9EF80:01CB7A30]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kyungmin Park <kyungmin.park@samsung.com>

Fix type mismatch of alarm_irq_enable

Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/rtc/rtc-s3c.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index cf953ec..4101522 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -77,7 +77,7 @@ static irqreturn_t s3c_rtc_tickirq(int irq, void *id)
 }
 
 /* Update control registers */
-static void s3c_rtc_setaie(int to)
+static int s3c_rtc_setaie(struct device *dev, unsigned int to)
 {
 	unsigned int tmp;
 
@@ -89,6 +89,8 @@ static void s3c_rtc_setaie(int to)
 		tmp |= S3C2410_RTCALM_ALMEN;
 
 	writeb(tmp, s3c_rtc_base + S3C2410_RTCALM);
+
+	return 0;
 }
 
 static int s3c_rtc_setpie(struct device *dev, int enabled)
@@ -308,7 +310,7 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 
 	writeb(alrm_en, base + S3C2410_RTCALM);
 
-	s3c_rtc_setaie(alrm->enabled);
+	s3c_rtc_setaie(dev, alrm->enabled);
 
 	return 0;
 }
@@ -440,7 +442,7 @@ static int __devexit s3c_rtc_remove(struct platform_device *dev)
 	rtc_device_unregister(rtc);
 
 	s3c_rtc_setpie(&dev->dev, 0);
-	s3c_rtc_setaie(0);
+	s3c_rtc_setaie(&dev->dev, 0);
 
 	clk_disable(rtc_clk);
 	clk_put(rtc_clk);
-- 
1.5.3.3

