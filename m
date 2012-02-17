Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2BQDYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 22:24:19 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41011 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab2BQDYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 22:24:18 -0500
Message-ID: <1329449029.17110.1.camel@phoenix>
Subject: [PATCH 1/2] ARM: U300: Don't specify regulator consumers by struct
 device
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 17 Feb 2012 11:23:49 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev field is remove from struct regulator_consumer_supply since commit
737f36 "regulator: Remove support for supplies specified by struct device".

This fixes below build error:
  CC      arch/arm/mach-u300/i2c.o
arch/arm/mach-u300/i2c.c:63: error: unknown field 'dev' specified in initializer
arch/arm/mach-u300/i2c.c:95: error: unknown field 'dev' specified in initializer
make[1]: *** [arch/arm/mach-u300/i2c.o] Error 1
make: *** [arch/arm/mach-u300] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against linux-next 20120217.

 arch/arm/mach-u300/i2c.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-u300/i2c.c b/arch/arm/mach-u300/i2c.c
index 5140dee..a38f802 100644
--- a/arch/arm/mach-u300/i2c.c
+++ b/arch/arm/mach-u300/i2c.c
@@ -60,7 +60,6 @@ static struct regulator_consumer_supply supply_ldo_c[] = {
  */
 static struct regulator_consumer_supply supply_ldo_d[] = {
 	{
-		.dev = NULL,
 		.supply = "vana15", /* Powers the SoC (CPU etc) */
 	},
 };
@@ -92,7 +91,6 @@ static struct regulator_consumer_supply supply_ldo_k[] = {
  */
 static struct regulator_consumer_supply supply_ldo_ext[] = {
 	{
-		.dev = NULL,
 		.supply = "vext", /* External power */
 	},
 };
-- 
1.7.5.4



