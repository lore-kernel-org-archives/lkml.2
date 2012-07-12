Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab2GLBjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 21:39:16 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40819 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab2GLBjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 21:39:15 -0400
Message-ID: <1342057150.19192.4.camel@phoenix>
Subject: [PATCH 3/3] regulator: s2mps11: Use sec_reg_write rather than
 sec_reg_update when mask is 0xff
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 12 Jul 2012 09:39:10 +0800
In-Reply-To: <1342056950.19192.0.camel@phoenix>
References: <1342056950.19192.0.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/s2mps11.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
index b3c2705..4669dc9 100644
--- a/drivers/regulator/s2mps11.c
+++ b/drivers/regulator/s2mps11.c
@@ -280,8 +280,7 @@ static __devinit int s2mps11_pmic_probe(struct platform_device *pdev)
 			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay2) >> 6;
 		if (s2mps11->buck3_ramp || s2mps11->buck4_ramp)
 			ramp_reg |= get_ramp_delay(s2mps11->ramp_delay34) >> 4;
-		sec_reg_update(iodev, S2MPS11_REG_RAMP,
-			ramp_reg | ramp_enable, 0xff);
+		sec_reg_write(iodev, S2MPS11_REG_RAMP, ramp_reg | ramp_enable);
 	}
 
 	ramp_reg &= 0x00;
@@ -289,7 +288,7 @@ static __devinit int s2mps11_pmic_probe(struct platform_device *pdev)
 	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay16) >> 4;
 	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay7810) >> 2;
 	ramp_reg |= get_ramp_delay(s2mps11->ramp_delay9);
-	sec_reg_update(iodev, S2MPS11_REG_RAMP_BUCK, ramp_reg, 0xff);
+	sec_reg_write(iodev, S2MPS11_REG_RAMP_BUCK, ramp_reg);
 
 	for (i = 0; i < S2MPS11_REGULATOR_MAX; i++) {
 
-- 
1.7.9.5



