Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044Ab1BBAw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:52:56 -0500
Received: from mga14.intel.com ([143.182.124.37]:3685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753756Ab1BBAoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:44:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="382960845"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: florian@openwrt.org, sameo@linux.intel.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [107/139] gpio: Fix null pointer dereference while accessing rdc321x platform_data
Message-Id: <20110202004505.B789C3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Florian Fainelli <florian@openwrt.org>

commit fa6469cb5b2d16703464c344b943e2c025cb7858 upstream.

rdc321x-gpio currently fetches its driver specific data by using the
platform_device->platform_data pointer, this is wrong because the mfd
device which registers our platform_device has been added using
mfd_add_device() which sets the platform_device->driver_data pointer
instead.

Signed-off-by: Florian Fainelli <florian@openwrt.org>
Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/gpio/rdc321x-gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/gpio/rdc321x-gpio.c
===================================================================
--- linux-2.6.35.y.orig/drivers/gpio/rdc321x-gpio.c
+++ linux-2.6.35.y/drivers/gpio/rdc321x-gpio.c
@@ -135,7 +135,7 @@ static int __devinit rdc321x_gpio_probe(
 	struct rdc321x_gpio *rdc321x_gpio_dev;
 	struct rdc321x_gpio_pdata *pdata;
 
-	pdata = pdev->dev.platform_data;
+	pdata = platform_get_drvdata(pdev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;
