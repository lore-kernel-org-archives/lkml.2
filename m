Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab1IERyV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:54:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37050 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752051Ab1IERyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:54:16 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/3] regmap: Include the last register in debugfs output
Date: Mon,  5 Sep 2011 10:54:10 -0700
Message-Id: <1315245250-24292-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1315245250-24292-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1315245250-24292-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Off by one in the array iteration.

Reported-by: Jonathan Cameron <jic23@cam.ac.uk>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/base/regmap/regmap-debugfs.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index 7a8d675..6f39747 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -57,7 +57,7 @@ static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 	val_len = 2 * map->format.val_bytes;
 	tot_len = reg_len + val_len + 3;      /* : \n */
 
-	for (i = 0; i < map->max_register; i++) {
+	for (i = 0; i < map->max_register + 1; i++) {
 		if (!regmap_readable(map, i))
 			continue;
 
@@ -132,7 +132,7 @@ static ssize_t regmap_access_read_file(struct file *file,
 	reg_len = regmap_calc_reg_len(map->max_register, buf, count);
 	tot_len = reg_len + 10; /* ': R W V P\n' */
 
-	for (i = 0; i < map->max_register; i++) {
+	for (i = 0; i < map->max_register + 1; i++) {
 		/* Ignore registers which are neither readable nor writable */
 		if (!regmap_readable(map, i) && !regmap_writeable(map, i))
 			continue;
-- 
1.7.5.4

