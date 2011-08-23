Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab1HWH7a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 03:59:30 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:57822 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1HWH73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 03:59:29 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH] SPI: fix build with CONFIG_SPI_FSL_ESPI=m
Date: Tue, 23 Aug 2011 09:59:05 +0200
Message-Id: <1314086345-2818-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When spi_fsl_espi is chosen to be built as a module, there is a build
error because we test only CONFIG_SPI_FSL_ESPI in declaration of
struct mpc8xxx_spi in drivers/spi/spi_fsl_lib.h.

We need to add a test for CONFIG_SPI_FSL_ESPI_MODULE too.

The error looks like:
drivers/spi/spi_fsl_espi.c: In function 'fsl_espi_bufs':
drivers/spi/spi_fsl_espi.c:232: error: 'struct mpc8xxx_spi' has no member named 'len'
...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/spi/spi-fsl-lib.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/spi/spi-fsl-lib.h b/drivers/spi/spi-fsl-lib.h
index cbe881b..97968de 100644
--- a/drivers/spi/spi-fsl-lib.h
+++ b/drivers/spi/spi-fsl-lib.h
@@ -28,7 +28,7 @@ struct mpc8xxx_spi {
 	/* rx & tx bufs from the spi_transfer */
 	const void *tx;
 	void *rx;
-#ifdef CONFIG_SPI_FSL_ESPI
+#if defined(CONFIG_SPI_FSL_ESPI) || defined(CONFIG_SPI_FSL_ESPI_MODULE)
 	int len;
 #endif
 
-- 
1.7.6


