Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab2HJBhR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 21:37:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52144 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755941Ab2HJBhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 21:37:15 -0400
Message-ID: <1344562629.2996.5.camel@phoenix>
Subject: [PATCH 5/6] regulator: twl: Remove get_voltage implementation for
 single voltage regulators
From: Axel Lin <axel.lin@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Rajendra Nayak <rnayak@ti.com>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        loml <linux-omap@vger.kernel.org>, Graeme Gregory <gg@slimlogic.co.uk>
Date: Fri, 10 Aug 2012 09:37:09 +0800
In-Reply-To: <1344562353.2996.1.camel@phoenix>
References: <1344562353.2996.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not required after commit f7df20ec
"regulator: core: Use list_voltage() to read single voltage regulators"

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/twl-regulator.c |   11 -----------
 1 file changed, 11 deletions(-)

diff --git a/drivers/regulator/twl-regulator.c b/drivers/regulator/twl-regulator.c
index f2f49e2..2d9a2a8 100644
--- a/drivers/regulator/twl-regulator.c
+++ b/drivers/regulator/twl-regulator.c
@@ -624,18 +624,9 @@ static int twlfixed_list_voltage(struct regulator_dev *rdev, unsigned index)
 	return info->min_mV * 1000;
 }
 
-static int twlfixed_get_voltage(struct regulator_dev *rdev)
-{
-	struct twlreg_info	*info = rdev_get_drvdata(rdev);
-
-	return info->min_mV * 1000;
-}
-
 static struct regulator_ops twl4030fixed_ops = {
 	.list_voltage	= twlfixed_list_voltage,
 
-	.get_voltage	= twlfixed_get_voltage,
-
 	.enable		= twl4030reg_enable,
 	.disable	= twl4030reg_disable,
 	.is_enabled	= twl4030reg_is_enabled,
@@ -648,8 +639,6 @@ static struct regulator_ops twl4030fixed_ops = {
 static struct regulator_ops twl6030fixed_ops = {
 	.list_voltage	= twlfixed_list_voltage,
 
-	.get_voltage	= twlfixed_get_voltage,
-
 	.enable		= twl6030reg_enable,
 	.disable	= twl6030reg_disable,
 	.is_enabled	= twl6030reg_is_enabled,
-- 
1.7.9.5



