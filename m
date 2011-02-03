Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1BCESE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 23:18:04 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:40094 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755704Ab1BCESC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 23:18:02 -0500
Date: Wed, 2 Feb 2011 20:17:53 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org
Subject: [PATCH 14/19] janz: mfd_cell is now implicitly available to drivers
Message-ID: <20110202201753.73300ea3@queued.net>
In-Reply-To: <20110202195417.228e2656@queued.net>
References: <20110202195417.228e2656@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


No need to explicitly set the cell's platform_data/data_size.

In this case, move the various platform_data pointers
to driver_data.  All of the clients which make use of it
are also changed.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/gpio/janz-ttl.c      |    2 +-
 drivers/mfd/janz-cmodio.c    |    3 +--
 drivers/net/can/janz-ican3.c |    2 +-
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/janz-ttl.c b/drivers/gpio/janz-ttl.c
index 813ac07..98a3f9d 100644
--- a/drivers/gpio/janz-ttl.c
+++ b/drivers/gpio/janz-ttl.c
@@ -149,7 +149,7 @@ static int __devinit ttl_probe(struct platform_device *pdev)
 	struct resource *res;
 	int ret;
 
-	pdata = pdev->dev.platform_data;
+	pdata = platform_get_drvdata(pdev);
 	if (!pdata) {
 		dev_err(dev, "no platform data\n");
 		ret = -ENXIO;
diff --git a/drivers/mfd/janz-cmodio.c b/drivers/mfd/janz-cmodio.c
index 36a166b..77e3a1f 100644
--- a/drivers/mfd/janz-cmodio.c
+++ b/drivers/mfd/janz-cmodio.c
@@ -86,8 +86,7 @@ static int __devinit cmodio_setup_subdevice(struct cmodio_device *priv,
 
 	/* Add platform data */
 	pdata->modno = modno;
-	cell->platform_data = pdata;
-	cell->data_size = sizeof(*pdata);
+	cell->driver_data = pdata;
 
 	/* MODULbus registers -- PCI BAR3 is big-endian MODULbus access */
 	res->flags = IORESOURCE_MEM;
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index b9a6d7a..7d282c3 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1643,7 +1643,7 @@ static int __devinit ican3_probe(struct platform_device *pdev)
 	struct device *dev;
 	int ret;
 
-	pdata = pdev->dev.platform_data;
+	pdata = platform_get_drvdata(pdev);
 	if (!pdata)
 		return -ENXIO;
 
-- 
1.7.2.3

