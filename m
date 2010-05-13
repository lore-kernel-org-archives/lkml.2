Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab0EMJc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 05:32:26 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56124 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0EMJcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 05:32:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=pq6Q/OIDDyN345xInfqBGpXAbHcaH6Ra86XwtTZ9+2VqEwPXn0Eoi5MCDvEegEqQQW
         t/krCw0wCCJQ0qJs5TFTWprZwWtzEBypvgBXRbxn9tE1VQpa+aCiEFgALa5/C5kdTgWR
         dreJSiyR8CNN8kFSwsQzLtArUtf0smHBrEIVQ=
Subject: [PATCH] Regulators: ab3100/bq24022: add a missing .owner field in
	regulator_desc
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Mattias Wallin <mattias.wallin@stericsson.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain
Date: Thu, 13 May 2010 17:33:01 +0800
Message-Id: <1273743181.10563.4.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a missing .owner field in regulator_desc, which is used for refcounting.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/ab3100.c  |   10 ++++++++++
 drivers/regulator/bq24022.c |    1 +
 2 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/regulator/ab3100.c b/drivers/regulator/ab3100.c
index 7de9509..1afd008 100644
--- a/drivers/regulator/ab3100.c
+++ b/drivers/regulator/ab3100.c
@@ -492,18 +492,21 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.id   = AB3100_LDO_A,
 		.ops  = &regulator_ops_fixed,
 		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
 	},
 	{
 		.name = "LDO_C",
 		.id   = AB3100_LDO_C,
 		.ops  = &regulator_ops_fixed,
 		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
 	},
 	{
 		.name = "LDO_D",
 		.id   = AB3100_LDO_D,
 		.ops  = &regulator_ops_fixed,
 		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
 	},
 	{
 		.name = "LDO_E",
@@ -511,6 +514,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.ops  = &regulator_ops_variable_sleepable,
 		.n_voltages = ARRAY_SIZE(ldo_e_buck_typ_voltages),
 		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
 	},
 	{
 		.name = "LDO_F",
@@ -518,6 +522,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.ops  = &regulator_ops_variable,
 		.n_voltages = ARRAY_SIZE(ldo_f_typ_voltages),
 		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
 	},
 	{
 		.name = "LDO_G",
@@ -525,6 +530,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.ops  = &regulator_ops_variable,
 		.n_voltages = ARRAY_SIZE(ldo_g_typ_voltages),
 		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
 	},
 	{
 		.name = "LDO_H",
@@ -532,6 +538,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.ops  = &regulator_ops_variable,
 		.n_voltages = ARRAY_SIZE(ldo_h_typ_voltages),
 		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
 	},
 	{
 		.name = "LDO_K",
@@ -539,12 +546,14 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.ops  = &regulator_ops_variable,
 		.n_voltages = ARRAY_SIZE(ldo_k_typ_voltages),
 		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
 	},
 	{
 		.name = "LDO_EXT",
 		.id   = AB3100_LDO_EXT,
 		.ops  = &regulator_ops_external,
 		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
 	},
 	{
 		.name = "BUCK",
@@ -552,6 +561,7 @@ ab3100_regulator_desc[AB3100_NUM_REGULATORS] = {
 		.ops  = &regulator_ops_variable_sleepable,
 		.n_voltages = ARRAY_SIZE(ldo_e_buck_typ_voltages),
 		.type = REGULATOR_VOLTAGE,
+		.owner = THIS_MODULE,
 	},
 };
 
diff --git a/drivers/regulator/bq24022.c b/drivers/regulator/bq24022.c
index d08cd9b..068d488 100644
--- a/drivers/regulator/bq24022.c
+++ b/drivers/regulator/bq24022.c
@@ -78,6 +78,7 @@ static struct regulator_desc bq24022_desc = {
 	.name  = "bq24022",
 	.ops   = &bq24022_ops,
 	.type  = REGULATOR_CURRENT,
+	.owner = THIS_MODULE,
 };
 
 static int __init bq24022_probe(struct platform_device *pdev)
-- 
1.5.4.3



