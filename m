Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab2BNDIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:08:21 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50601 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769Ab2BNDIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:08:16 -0500
Message-ID: <1329188887.3132.2.camel@phoenix>
Subject: [PATCH] mfd: s5m-core: Fix val_len parameters for regmap_raw_write
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Tue, 14 Feb 2012 11:08:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The val_len parameters for regmap_raw_write should be "count * sizeof(u8)"
(or simply "count") instead of "count * sizeof(u16)".

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/s5m-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/s5m-core.c b/drivers/mfd/s5m-core.c
index e075c11..2c45427 100644
--- a/drivers/mfd/s5m-core.c
+++ b/drivers/mfd/s5m-core.c
@@ -54,7 +54,7 @@ EXPORT_SYMBOL_GPL(s5m_reg_write);
 
 int s5m_bulk_write(struct s5m87xx_dev *s5m87xx, u8 reg, int count, u8 *buf)
 {
-	return regmap_raw_write(s5m87xx->regmap, reg, buf, count * sizeof(u16));
+	return regmap_raw_write(s5m87xx->regmap, reg, buf, count);
 }
 EXPORT_SYMBOL_GPL(s5m_bulk_write);
 
-- 
1.7.5.4



