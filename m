Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab0JOCZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 22:25:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59124 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab0JOCZj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 22:25:39 -0400
Date: Fri, 15 Oct 2010 13:25:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Erik Gilling <konkers@android.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Subject: linux-next: manual merge of the spi tree with the tegra tree
Message-Id: <20101015132534.f95d5a42.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the spi tree got a conflict in
drivers/spi/Kconfig drivers/spi/Makefile between commit
f4fe02ee997ac4dca9d0888d1d1b8ceb29aae7d6 ("spi: add spi_tegra driver")
from the tegra tree and commit e8b17b5b3f30252b5470dbbf54bc251ddc7fac17
("spi/topcliff: Add topcliff platform controller hub (PCH) spi bus
driver") from the spi tree.

Just overlapping additions.  I fixed it up (see below) and can carry the
fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/spi/Kconfig
index b806078,9949c25..0000000
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@@ -314,13 -313,13 +329,20 @@@ config SPI_STMP3XX
  	help
  	  SPI driver for Freescale STMP37xx/378x SoC SSP interface
  
 +config SPI_TEGRA
 +	tristate "Nvidia Tegra SPI controller"
 +	depends on ARCH_TEGRA
 +	select TEGRA_SYSTEM_DMA
 +	help
 +	  SPI driver for NVidia Tegra SoCs
 +
+ config SPI_TOPCLIFF_PCH
+ 	tristate "Topcliff PCH SPI Controller"
+ 	depends on PCI
+ 	help
+ 	  SPI driver for the Topcliff PCH (Platform Controller Hub) SPI bus
+ 	  used in some x86 embedded processors.
+ 
  config SPI_TXX9
  	tristate "Toshiba TXx9 SPI controller"
  	depends on GENERIC_GPIO && CPU_TX49XX
diff --cc drivers/spi/Makefile
index b6573d8,557aaad..0000000
--- a/drivers/spi/Makefile
+++ b/drivers/spi/Makefile
@@@ -39,7 -39,7 +39,8 @@@ obj-$(CONFIG_SPI_PPC4xx)		+= spi_ppc4xx
  obj-$(CONFIG_SPI_S3C24XX_GPIO)		+= spi_s3c24xx_gpio.o
  obj-$(CONFIG_SPI_S3C24XX)		+= spi_s3c24xx_hw.o
  obj-$(CONFIG_SPI_S3C64XX)		+= spi_s3c64xx.o
 +obj-$(CONFIG_SPI_TEGRA)			+= spi_tegra.o
+ obj-$(CONFIG_SPI_TOPCLIFF_PCH)		+= spi_topcliff_pch.o
  obj-$(CONFIG_SPI_TXX9)			+= spi_txx9.o
  obj-$(CONFIG_SPI_XILINX)		+= xilinx_spi.o
  obj-$(CONFIG_SPI_XILINX_OF)		+= xilinx_spi_of.o
