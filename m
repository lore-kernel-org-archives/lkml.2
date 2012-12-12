Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226Ab2LLIxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 03:53:25 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37273 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab2LLIxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 03:53:24 -0500
From: Felipe Balbi <balbi@ti.com>
To: <spi-devel-general@lists.sourceforge.net>, <rob@landley.net>,
        <rob.herring@calxeda.com>
CC: <grant.likely@secretlab.ca>, <devicetree-discuss@lists.ozlabs.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 2/2] spi: devicetree: add support for loopback mode
Date: Wed, 12 Dec 2012 10:46:00 +0200
Message-ID: <1355301960-21523-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <1355301960-21523-1-git-send-email-balbi@ti.com>
References: <1355301960-21523-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

there are a few spi master drivers which make
use of that flag but there is no way to pass it
through devicetree.

This patch just creates a way to pass SPI_LOOP
via devicetree.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 Documentation/devicetree/bindings/spi/spi-bus.txt | 2 ++
 drivers/spi/spi.c                                 | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/spi/spi-bus.txt b/Documentation/devicetree/bindings/spi/spi-bus.txt
index 296015e..1949586 100644
--- a/Documentation/devicetree/bindings/spi/spi-bus.txt
+++ b/Documentation/devicetree/bindings/spi/spi-bus.txt
@@ -55,6 +55,8 @@ contain the following properties.
     		chip select active high
 - spi-3wire       - (optional) Empty property indicating device requires
     		    3-wire mode.
+- spi-loopback    - (optional) Empty property indicating device requires
+    		    loopback mode.
 
 If a gpio chipselect is used for the SPI slave the gpio number will be passed
 via the cs_gpio
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 3f1b9ee..6bcdc03 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -868,6 +868,8 @@ static void of_register_spi_devices(struct spi_master *master)
 			spi->mode |= SPI_CS_HIGH;
 		if (of_find_property(nc, "spi-3wire", NULL))
 			spi->mode |= SPI_3WIRE;
+		if (of_find_property(nc, "spi-loopback", NULL))
+			spi->mode |= SPI_LOOP;
 
 		/* Device speed */
 		prop = of_get_property(nc, "spi-max-frequency", &len);
-- 
1.8.1.rc1.5.g7e0651a

