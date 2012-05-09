Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2EIFxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:53:08 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38805 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755869Ab2EIFxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:53:00 -0400
Message-Id: <20120509055036.064659639@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: [ 046/167] [PATCH] spi: Fix device unregistration when unregistering the bus
 master
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 178db7d30f94707efca1a189753c105ef69942ed upstream.

Device are added as children of the bus master's parent device, but
spi_unregister_master() looks for devices to unregister in the bus
master's children. This results in the child devices not being
unregistered.

Fix this by registering devices as direct children of the bus master.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/spi/spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 77eae99..b2ccdea 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -319,7 +319,7 @@ struct spi_device *spi_alloc_device(struct spi_master *master)
 	}
 
 	spi->master = master;
-	spi->dev.parent = dev;
+	spi->dev.parent = &master->dev;
 	spi->dev.bus = &spi_bus_type;
 	spi->dev.release = spidev_release;
 	device_initialize(&spi->dev);
-- 
1.7.10



