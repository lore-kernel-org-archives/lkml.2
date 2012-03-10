Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab2CJASa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 19:18:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47457 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2CJAS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 19:18:28 -0500
Message-ID: <1331338687.18199.1.camel@phoenix>
Subject: [PATCH] regmap: Include linux/device.h to fix build error
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Sat, 10 Mar 2012 08:18:07 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix below build error:

  CC      drivers/base/regmap/regmap.o
drivers/base/regmap/regmap.c: In function 'devm_regmap_init':
drivers/base/regmap/regmap.c:331: error: implicit declaration of function 'devres_alloc'
drivers/base/regmap/regmap.c:331: warning: assignment makes pointer from integer without a cast
drivers/base/regmap/regmap.c:338: error: implicit declaration of function 'devres_add'
drivers/base/regmap/regmap.c:340: error: implicit declaration of function 'devres_free'
drivers/base/regmap/regmap.c: In function '_regmap_raw_write':
drivers/base/regmap/regmap.c:421: error: implicit declaration of function 'dev_err'
make[3]: *** [drivers/base/regmap/regmap.o] Error 1
make[2]: *** [drivers/base/regmap] Error 2
make[1]: *** [drivers/base] Error 2
make: *** [drivers] Error 2

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
This patch is against linux-next 20120309.

 drivers/base/regmap/regmap.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/regmap/regmap.c b/drivers/base/regmap/regmap.c
index e1a4097..3b09587 100644
--- a/drivers/base/regmap/regmap.c
+++ b/drivers/base/regmap/regmap.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/slab.h>
+#include <linux/device.h>
 #include <linux/export.h>
 #include <linux/mutex.h>
 #include <linux/err.h>
-- 
1.7.5.4



