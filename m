Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab2IRSWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 14:22:12 -0400
Received: from mail-yx0-f202.google.com ([209.85.213.202]:46773 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753616Ab2IRSWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 14:22:10 -0400
From: Simon Glass <sjg@chromium.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: "kgene.kim" <kgene.kim@samsung.com>, Ben Dooks <ben-linux@fluff.org>,
        Srinivas KANDAGATLA <srinivas.kandagatla@st.com>,
        Simon Glass <sjg@chromium.org>
Subject: [PATCH 0/7] Add support for Exynos5 ISP SPI ports
Date: Tue, 18 Sep 2012 11:21:52 -0700
Message-Id: <1347992519-6904-1-git-send-email-sjg@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for the two additional SPI ports on exynos,
attached to the ISP.

I have included a required PM patch as well, so that it compiles.

This has been tested using flashrom on SPI1, and a chip to chip SPI
interface (with an STM32 micro) on ISP SPI1.

This series may need more work, but I think it is worth sending out as is.


Prathyush K (1):
  PM / Domains: add generic function 'pm_genpd_of_add_device_by_name'

Simon Glass (6):
  spi: s3c64xx: Fix enum dma_data_direction warning
  spi: s3c64xx: Add support for ISP SPI ports
  spi: s3c64xx: Use jiffies instead of loops for timeout
  spi: s3c64xx: Allow use with SPI ports without dma
  spi: s3c64xx: Tidy up SPI chip select handling
  spi: s3c64xx: Write to PACKET_CNT after reset

 .../devicetree/bindings/spi/spi-samsung.txt        |    7 +
 arch/arm/mach-exynos/clock-exynos5.c               |   69 +++++++++
 arch/arm/mach-exynos/include/mach/map.h            |    2 +
 arch/arm/mach-exynos/include/mach/regs-clock.h     |    1 +
 arch/arm/mach-exynos/mach-exynos5-dt.c             |    4 +
 arch/arm/plat-samsung/include/plat/s3c64xx-spi.h   |    6 +-
 drivers/spi/spi-s3c64xx.c                          |  150 +++++++++++++-------
 include/linux/pm_domain.h                          |   19 +++
 8 files changed, 202 insertions(+), 56 deletions(-)

-- 
1.7.7.3

