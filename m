Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2EOJYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 05:24:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64107 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab2EOJYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 05:24:03 -0400
X-AuditID: cbfee61a-b7bbeae000003a71-4d-4fb220b261cf
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Cc: "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Michael Hennerich'" <michael.hennerich@analog.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Subject: [PATCH 3/3] backlight: adp5520: use kstrtoul()
Date: Tue, 15 May 2012 18:24:02 +0900
Message-id: <001d01cd327c$773fdd20$65bf9760$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0yfHcoHxw9SwLUSL231UcmNknVGg==
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
 drivers/video/backlight/adp5520_bl.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/backlight/adp5520_bl.c b/drivers/video/backlight/adp5520_bl.c
index 4911ea7..df5db99 100644
--- a/drivers/video/backlight/adp5520_bl.c
+++ b/drivers/video/backlight/adp5520_bl.c
@@ -160,7 +160,7 @@ static ssize_t adp5520_store(struct device *dev, const char *buf,
 	unsigned long val;
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &val);
+	ret = kstrtoul(buf, 10, &val);
 	if (ret)
 		return ret;
 
@@ -214,7 +214,7 @@ static ssize_t adp5520_bl_daylight_max_store(struct device *dev,
 	struct adp5520_bl *data = dev_get_drvdata(dev);
 	int ret;
 
-	ret = strict_strtoul(buf, 10, &data->cached_daylight_max);
+	ret = kstrtoul(buf, 10, &data->cached_daylight_max);
 	if (ret < 0)
 		return ret;
 
-- 
1.7.1


