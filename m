Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab2EJPfP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:35:15 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57473 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229Ab2EJPfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:35:12 -0400
Message-ID: <1336664102.15392.1.camel@phoenix>
Subject: [PATCH] mfd: lm3533-core: Fix calling regmap_update_bits() with
 mask and val arguments swapped
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Johan Hovold <jhovold@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 10 May 2012 23:35:02 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code calls regmap_update_bits() with mask and val arguments swapped.
Fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/lm3533-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/lm3533-core.c b/drivers/mfd/lm3533-core.c
index 75f4b7f..4a006c2 100644
--- a/drivers/mfd/lm3533-core.c
+++ b/drivers/mfd/lm3533-core.c
@@ -128,7 +128,7 @@ int lm3533_update(struct lm3533 *lm3533, u8 reg, u8 val, u8 mask)
 
 	dev_dbg(lm3533->dev, "update [%02x]: %02x/%02x\n", reg, val, mask);
 
-	ret = regmap_update_bits(lm3533->regmap, reg, val, mask);
+	ret = regmap_update_bits(lm3533->regmap, reg, mask, val);
 	if (ret < 0) {
 		dev_err(lm3533->dev, "failed to update register %02x: %d\n",
 								reg, ret);
-- 
1.7.5.4



