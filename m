Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2EOJXi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 05:23:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:63947 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2EOJXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 05:23:37 -0400
X-AuditID: cbfee61b-b7b94ae000002e44-a6-4fb220989c5a
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 2/3] backlight: adp8870: use kstrtoul()
Date: Tue, 15 May 2012 18:23:36 +0900
Message-id: <001c01cd327c$67e0c650$37a252f0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0yfGfEowSFaJkeRnu9OqhZExb4FQ==
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of strict_strtoul() is not preferred. Thus, kstrtoul
should be used.

Cc: Michael Hennerich <michael.hennerich@analog.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/adp8870_bl.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/video/backlight/adp8870_bl.c b/drivers/video/backlight/adp8870_bl.c
index 9be58c6..c90539b 100644
--- a/drivers/video/backlight/adp8870_bl.c
+++ b/drivers/video/backlight/adp8870_bl.c
@@ -572,7 +572,7 @@ static ssize_t adp8870_store(struct device *dev, const char *buf,
 	unsigned long val;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret)
 		return ret;
 
@@ -652,7 +652,7 @@ static ssize_t adp8870_bl_l1_daylight_max_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct adp8870_bl *data = dev_get_drvdata(dev);
-	int ret = strict_strtoul(buf, 10, &data->cached_daylight_max);
+	int ret = kstrtoul(buf, 10, &data->cached_daylight_max);
 	if (ret)
 		return ret;
 
@@ -794,7 +794,7 @@ static ssize_t adp8870_bl_ambient_light_zone_store(struct device *dev,
 	uint8_t reg_val;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret)
 		return ret;
 
-- 
1.7.1


