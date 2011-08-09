Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab1HIOfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:35:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36558 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753040Ab1HIOfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:35:37 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: linux-kernel@vger.kernel.org
Cc: patches@opensource.wolfsonmicro.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] regmap: Fix type of field width specifiers for x86_64
Date: Tue,  9 Aug 2011 17:00:05 +0900
Message-Id: <1312876805-460-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1312876805-460-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1312876805-460-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 size_t is not an int but the printf format specifier for size_t
should be an int.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/base/regmap/regmap-debugfs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/base/regmap/regmap-debugfs.c b/drivers/base/regmap/regmap-debugfs.c
index d1bd680..068deae 100644
--- a/drivers/base/regmap/regmap-debugfs.c
+++ b/drivers/base/regmap/regmap-debugfs.c
@@ -36,7 +36,7 @@ static int regmap_open_file(struct inode *inode, struct file *file)
 static ssize_t regmap_map_read_file(struct file *file, char __user *user_buf,
 				    size_t count, loff_t *ppos)
 {
-	size_t reg_len, val_len, tot_len;
+	int reg_len, val_len, tot_len;
 	size_t buf_pos = 0;
 	loff_t p = 0;
 	ssize_t ret;
-- 
1.7.5.4

