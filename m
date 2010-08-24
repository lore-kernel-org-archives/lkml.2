Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755262Ab0HXPMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:12:40 -0400
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:50864 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755114Ab0HXPMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:12:38 -0400
Date: Tue, 24 Aug 2010 17:14:27 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] caif-driver: add HAS_DMA dependency
Message-ID: <20100824151427.GC2160@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Fix this error on an s390 allyesconfig build:

linux-2.6/drivers/net/caif/caif_spi.c:98:
    undefined reference to `dma_free_coherent'

Cc: Sjur Braendeland <sjur.brandeland@stericsson.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 drivers/net/caif/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/caif/Kconfig
+++ b/drivers/net/caif/Kconfig
@@ -15,7 +15,7 @@ config CAIF_TTY
 
 config CAIF_SPI_SLAVE
 	tristate "CAIF SPI transport driver for slave interface"
-	depends on CAIF
+	depends on CAIF && HAS_DMA
 	default n
 	---help---
 	The CAIF Link layer SPI Protocol driver for Slave SPI interface.
