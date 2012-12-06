Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1424121Ab2LFPzw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:55:52 -0500
Received: from smtp-out-243.synserver.de ([212.40.185.243]:1037 "EHLO
	smtp-out-243.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423878Ab2LFPzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:55:51 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 21383
From: Lars-Peter Clausen <lars@metafoo.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree-discuss@lists.ozlabs.org,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH resend] spi: Add support for specifying 3-wire mode via device tree
Date: Thu,  6 Dec 2012 16:55:33 +0100
Message-Id: <1354809333-18364-1-git-send-email-lars@metafoo.de>
X-Mailer: git-send-email 1.8.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to specify that a SPI device is connected in 3-wire mode via
device tree.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Rob Herring <rob.herring@calxeda.com>
---
 Documentation/devicetree/bindings/spi/spi-bus.txt | 2 ++
 drivers/spi/spi.c                                 | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/Documentation/devicetree/bindings/spi/spi-bus.txt b/Documentation/devicetree/bindings/spi/spi-bus.txt
index 77a8b0d..296015e 100644
--- a/Documentation/devicetree/bindings/spi/spi-bus.txt
+++ b/Documentation/devicetree/bindings/spi/spi-bus.txt
@@ -53,6 +53,8 @@ contain the following properties.
     		shifted clock phase (CPHA) mode
 - spi-cs-high     - (optional) Empty property indicating device requires
     		chip select active high
+- spi-3wire       - (optional) Empty property indicating device requires
+    		    3-wire mode.
 
 If a gpio chipselect is used for the SPI slave the gpio number will be passed
 via the cs_gpio
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 22c71e2..cb61ada 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -861,6 +861,8 @@ static void of_register_spi_devices(struct spi_master *master)
 			spi->mode |= SPI_CPOL;
 		if (of_find_property(nc, "spi-cs-high", NULL))
 			spi->mode |= SPI_CS_HIGH;
+		if (of_find_property(nc, "spi-3wire", NULL))
+			spi->mode |= SPI_3WIRE;
 
 		/* Device speed */
 		prop = of_get_property(nc, "spi-max-frequency", &len);
-- 
1.8.0

