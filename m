Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751916Ab2C1G6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 02:58:42 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50615 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab2C1G6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 02:58:40 -0400
Message-ID: <1332917909.19101.1.camel@phoenix>
Subject: [PATCH 1/4] regulator: Set list_voltage callback for 88pm8607
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Jett.Zhou" <jtzhou@marvell.com>
Date: Wed, 28 Mar 2012 14:58:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code implements pm8607_list_voltage but does not set the list_voltage
callback function in pm8607_regulator_ops. Fix it.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/88pm8607.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/88pm8607.c b/drivers/regulator/88pm8607.c
index 28b81ae..981b47a 100644
--- a/drivers/regulator/88pm8607.c
+++ b/drivers/regulator/88pm8607.c
@@ -328,6 +328,7 @@ static int pm8607_is_enabled(struct regulator_dev *rdev)
 }
 
 static struct regulator_ops pm8607_regulator_ops = {
+	.list_voltage	= pm8607_list_voltage,
 	.set_voltage	= pm8607_set_voltage,
 	.get_voltage	= pm8607_get_voltage,
 	.enable		= pm8607_enable,
-- 
1.7.5.4



