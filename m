Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab1IHXhQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:37:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47543 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755221Ab1IHXhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:37:09 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Liam Girdwood <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Philip Rakity <prakity@marvell.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 1/2] regulator: Fix some bitrot in the machine driver documentation
Date: Thu,  8 Sep 2011 10:41:32 -0700
Message-Id: <1315503693-3785-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation for the machine driver was rather badly bitrotted,
using pointers to struct device rather than dev_name() to hook up the
consumers. Update to use dev_name().

Reported-by: Philip Rakity <prakity@marvell.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 Documentation/power/regulator/machine.txt |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/power/regulator/machine.txt b/Documentation/power/regulator/machine.txt
index b42419b..311c61f 100644
--- a/Documentation/power/regulator/machine.txt
+++ b/Documentation/power/regulator/machine.txt
@@ -16,7 +16,7 @@ initialisation code by creating a struct regulator_consumer_supply for
 each regulator.
 
 struct regulator_consumer_supply {
-	struct device *dev;	/* consumer */
+	const char *dev_name;	/* consumer dev_name() */
 	const char *supply;	/* consumer supply - e.g. "vcc" */
 };
 
@@ -24,13 +24,13 @@ e.g. for the machine above
 
 static struct regulator_consumer_supply regulator1_consumers[] = {
 {
-	.dev	= &platform_consumerB_device.dev,
-	.supply	= "Vcc",
+	.dev_name	= "dev_name(consumer B)",
+	.supply		= "Vcc",
 },};
 
 static struct regulator_consumer_supply regulator2_consumers[] = {
 {
-	.dev	= &platform_consumerA_device.dev,
+	.dev	= "dev_name(consumer A"),
 	.supply	= "Vcc",
 },};
 
-- 
1.7.5.4

