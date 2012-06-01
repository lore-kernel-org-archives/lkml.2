Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab2FAEQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 00:16:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55590 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966Ab2FAEQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 00:16:36 -0400
Message-ID: <1338524185.3017.1.camel@phoenix>
Subject: [PATCH] regulator: fixed: Use of_match_ptr() for of_match_table
 entry
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Fri, 01 Jun 2012 12:16:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the new of_match_ptr() macro for the of_match_table
pointer entry to avoid having to #define match NULL.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/fixed.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index f09fe7b..8bda365 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -296,8 +296,6 @@ static const struct of_device_id fixed_of_match[] __devinitconst = {
 	{},
 };
 MODULE_DEVICE_TABLE(of, fixed_of_match);
-#else
-#define fixed_of_match NULL
 #endif
 
 static struct platform_driver regulator_fixed_voltage_driver = {
@@ -306,7 +304,7 @@ static struct platform_driver regulator_fixed_voltage_driver = {
 	.driver		= {
 		.name		= "reg-fixed-voltage",
 		.owner		= THIS_MODULE,
-		.of_match_table = fixed_of_match,
+		.of_match_table = of_match_ptr(fixed_of_match),
 	},
 };
 
-- 
1.7.9.5



