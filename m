Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157Ab2FHCEv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 22:04:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50813 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900Ab2FHCEt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 22:04:49 -0400
Message-ID: <1339121082.5794.0.camel@phoenix>
Subject: [PATCH] regulator: isl6271a: Remove setting map_voltage callback
 for isl_fixed_ops
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Marek Vasut <marek.vasut@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 08 Jun 2012 10:04:42 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isl_fixed_ops does not implement set_voltage_sel callback, adding map_voltage
here is misleading.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/isl6271a-regulator.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/regulator/isl6271a-regulator.c b/drivers/regulator/isl6271a-regulator.c
index 4a11b82..1d145a0 100644
--- a/drivers/regulator/isl6271a-regulator.c
+++ b/drivers/regulator/isl6271a-regulator.c
@@ -81,7 +81,6 @@ static int isl6271a_get_fixed_voltage(struct regulator_dev *dev)
 static struct regulator_ops isl_fixed_ops = {
 	.get_voltage	= isl6271a_get_fixed_voltage,
 	.list_voltage	= regulator_list_voltage_linear,
-	.map_voltage	= regulator_map_voltage_linear,
 };
 
 static const struct regulator_desc isl_rd[] = {
-- 
1.7.9.5



