Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759075Ab2BNDal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:30:41 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49514 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab2BNDak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:30:40 -0500
Message-ID: <1329190231.4285.1.camel@phoenix>
Subject: [PATCH] mfd: Make pcf50633_write_block() return 0 on success
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>, Samuel Ortiz <sameo@linux.intel.com>
Date: Tue, 14 Feb 2012 11:30:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The callers of pcf50633_write_block assume pcf50633_write_block return 0 on
success, thus make it return 0 instead of the number of registers written on
success.

Currently pcf50633_write_block is called in drivers/mfd/pcf50633-irq.c and
drivers/rtc/rtc-pcf50633.c.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/pcf50633-core.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index ff1a7e7..189c2f0 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -46,13 +46,7 @@ EXPORT_SYMBOL_GPL(pcf50633_read_block);
 int pcf50633_write_block(struct pcf50633 *pcf , u8 reg,
 					int nr_regs, u8 *data)
 {
-	int ret;
-
-	ret = regmap_raw_write(pcf->regmap, reg, data, nr_regs);
-	if (ret != 0)
-		return ret;
-
-	return nr_regs;
+	return regmap_raw_write(pcf->regmap, reg, data, nr_regs);
 }
 EXPORT_SYMBOL_GPL(pcf50633_write_block);
 
-- 
1.7.5.4



