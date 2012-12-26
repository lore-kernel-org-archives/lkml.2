Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab2LZD4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 22:56:51 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:64044 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab2LZD4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 22:56:48 -0500
Message-ID: <1356494197.19944.0.camel@phoenix>
Subject: [PATCH v2] regulator: lp8755: Fix mask for pchip->mphase
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Jeong <gshark.jeong@gmail.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Dec 2012 11:56:37 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the datasheet, it has 9 multi-phase mode from 0 to 8 and it takes
4 bits in the register.
The mask for pchip->mphase should be 0x0F.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
v2. the mask should be 0x0f rather than 0x17.

 drivers/regulator/lp8755.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/lp8755.c b/drivers/regulator/lp8755.c
index 06a82e2..6d5a11d 100644
--- a/drivers/regulator/lp8755.c
+++ b/drivers/regulator/lp8755.c
@@ -301,7 +301,7 @@ static int lp8755_init_data(struct lp8755_chip *pchip)
 	ret = lp8755_read(pchip, 0x3D, &regval);
 	if (ret < 0)
 		goto out_i2c_error;
-	pchip->mphase = regval & 0x07;
+	pchip->mphase = regval & 0x0F;
 
 	/* set default data based on multi-phase config */
 	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++) {
-- 
1.7.9.5



