Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab1AFAb2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 19:31:28 -0500
Received: from kroah.org ([198.145.64.141]:36025 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754636Ab1AFAbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 19:31:25 -0500
X-Mailbox-Line: From gregkh@clark.site Wed Jan  5 16:23:08 2011
Message-Id: <20110106002308.334528428@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 05 Jan 2011 16:23:42 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Florian Fainelli <florian@openwrt.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [123/152] watchdog: Fix null pointer dereference while accessing rdc321x platform_data
In-Reply-To: <20110106002500.GA3172@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/watchdog/rdc321x_wdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -231,7 +231,7 @@ static int __devinit rdc321x_wdt_probe(s
 	struct resource *r;
 	struct rdc321x_wdt_pdata *pdata;
 
-	pdata = pdev->dev.platform_data;
+	pdata = platform_get_drvdata(pdev);
 	if (!pdata) {
 		dev_err(&pdev->dev, "no platform data supplied\n");
 		return -ENODEV;


