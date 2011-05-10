Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1EJLKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 07:10:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39785 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab1EJLKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 07:10:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=L0yxf9i+5vvtQm4rrPZ3OTNz3sBYiZDx0COwnESU6gg49ELnpoFK7OkRWkQtK8zk5K
         LgzWGYFufhlQ+tVnobnY5mesCRMCqSbwCBtGdglbEDizb249m8b5EubxFDipr3WLfxRc
         FWVXtQFPCfkENO/FtyPuivBci2CoEg5B3uSbY=
Subject: [PATCH] Revert "regulator: Move VCOINCELL to be the last element
 of mc13892_regulators array"
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Yong Shen <yong.shen@linaro.org>, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 May 2011 19:10:36 +0800
Message-ID: <1305025836.2569.2.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I check this patch again and found this actually is not a bug
because MC13xxx_DEFINE explictly defines the order of each entry in the array.

Thus revert the patch.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/mc13892-regulator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/mc13892-regulator.c b/drivers/regulator/mc13892-regulator.c
index ba909cb..1b8f739 100644
--- a/drivers/regulator/mc13892-regulator.c
+++ b/drivers/regulator/mc13892-regulator.c
@@ -259,6 +259,7 @@ static struct regulator_ops mc13892_sw_regulator_ops;
 			mc13xxx_regulator_ops)
 
 static struct mc13xxx_regulator mc13892_regulators[] = {
+	MC13892_DEFINE_REGU(VCOINCELL, POWERCTL0, POWERCTL0, mc13892_vcoincell),
 	MC13892_SW_DEFINE(SW1, SWITCHERS0, SWITCHERS0, mc13892_sw1),
 	MC13892_SW_DEFINE(SW2, SWITCHERS1, SWITCHERS1, mc13892_sw),
 	MC13892_SW_DEFINE(SW3, SWITCHERS2, SWITCHERS2, mc13892_sw),
@@ -292,7 +293,6 @@ static struct mc13xxx_regulator mc13892_regulators[] = {
 	MC13892_GPO_DEFINE(GPO4, POWERMISC, mc13892_gpo),
 	MC13892_GPO_DEFINE(PWGT1SPI, POWERMISC, mc13892_pwgtdrv),
 	MC13892_GPO_DEFINE(PWGT2SPI, POWERMISC, mc13892_pwgtdrv),
-	MC13892_DEFINE_REGU(VCOINCELL, POWERCTL0, POWERCTL0, mc13892_vcoincell),
 };
 
 static int mc13892_powermisc_rmw(struct mc13xxx_regulator_priv *priv, u32 mask,
-- 
1.7.1



