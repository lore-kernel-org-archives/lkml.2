Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab1HRIU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:20:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:38613 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab1HRIUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:20:24 -0400
X-AuditID: cbfee61b-b7b7fae000005864-e4-4e4ccb457c52
Date: Thu, 18 Aug 2011 17:20:19 +0900
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: [PATCH v2 1/2] rtc: rtc-s3c: Correct debug messages.
In-reply-to: <1313655620-1046-1-git-send-email-myungjoo.ham@samsung.com>
To: linux-kernel@vger.kernel.org
Cc: rtc-linux@googlegroups.com, Alessandro Zummo <a.zummo@towertech.it>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        Changhwan Youn <chaos.youn@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Message-id: <1313655620-1046-2-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
Content-transfer-encoding: 7BIT
References: <1313655620-1046-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 18 Aug 2011 08:21:04.0485 (UTC)
 FILETIME=[C5A1D950:01CC5D7F]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

RTC-S3C used to print out debug messages incorrectly. This patch
corrects incorrect outputs. (undecoded bcd numbers, incorrectly decoded
register values) This patch affects the pr-debug messages only.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

---
Changes from v1
- Removed unnecessary line.
---
 drivers/rtc/rtc-s3c.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/rtc/rtc-s3c.c b/drivers/rtc/rtc-s3c.c
index 9329dbb..067207a 100644
--- a/drivers/rtc/rtc-s3c.c
+++ b/drivers/rtc/rtc-s3c.c
@@ -152,10 +152,6 @@ static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 		goto retry_get_time;
 	}
 
-	pr_debug("read time %04d.%02d.%02d %02d:%02d:%02d\n",
-		 1900 + rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
-		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
-
 	rtc_tm->tm_sec = bcd2bin(rtc_tm->tm_sec);
 	rtc_tm->tm_min = bcd2bin(rtc_tm->tm_min);
 	rtc_tm->tm_hour = bcd2bin(rtc_tm->tm_hour);
@@ -164,6 +160,11 @@ static int s3c_rtc_gettime(struct device *dev, struct rtc_time *rtc_tm)
 	rtc_tm->tm_year = bcd2bin(rtc_tm->tm_year);
 
 	rtc_tm->tm_year += 100;
+
+	pr_debug("read time %04d.%02d.%02d %02d:%02d:%02d\n",
+		 1900 + rtc_tm->tm_year, rtc_tm->tm_mon, rtc_tm->tm_mday,
+		 rtc_tm->tm_hour, rtc_tm->tm_min, rtc_tm->tm_sec);
+
 	rtc_tm->tm_mon -= 1;
 
 	clk_disable(rtc_clk);
@@ -269,10 +270,9 @@ static int s3c_rtc_setalarm(struct device *dev, struct rtc_wkalrm *alrm)
 	clk_enable(rtc_clk);
 	pr_debug("s3c_rtc_setalarm: %d, %04d.%02d.%02d %02d:%02d:%02d\n",
 		 alrm->enabled,
-		 1900 + tm->tm_year, tm->tm_mon, tm->tm_mday,
+		 1900 + tm->tm_year, tm->tm_mon + 1, tm->tm_mday,
 		 tm->tm_hour, tm->tm_min, tm->tm_sec);
 
-
 	alrm_en = readb(base + S3C2410_RTCALM) & S3C2410_RTCALM_ALMEN;
 	writeb(0x00, base + S3C2410_RTCALM);
 
-- 
1.7.4.1

