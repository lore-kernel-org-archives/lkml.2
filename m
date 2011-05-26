Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab1EZJIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:08:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:44058 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751956Ab1EZJIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:08:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,272,1304319600"; 
   d="scan'208";a="2133439"
Date: Thu, 26 May 2011 11:08:27 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Liam Girdwood <lrg@ti.com>
Subject: [PATCH] regulator: Use device platform_data to retrieve db8500
 platform bits
Message-ID: <20110526090827.GC20259@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the addition of a platform device mfd_cell pointer, MFD drivers
can go back to passing platform data back to their sub drivers.
This allows for an mfd_cell->mfd_data removal and thus keep the
sub drivers MFD agnostic. This is mostly needed for non MFD aware
sub drivers.

Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
---
 drivers/regulator/db8500-prcmu.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/db8500-prcmu.c b/drivers/regulator/db8500-prcmu.c
index 1089a96..e5f7b8f 100644
--- a/drivers/regulator/db8500-prcmu.c
+++ b/drivers/regulator/db8500-prcmu.c
@@ -13,7 +13,6 @@
 #include <linux/err.h>
 #include <linux/spinlock.h>
 #include <linux/platform_device.h>
-#include <linux/mfd/core.h>
 #include <linux/mfd/db8500-prcmu.h>
 #include <linux/regulator/driver.h>
 #include <linux/regulator/machine.h>
@@ -471,7 +470,8 @@ static struct db8500_regulator_info
 
 static int __devinit db8500_regulator_probe(struct platform_device *pdev)
 {
-	struct regulator_init_data *db8500_init_data = mfd_get_data(pdev);
+	struct regulator_init_data *db8500_init_data =
+					dev_get_platdata(&pdev->dev);
 	int i, err;
 
 	/* register all regulators */
-- 
1.7.2.3

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
