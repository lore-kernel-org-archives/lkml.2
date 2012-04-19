Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab2DSBD5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 21:03:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51323 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752799Ab2DSBD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 21:03:56 -0400
Message-ID: <1334797425.2707.1.camel@phoenix>
Subject: [PATCH] regulator: virtual: Replace strict_strtol with kstrtol
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Thu, 19 Apr 2012 09:03:45 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

strict_strtol is deprecated and results in a checkpatch warning.
Replace it with kstrtol.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/virtual.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/regulator/virtual.c b/drivers/regulator/virtual.c
index ee0b161..f2f693e 100644
--- a/drivers/regulator/virtual.c
+++ b/drivers/regulator/virtual.c
@@ -121,7 +121,7 @@ static ssize_t set_min_uV(struct device *dev, struct device_attribute *attr,
 	struct virtual_consumer_data *data = dev_get_drvdata(dev);
 	long val;
 
-	if (strict_strtol(buf, 10, &val) != 0)
+	if (kstrtol(buf, 10, &val) != 0)
 		return count;
 
 	mutex_lock(&data->lock);
@@ -147,7 +147,7 @@ static ssize_t set_max_uV(struct device *dev, struct device_attribute *attr,
 	struct virtual_consumer_data *data = dev_get_drvdata(dev);
 	long val;
 
-	if (strict_strtol(buf, 10, &val) != 0)
+	if (kstrtol(buf, 10, &val) != 0)
 		return count;
 
 	mutex_lock(&data->lock);
@@ -173,7 +173,7 @@ static ssize_t set_min_uA(struct device *dev, struct device_attribute *attr,
 	struct virtual_consumer_data *data = dev_get_drvdata(dev);
 	long val;
 
-	if (strict_strtol(buf, 10, &val) != 0)
+	if (kstrtol(buf, 10, &val) != 0)
 		return count;
 
 	mutex_lock(&data->lock);
@@ -199,7 +199,7 @@ static ssize_t set_max_uA(struct device *dev, struct device_attribute *attr,
 	struct virtual_consumer_data *data = dev_get_drvdata(dev);
 	long val;
 
-	if (strict_strtol(buf, 10, &val) != 0)
+	if (kstrtol(buf, 10, &val) != 0)
 		return count;
 
 	mutex_lock(&data->lock);
-- 
1.7.5.4



