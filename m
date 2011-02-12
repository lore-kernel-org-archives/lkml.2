Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758277Ab1BLCRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 21:17:37 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:56551 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148Ab1BLCRg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 21:17:36 -0500
Date: Fri, 11 Feb 2011 18:17:33 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org
Subject: [PATCH 15/17] janz: mfd_cell is now implicitly available to drivers
Message-ID: <20110211181733.38a49ad8@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The cell's platform_data is now accessed with a helper function;
change clients to use that, and remove the now-unused data_size.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/gpio/janz-ttl.c      |    2 +-
 drivers/mfd/janz-cmodio.c    |    1 -
 drivers/net/can/janz-ican3.c |    2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/janz-ttl.c b/drivers/gpio/janz-ttl.c
index 813ac07..ef399ee 100644
--- a/drivers/gpio/janz-ttl.c
+++ b/drivers/gpio/janz-ttl.c
@@ -149,7 +149,7 @@ static int __devinit ttl_probe(struct platform_device *pdev)
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
index 366f5cc..bc2b15b 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1643,7 +1643,7 @@ static int __devinit ican3_probe(struct platform_device *pdev)
 	struct device *dev;
 	int ret;
 
-	pdata = pdev->dev.platform_data;
+	pdata = mfd_get_data(pdev);
 	if (!pdata)
 		return -ENXIO;
 
-- 
1.7.2.3

