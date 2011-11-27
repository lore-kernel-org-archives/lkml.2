Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab1K0CfR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 21:35:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50971 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab1K0CfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 21:35:15 -0500
Message-ID: <1322361308.6779.2.camel@phoenix>
Subject: [PATCH] regulator: Staticise of_get_fixed_voltage_config()
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rajendra Nayak <rnayak@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sun, 27 Nov 2011 10:35:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not used outside this driver so no need to make the symbol global.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/regulator/fixed.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/fixed.c b/drivers/regulator/fixed.c
index 2f917a1..2c220bc 100644
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -51,7 +51,8 @@ struct fixed_voltage_data {
  * tree node, returns a pointer to the populated structure of NULL if memory
  * alloc fails.
  */
-struct fixed_voltage_config *of_get_fixed_voltage_config(struct device *dev)
+static struct fixed_voltage_config *
+of_get_fixed_voltage_config(struct device *dev)
 {
 	struct fixed_voltage_config *config;
 	struct device_node *np = dev->of_node;
-- 
1.7.5.4



