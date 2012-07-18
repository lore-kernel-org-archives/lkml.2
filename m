Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab2GREcK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 00:32:10 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:33416 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2GREcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 00:32:05 -0400
Message-ID: <1342585919.28942.5.camel@phoenix>
Subject: [RFT][PATCH 3/5] regulator: palmas: Call palmas_ldo_[read|write] in
 palmas_ldo_init
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Date: Wed, 18 Jul 2012 12:31:59 +0800
In-Reply-To: <1342585811.28942.3.camel@phoenix>
References: <1342585811.28942.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code uses wrong calls palmas_smps_[read|write] in palmas_ldo_init(),
should be palmas_ldo_[read|write] instead.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/palmas-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/palmas-regulator.c b/drivers/regulator/palmas-regulator.c
index 9e3e7f3..de68347 100644
--- a/drivers/regulator/palmas-regulator.c
+++ b/drivers/regulator/palmas-regulator.c
@@ -589,7 +589,7 @@ static int palmas_ldo_init(struct palmas *palmas, int id,
 
 	addr = palmas_regs_info[id].ctrl_addr;
 
-	ret = palmas_smps_read(palmas, addr, &reg);
+	ret = palmas_ldo_read(palmas, addr, &reg);
 	if (ret)
 		return ret;
 
@@ -599,7 +599,7 @@ static int palmas_ldo_init(struct palmas *palmas, int id,
 	if (reg_init->mode_sleep)
 		reg |= PALMAS_LDO1_CTRL_MODE_SLEEP;
 
-	ret = palmas_smps_write(palmas, addr, reg);
+	ret = palmas_ldo_write(palmas, addr, reg);
 	if (ret)
 		return ret;
 
-- 
1.7.9.5



