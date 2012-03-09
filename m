Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759445Ab2CIURh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:17:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:54823 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759238Ab2CIURf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 15:17:35 -0500
From: Stephen Warren <swarren@wwwdotorg.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Subject: [PATCH] regmap: Fix missing prototype of devres_alloc() and friends
Date: Fri,  9 Mar 2012 13:17:28 -0700
Message-Id: <1331324248-1599-1-git-send-email-swarren@wwwdotorg.org>
X-Mailer: git-send-email 1.7.0.4
X-NVConfidentiality: public
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

regmap.s uses devres_alloc() and others that are prototyped in device.h.
Include that to solve the following:

drivers/base/regmap/regmap.c: In function 'devm_regmap_init':
drivers/base/regmap/regmap.c:331:2: error: implicit declaration of function 'devres_alloc' [-Werror=implicit-function-declaration]
drivers/base/regmap/regmap.c:338:3: error: implicit declaration of function 'devres_add' [-Werror=implicit-function-declaration]
drivers/base/regmap/regmap.c:340:3: error: implicit declaration of function 'devres_free' [-Werror=implicit-function-declaration]
drivers/base/regmap/regmap.c: In function '_regmap_raw_write':
drivers/base/regmap/regmap.c:421:5: error: implicit declaration of function 'dev_err' [-Werror=implicit-function-declaration]

Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/base/regmap/regmap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e1a4097..7a3f535 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -10,6 +10,7 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/device.h>
 #include <linux/slab.h>
 #include <linux/export.h>
 #include <linux/mutex.h>
-- 
1.7.0.4

