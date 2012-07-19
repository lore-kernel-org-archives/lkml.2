Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab2GSJbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:31:12 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42723 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752481Ab2GSJbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:31:11 -0400
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: [PATCH] regmap: Fallback to dev_name(map->dev) in case there is no `driver'
Date: Thu, 19 Jul 2012 10:31:05 +0100
Message-Id: <1342690265-4518-1-git-send-email-dp@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.11.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful when we want to use regmap with character devices.

Signed-off-by: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index bb1ff17..c2fbf57 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -39,7 +39,10 @@ static ssize_t regmap_name_read_file(struct file *file,
 	if (!buf)
 		return -ENOMEM;
 
-	ret = snprintf(buf, PAGE_SIZE, "%s\n", map->dev->driver->name);
+	if (map->dev->driver && map->dev->driver->name)
+		ret = snprintf(buf, PAGE_SIZE, "%s\n", map->dev->driver->name);
+	else
+		ret = snprintf(buf, PAGE_SIZE, "%s\n", dev_name(map->dev));
 	if (ret < 0) {
 		kfree(buf);
 		return ret;
-- 
1.7.11.2

