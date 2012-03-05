Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756758Ab2CEMEq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 07:04:46 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:38217 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756407Ab2CEMEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 07:04:45 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of axel.lin@gmail.com designates 10.68.208.196 as permitted sender) smtp.mail=axel.lin@gmail.com; dkim=pass header.i=axel.lin@gmail.com
Message-ID: <1330949072.3853.2.camel@phoenix>
Subject: [PATCH RFC/RFT] regulator: Set n_voltages for da9052 regulators
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Date: Mon, 05 Mar 2012 20:04:32 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The n_voltages setting for all LDOs and DCDCs are missing in current code.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/da9052-regulator.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/da9052-regulator.c b/drivers/regulator/da9052-regulator.c
index 3767364..0689ad4 100644
--- a/drivers/regulator/da9052-regulator.c
+++ b/drivers/regulator/da9052-regulator.c
@@ -400,6 +400,7 @@ static struct regulator_ops da9052_ldo_ops = {
 		.ops = &da9052_ldo5_6_ops,\
 		.type = REGULATOR_VOLTAGE,\
 		.id = _id,\
+		.n_voltages = (max - min) / step + 1, \
 		.owner = THIS_MODULE,\
 	},\
 	.min_uV = (min) * 1000,\
@@ -417,6 +418,7 @@ static struct regulator_ops da9052_ldo_ops = {
 		.ops = &da9052_ldo_ops,\
 		.type = REGULATOR_VOLTAGE,\
 		.id = _id,\
+		.n_voltages = (max - min) / step + 1, \
 		.owner = THIS_MODULE,\
 	},\
 	.min_uV = (min) * 1000,\
@@ -434,6 +436,7 @@ static struct regulator_ops da9052_ldo_ops = {
 		.ops = &da9052_dcdc_ops,\
 		.type = REGULATOR_VOLTAGE,\
 		.id = _id,\
+		.n_voltages = (max - min) / step + 1, \
 		.owner = THIS_MODULE,\
 	},\
 	.min_uV = (min) * 1000,\
@@ -451,6 +454,7 @@ static struct regulator_ops da9052_ldo_ops = {
 		.ops = &da9052_buckperi_ops,\
 		.type = REGULATOR_VOLTAGE,\
 		.id = _id,\
+		.n_voltages = (max - min) / step + 1, \
 		.owner = THIS_MODULE,\
 	},\
 	.min_uV = (min) * 1000,\
-- 
1.7.5.4



