Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1BBAuc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:50:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:58790 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852Ab1BBApF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="703028625"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: florian@openwrt.org, sameo@linux.intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [116/139] watchdog: Fix null pointer dereference while accessing rdc321x platform_data
Message-Id: <20110202004515.2EDA63E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Florian Fainelli <florian@openwrt.org>

commit 3b3c1f24e96c411a95daabb6af9e09c5381f713b upstream.

rdc321x-wdt currently fetches its driver specific data by using the
platform_device->platform_data pointer, this is wrong because the mfd
device which registers our platform_device has been added using
mfd_add_device() which sets the platform_device->driver_data pointer
instead.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/watchdog/rdc321x_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/watchdog/rdc321x_wdt.c
===================================================================
--- linux-2.6.35.y.orig/drivers/watchdog/rdc321x_wdt.c
+++ linux-2.6.35.y/drivers/watchdog/rdc321x_wdt.c
@@ -231,7 +231,7 @@ static int __devinit rdc321x_wdt_probe(s
 	struct resource *r;
 	struct rdc321x_wdt_pdata *pdata;
 
-	pdata = pdev->dev.platform_data;
+	pdata = platform_get_drvdata(pdev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;
