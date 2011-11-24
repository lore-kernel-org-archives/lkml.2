Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681Ab1KXKmH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:42:07 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:42884 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab1KXKmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:42:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: grant.likely@secretlab.ca
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Kumar Gala <galak@kernel.crashing.org>
Subject: [PATCH 1/1] SPI: disable CONFIG_SPI_FSL_ESPI=m build
Date: Thu, 24 Nov 2011 11:41:38 +0100
Message-Id: <1322131298-21511-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Kumar Gala <galak@kernel.crashing.org>
---
 drivers/spi/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 9c90a7a..3d292be 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -198,7 +198,7 @@ config SPI_FSL_LIB
 	depends on FSL_SOC
 
 config SPI_FSL_SPI
-	tristate "Freescale SPI controller"
+	bool "Freescale SPI controller"
 	depends on FSL_SOC
 	select SPI_FSL_LIB
 	help
@@ -207,7 +207,7 @@ config SPI_FSL_SPI
 	  MPC8569 uses the controller in QE mode, MPC8610 in cpu mode.
 
 config SPI_FSL_ESPI
-	tristate "Freescale eSPI controller"
+	bool "Freescale eSPI controller"
 	depends on FSL_SOC
 	select SPI_FSL_LIB
 	help
-- 
1.7.7.3


