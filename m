Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2LZCMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 21:12:20 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:59170 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570Ab2LZCMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 21:12:17 -0500
Message-ID: <1356487927.18626.1.camel@phoenix>
Subject: [PATCH] regulator: lp8755: Fix mask for pchip->mphase
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Daniel Jeong <gshark.jeong@gmail.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 26 Dec 2012 10:12:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to lp8755.h:
enum lp8755_mphase_config {
        MPHASE_CONF0,
        MPHASE_CONF1,
        MPHASE_CONF2,
        MPHASE_CONF3,
        MPHASE_CONF4,
        MPHASE_CONF5,
        MPHASE_CONF6,
        MPHASE_CONF7,
        MPHASE_CONF8,
        MPHASE_CONF_MAX
};

MPHASE_CONF_MAX is 9, the mask for pchip->mphase should be 0x17.
Otherwise, we cannot differentiate MPHASE_CONF0 and MPHASE_CONF8.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
Hi Daniel,
I don't have the datasheet, can you check if this patch is correct?

BTW, I'm Axel, not Alex.

Regards,
Axel
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
+	pchip->mphase = regval & 0x17;
 
 	/* set default data based on multi-phase config */
 	for (icnt = 0; icnt < mphase_buck[pchip->mphase].nreg; icnt++) {
-- 
1.7.9.5



