Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab1E2KMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 06:12:17 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36006 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab1E2KMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 06:12:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=jPD5o/Gv79BUnVwdvyxnS6koX46LhjelwJvUslAIAcE7dgIz7chxP18Y2jb3WoxX2G
         qiat4x/3KJjLi+76698xxTix4YiR6RP//CVteX1CphgF9nSBJBYG0ZN/QQSIu2NzYzRm
         Hu+LgJWD0EVP1+ibaDqxNf4eljiJpf5aycQvA=
From: Mika Westerberg <mika.westerberg@iki.fi>
To: linux-arm-kernel@lists.infradead.org
Cc: hsweeten@visionengravers.com, rmallon@gmail.com, vinod.koul@intel.com,
        dan.j.williams@intel.com, lrg@ti.com,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        Mika Westerberg <mika.westerberg@iki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/5] ep93xx DMA patches
Date: Sun, 29 May 2011 13:10:01 +0300
Message-Id: <cover.1306662317.git.mika.westerberg@iki.fi>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an updated version of the ep93xx DMA patches. Previous version can be
found here: https://lkml.org/lkml/2011/5/22/86.

Changes to v1:
 * removed unnecessary header
 * corrected SPI driver documentation
 * DMA driver platform code is only compiled when CONFIG_EP93XX_DMA is
   enabled

I tried to put all the acks in place, hope I got them right.

There is a dependency between patch 1 and patch 4 which I'm not entirely sure
how to solve. Basically it is required that we have patch 1 applied before
patch 4 or merge conflict results.

Otherwise it shouldn't matter in which order the patches arrive to the
mainline.

Unless someone has a better idea, I suggest that these patches will go through
their respective subsystem trees. All the maintainers should be copied.

Thanks,
MW

Mika Westerberg (5):
  dmaengine: add ep93xx DMA support
  ep93xx: add dmaengine platform code
  ASoC: ep93xx: convert to use the DMA engine API
  ep93xx: remove the old M2P DMA code
  spi/ep93xx: add DMA support

 Documentation/spi/ep93xx_spi                   |   10 +
 arch/arm/mach-ep93xx/Makefile                  |    4 +-
 arch/arm/mach-ep93xx/core.c                    |    6 +-
 arch/arm/mach-ep93xx/dma-m2p.c                 |  411 -------
 arch/arm/mach-ep93xx/dma.c                     |  108 ++
 arch/arm/mach-ep93xx/include/mach/dma.h        |  190 ++---
 arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h |    2 +
 drivers/dma/Kconfig                            |    7 +
 drivers/dma/Makefile                           |    1 +
 drivers/dma/ep93xx_dma.c                       | 1355 ++++++++++++++++++++++++
 drivers/spi/ep93xx_spi.c                       |  303 +++++-
 sound/soc/ep93xx/ep93xx-ac97.c                 |    4 +-
 sound/soc/ep93xx/ep93xx-i2s.c                  |    4 +-
 sound/soc/ep93xx/ep93xx-pcm.c                  |  137 ++--
 14 files changed, 1930 insertions(+), 612 deletions(-)
 delete mode 100644 arch/arm/mach-ep93xx/dma-m2p.c
 create mode 100644 arch/arm/mach-ep93xx/dma.c
 create mode 100644 drivers/dma/ep93xx_dma.c

-- 
1.7.4.4

