Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302Ab2FGJI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 05:08:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36027 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755569Ab2FGJI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 05:08:27 -0400
Message-ID: <1339060101.5274.5.camel@phoenix>
Subject: [PATCH RFC/RFT] regulator: palmas: Clear
 PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK bits in palmas_set_mode_smps
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Graeme Gregory <gg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Thu, 07 Jun 2012 17:08:21 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code actually clears more bits than PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK bits.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
Hi Graeme,

I'm wandering if we need to clear the status bits.
Current code actually clears bit[7:4] and bit[1:0] and set bit[7:6] to bit[3:2].
Looks like we only need to clear PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK bit[1:0] bits here.
and this change makes the intent more clear.

I don't have this hardware,
I'd appreciate if you can test this patch if you think this change ok.

Regards,
Axel
 drivers/regulator/palmas-regulator.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 92f475c..ae0951a 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -257,8 +257,7 @@ static int palmas_set_mode_smps(struct regulator_dev *dev, unsigned int mode)
 	unsigned int reg;
 
 	palmas_smps_read(pmic->palmas, palmas_regs_info[id].ctrl_addr, &reg);
-	reg &= ~PALMAS_SMPS12_CTRL_STATUS_MASK;
-	reg >>= PALMAS_SMPS12_CTRL_STATUS_SHIFT;
+	reg &= ~PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK;
 
 	switch (mode) {
 	case REGULATOR_MODE_NORMAL:
-- 
1.7.9.5



