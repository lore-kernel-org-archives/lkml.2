Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab0IPHEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 03:04:50 -0400
Received: from pegase1.c-s.fr ([194.2.40.7]:53195 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab0IPHEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 03:04:48 -0400
Subject: [PATCH] spi_mpc8xxx: fix writing to adress 0
From: christophe leroy <christophe.leroy@c-s.fr>
To: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Message-Id: <20100916070420.95083C7391@messagerie.si.c-s.fr>
Date: Thu, 16 Sep 2010 09:04:20 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch applies to 2.6.34.7 (already included in 2.6.35.4)
It fixes an issue when sending only or receiving only (mspi->tx-dma was reset as when no tx_buf is defined, tx_dma is 0)

Signed-off-by: christophe leroy <christophe.leroy@c-s.fr>

diff -urN a/drivers/spi/spi_mpc8xxx.c b/drivers/spi/spi_mpc8xxx.c
--- a/drivers/spi/spi_mpc8xxx.c	2010-09-08 16:42:30.000000000 +0200
+++ b/drivers/spi/spi_mpc8xxx.c	2010-09-08 16:43:50.000000000 +0200
@@ -438,7 +438,7 @@
 			dev_err(dev, "unable to map tx dma\n");
 			return -ENOMEM;
 		}
-	} else {
+	} else if (t->tx_buf) {
 		mspi->tx_dma = t->tx_dma;
 	}
 
@@ -449,7 +449,7 @@
 			dev_err(dev, "unable to map rx dma\n");
 			goto err_rx_dma;
 		}
-	} else {
+	} else if (t->rx_buf) {
 		mspi->rx_dma = t->rx_dma;
 	}
