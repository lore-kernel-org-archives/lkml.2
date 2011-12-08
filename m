Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab1LHNEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 08:04:24 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45915 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab1LHNEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 08:04:23 -0500
Message-ID: <1323349452.2823.1.camel@phoenix>
Subject: [PATCH 1/2] hwmon: jz4740: fix signedness bug
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>, Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Date: Thu, 08 Dec 2011 21:04:12 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wait_for_completion_interruptible_timeout() may return negative value.
In this case, checking if (t > 0)  will return true if t is unsigned.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/hwmon/jz4740-hwmon.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/jz4740-hwmon.c b/drivers/hwmon/jz4740-hwmon.c
index 7a48b1e..3d7e590 100644
--- a/drivers/hwmon/jz4740-hwmon.c
+++ b/drivers/hwmon/jz4740-hwmon.c
@@ -59,7 +59,7 @@ static ssize_t jz4740_hwmon_read_adcin(struct device *dev,
 {
 	struct jz4740_hwmon *hwmon = dev_get_drvdata(dev);
 	struct completion *completion = &hwmon->read_completion;
-	unsigned long t;
+	long t;
 	unsigned long val;
 	int ret;
 
-- 
1.7.5.4



