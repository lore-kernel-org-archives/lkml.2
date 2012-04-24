Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964801Ab2DXWip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:38:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932914Ab2DXWik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:38:40 -0400
Message-Id: <20120424223256.050256289@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Takahiro AKASHI <akashi@jp.fujitsu.com>
Subject: [ 30/42] spi: Fix device unregistration when unregistering the bus master
In-Reply-To: <20120424223311.GA8456@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Takahiro AKASHI <akashi@jp.fujitsu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -318,7 +318,7 @@ struct spi_device *spi_alloc_device(stru
 	}
 
 	spi->master = master;
-	spi->dev.parent = dev;
+	spi->dev.parent = &master->dev;
 	spi->dev.bus = &spi_bus_type;
 	spi->dev.release = spidev_release;
 	device_initialize(&spi->dev);


