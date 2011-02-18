Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932567Ab1BRDLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:11:46 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51879 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932443Ab1BRDIM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:08:12 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org
Subject: [PATCH 15/29] janz: mfd_cell is now implicitly available to drivers (v2)
Date: Thu, 17 Feb 2011 19:07:22 -0800
Message-Id: <1297998456-7615-16-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297998456-7615-1-git-send-email-dilinger@queued.net>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cell's platform_data is now accessed with a helper function;
change clients to use that, and remove the now-unused data_size.

v2: add some missing mfd/core.h includes.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/gpio/janz-ttl.c      |    3 ++-
 drivers/mfd/janz-cmodio.c    |    1 -
 drivers/net/can/janz-ican3.c |    3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/janz-ttl.c b/drivers/gpio/janz-ttl.c
index 813ac07..2514fb0 100644
--- a/drivers/gpio/janz-ttl.c
+++ b/drivers/gpio/janz-ttl.c
@@ -15,6 +15,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
+#include <linux/mfd/core.h>
 #include <linux/io.h>
 #include <linux/gpio.h>
 #include <linux/slab.h>
@@ -149,7 +150,7 @@ static int __devinit ttl_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	pdata = pdev->dev.platform_data;
+	pdata = mfd_get_data(pdev);
 	if (!pdata) {
 		dev_err(dev, "no platform data\n");
 		ret = -ENXIO;
diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index 36a166b..58de1e2 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -87,7 +87,6 @@ static int __devinit cmodio_setup_subdevice(struct cmodio_device *priv,
 	/* Add platform data */
 	pdata->modno = modno;
 	cell->platform_data = pdata;
-	cell->data_size = sizeof(*pdata);
 
 	/* MODULbus registers -- PCI BAR3 is big-endian MODULbus access */
 	res->flags = IORESOURCE_MEM;
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index 366f5cc..102b16c 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -15,6 +15,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
+#include <linux/mfd/core.h>
 
 #include <linux/netdevice.h>
 #include <linux/can.h>
@@ -1643,7 +1644,7 @@ static int __devinit ican3_probe(struct platform_device *pdev)
 	struct device *dev;
 	int ret;
 
-	pdata = pdev->dev.platform_data;
+	pdata = mfd_get_data(pdev);
 	if (!pdata)
 		return -ENXIO;
 
-- 
1.7.2.3

