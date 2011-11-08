Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754976Ab1KHKfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 05:35:38 -0500
Received: from ganesha.gnumonks.org ([213.95.27.120]:40146 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab1KHKff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 05:35:35 -0500
From: jhbird.choi@samsung.com
To: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH] driver/rtc/rtc-s3c: Fix driver clock enable/disable balance issues
Date: Tue,  8 Nov 2011 19:14:13 +0900
Message-Id: <1320747253-9281-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonghwan Choi <jhbird.choi@samsung.com>

If an error occurs after clock is enabled, it can become unbalanced.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/rtc/rtc-s3c.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 7639ab9..5b979d9 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -202,7 +202,6 @@ static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
 	void __iomem *base = s3c_rtc_base;
 	int year = tm->tm_year - 100;
 
-	clk_enable(rtc_clk);
 	pr_debug("set time %04d.%02d.%02d %02d:%02d:%02d\n",
 		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
@@ -214,6 +213,7 @@ static int s3c_rtc_settime(struct device *dev, struct rtc_time *tm)
 		return -EINVAL;
 	}
 
+	clk_enable(rtc_clk);
 	writeb(bin2bcd(tm->tm_sec),  base + S3C2410_RTCSEC);
 	writeb(bin2bcd(tm->tm_min),  base + S3C2410_RTCMIN);
 	writeb(bin2bcd(tm->tm_hour), base + S3C2410_RTCHOUR);
-- 
1.7.1

