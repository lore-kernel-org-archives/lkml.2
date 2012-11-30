Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753477Ab2K3FTo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 00:19:44 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:33895 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750806Ab2K3FTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 00:19:42 -0500
Message-ID: <1354252773.23591.1.camel@phoenix>
Subject: [PATCH] regulator: wm831x-dcdc: Ensure selected voltage falls
 within requested range
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Date: Fri, 30 Nov 2012 13:19:33 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use DIV_ROUND_UP to ensure selected voltage won't less than min_uV due to
integer truncation.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/wm831x-dcdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index bce2565..96450f1 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -223,7 +223,7 @@ static int wm831x_buckv_map_voltage(struct regulator_dev *rdev,
 	if (min_uV < 600000)
 		vsel = 0;
 	else if (min_uV <= 1800000)
-		vsel = ((min_uV - 600000) / 12500) + 8;
+		vsel = DIV_ROUND_UP(min_uV - 600000, 12500) + 8;
 	else
 		return -EINVAL;
 
-- 
1.7.9.5



