Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964827Ab2B1IwS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 03:52:18 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:35346 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753897Ab2B1IwQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 03:52:16 -0500
From: Haojian Zhuang <hzhuang1@marvell.com>
To: Zhao Ye <zhaoy@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Chao Xie <cxie4@marvell.com>, Leo Yan <leoy@marvell.com>
CC: Zhao Ye <zhaoy@marvell.com>
Date: Tue, 28 Feb 2012 00:41:57 -0800
Subject: RE: [PATCH 00/13] Enable DMA engine for mmp2 and mmp3
Thread-Topic: [PATCH 00/13] Enable DMA engine for mmp2 and mmp3
Thread-Index: Acz16njwSxFlQo6TTEugsc4EYe9k3wAClssN
Message-ID: <25B60CDC2F704E4E9D88FFD52780CB4C060A87D776@SC-VEXCH1.marvell.com>
References: <Y>,<1330414065-2949-1-git-send-email-zhaoy@marvell.com>
In-Reply-To: <1330414065-2949-1-git-send-email-zhaoy@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhao,

Which code base are you using? Now it's kernel v3.3-rc5.

Thanks
Haojian
________________________________________
From: zhaoy [zhaoy@marvell.com]
Sent: Tuesday, February 28, 2012 3:27 PM
To: linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; nicolas.pitre@linaro.org; linux@arm.linux.org.uk; Haojian Zhuang; Chao Xie; Leo Yan
Cc: Zhao Ye
Subject: [PATCH 00/13] Enable DMA engine for mmp2 and mmp3

These patch is for marvell mmp2 and mmp3 platform to enable
dmaengine, use dmaengine to manage the audio dma, video dma
and peripheral device dma together.

zhaoy (13):
  DMA:define second level irq definition
  dmaengine:open dmac and tdma support
  dmaengine: mmp: add two-channel dma driver
  dmaengine:mmp add peripheral dma driver
  mmp2:register dma devices for mmp2 platform
  mmp3:register dma devices for mmp3 platform
  DMA:mmp:remove redundant dma drivers
  DMAC:tty serial pxa use generic dma engine APIs
  DMA:remove unnecessary dma configurations
  dmaengine:audio:mmp audio use generic dma engine APIs
  DMA:update defconfig for mmp3
  mdma:dmaengine:update mdma for tdma
  DMA:update defconfig for mmp2

 arch/arm/configs/mmp2_defconfig           |   23 +-
 arch/arm/configs/mmp3_defconfig           |   21 +-
 arch/arm/mach-mmp/Makefile                |    4 +-
 arch/arm/mach-mmp/include/mach/irqs.h     |   18 +-
 arch/arm/mach-mmp/include/mach/mmp_dma.h  |   89 ++-
 arch/arm/mach-mmp/include/mach/regs-icu.h |   12 +-
 arch/arm/mach-mmp/irq-mmp2.c              |    4 +
 arch/arm/mach-mmp/irq-mmp3.c              |    3 +
 arch/arm/mach-mmp/mmp2.c                  |  122 ++-
 arch/arm/mach-mmp/mmp3.c                  |   78 ++-
 arch/arm/plat-pxa/include/plat/dma.h      |   33 +-
 drivers/char/mmp2_mdma.c                  |  273 ++----
 drivers/dma/Kconfig                       |   19 +
 drivers/dma/Makefile                      |    2 +
 drivers/dma/mmp_tdma.c                    |  858 +++++++++++++++
 drivers/dma/pxa_dmac.c                    | 1077 ++++++++++++++++++
 drivers/tty/serial/Kconfig                |   12 +-
 drivers/tty/serial/Makefile               |    1 +
 drivers/tty/serial/mmp_pxa.c              | 1698 +++++++++++++++++++++++++++++
 sound/soc/pxa/mmp-pcm.c                   |  232 ++--
 sound/soc/pxa/mmp-pcm.h                   |    4 +-
 sound/soc/pxa/mmp2-squ.c                  |  192 ++--
 sound/soc/pxa/mmp2-squ.h                  |    8 +-
 sound/soc/pxa/mmp2-sspa.c                 |   28 +-
 24 files changed, 4361 insertions(+), 450 deletions(-)
 create mode 100644 drivers/dma/mmp_tdma.c
 create mode 100644 drivers/dma/pxa_dmac.c
 create mode 100644 drivers/tty/serial/mmp_pxa.c

