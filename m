Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1LIUdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:33:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51655 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754689Ab1LIUcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:32:47 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net
Subject: [PATCH 3/4] spi/fsl-espi: disable CONFIG_SPI_FSL_ESPI=m build
Date: Fri,  9 Dec 2011 21:32:34 +0100
Message-Id: <1323462755-14369-4-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1323462755-14369-1-git-send-email-w.sang@pengutronix.de>
References: <1323462755-14369-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

When spi_fsl_espi is chosen to be built as a module, there is a build
error because we test only CONFIG_SPI_FSL_ESPI in declaration of
struct mpc8xxx_spi in drivers/spi/spi_fsl_lib.h. Also some called
functions are not exported.

So we forbid CONFIG_SPI_FSL_ESPI to be tristate here.

The error looks like:
drivers/spi/spi_fsl_espi.c: In function 'fsl_espi_bufs':
drivers/spi/spi_fsl_espi.c:232: error: 'struct mpc8xxx_spi' has no member named 'len'
...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Kumar Gala <galak@kernel.crashing.org>
Cc: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/spi/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index a1fd73d..8ba4510 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -199,7 +199,7 @@ config SPI_FSL_LIB
 	depends on FSL_SOC
 
 config SPI_FSL_SPI
-	tristate "Freescale SPI controller"
+	bool "Freescale SPI controller"
 	depends on FSL_SOC
 	select SPI_FSL_LIB
 	help
@@ -208,7 +208,7 @@ config SPI_FSL_SPI
 	  MPC8569 uses the controller in QE mode, MPC8610 in cpu mode.
 
 config SPI_FSL_ESPI
-	tristate "Freescale eSPI controller"
+	bool "Freescale eSPI controller"
 	depends on FSL_SOC
 	select SPI_FSL_LIB
 	help
-- 
1.7.2.5

