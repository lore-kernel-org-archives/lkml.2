Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751701Ab2ASGOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 01:14:42 -0500
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:20657
	"EHLO DB3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750829Ab2ASGOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 01:14:40 -0500
X-SpamScore: 3
X-BigFish: VS3(zzzz1202h1082kzzz2dhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
From: Huang Shijie <b32955@freescale.com>
To: <vinod.koul@intel.com>
CC: <shawn.guo@linaro.org>, <artem.bityutskiy@intel.com>, <shijie8@gmail.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mtd@lists.infradead.org>, <linux-mmc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <w.sang@pengutronix.de>,
        <LW@KARO-electronics.de>, <alsa-devel@alsa-project.org>,
        <b29396@freescale.com>, Huang Shijie <b32955@freescale.com>
Subject: [PATCH 00/10] patch set about the MXS-DMA
Date: Thu, 19 Jan 2012 14:15:57 +0800
Message-ID: <1326953767-24155-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set does two things about the MXS-DMA:
[1] patch 1 ~ patch 5: move the mxs dma header to a more common place.
	Beside the mx23/mx28, the APBH-DMA is also used by MX50 and MX6Q.
	So move the mxs dma header file to a more common place, and rename
	it to mxs-dma.h

[2] patch 6 ~ patch 10: rewrite the last parameter of mxs_dma_prep_slave_sg().
	In the new GPMI version, some hardware behavior changes.
	The WAIT4END bit should be set in the middle one of the ECC READ page DMA chain.
	The DMA chain should be set like this:

          +-----+               +-----+                      +-----+
          | cmd | ------------> | cmd | ------------------>  | cmd |
          +-----+               +-----+                      +-----+
                                   ^                            ^
                                   |                            |
                                   |                            |
                              set WAIT4END here too        set WAIT4END here

         Please read the comment in patch "MXS-DMA : add more flags for MXS-DMA".

Huang Shijie (10):
  MXS-DMA : move the mxs-dma.h to a more common place
  MXS-DMA : change the header
  MXS-MMC : change the DMA header file
  MTD/GPMI : change the DMA header file
  ASoc : change the DMA header file
  MXS-DMA : add more flags for MXS-DMA
  MXS-DMA : change the last parameter of mxs_dma_prep_slave_sg()
  MXS-MMC : use the new DMA flags
  MTD/GPMI : add a new field `gpmi_version`
  MTD/GPMI : change the code for new DMA interface

 arch/arm/mach-mxs/include/mach/dma.h   |   28 ----------------
 drivers/dma/mxs-dma.c                  |   12 ++++---
 drivers/mmc/host/mxs-mmc.c             |   12 +++---
 drivers/mtd/nand/gpmi-nand/gpmi-lib.c  |   23 ++++++++++---
 drivers/mtd/nand/gpmi-nand/gpmi-nand.h |    6 +++-
 drivers/mtd/nand/gpmi-nand/gpmi-regs.h |    2 +
 include/linux/mxs-dma.h                |   54 ++++++++++++++++++++++++++++++++
 sound/soc/mxs/mxs-pcm.c                |    2 +-
 sound/soc/mxs/mxs-pcm.h                |    2 +-
 sound/soc/mxs/mxs-saif.c               |    2 +-
 10 files changed, 94 insertions(+), 49 deletions(-)
 delete mode 100644 arch/arm/mach-mxs/include/mach/dma.h
 create mode 100644 include/linux/mxs-dma.h


