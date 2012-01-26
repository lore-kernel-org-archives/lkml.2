Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab2AZO54 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 09:57:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64750 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab2AZO4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 09:56:35 -0500
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-serial@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>
Subject: [PATCH 0/7 v2] extract a simple dmaengine library from shdma.c
Date: Thu, 26 Jan 2012 15:56:17 +0100
Message-Id: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:V30xrhOVXt5yY6dgAUpLR1T2DmaaSZjdIYLyx8DwOZI
 3I2zBVgh4KVl3kTSj4zX/DhVbep0VEP/RGxBqgFt0VWkizfovh
 V0a9TE/wXZT5I5a2/iuiS+yEJVdcecHrwNNrj0GujaYXIcenKS
 XNsgY6uzR4A4OypxvNgj9tSwTvBM2x0zTq/c1fAGYtOVser34U
 2IUgJ21JMnvcpJaOOt0BU4lN2vI3T70XaeGCQbgJhR3EOlAGUe
 sH3Otmf5rJKOpXuiTdvvRRhbT/Qh9MyRyFUUKj1Tuh2onEhL4t
 ebDo/mn9XE9ZTf1qOGZizh+9MRW3u+BfXZvM3Bhuow/YqyIX3m
 ukGdRHVVzbX24SuzPjgosdeWfPRJIhutAci2NsQa23yfyZhxYD
 SQEEOqvsZ7fDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v2 of the simple DMA dmaengine library. It addresses Paul's 
comments to v1 - thanks, adds some comments.

Guennadi Liakhovetski (7):
  dmaengine: add a simple dma library
  dma: shdma: prepare for simple DMA conversion
  mmc: sh_mmcif: remove unneeded struct sh_mmcif_dma, prepare for
    simple DMA
  mmc: sh_mobile_sdhi: prepare for conversion to simple DMA
  serial: sh-sci: prepare for conversion to simple DMA
  ASoC: SIU: prepare for conversion to simple DMA
  dma: shdma: convert to the simple DMA library

 drivers/dma/Kconfig               |    4 +
 drivers/dma/Makefile              |    1 +
 drivers/dma/dma-simple.c          |  873 ++++++++++++++++++++++++++++
 drivers/dma/shdma.c               | 1138 +++++++++----------------------------
 drivers/dma/shdma.h               |   45 +-
 drivers/mmc/host/sh_mmcif.c       |   24 +-
 drivers/mmc/host/sh_mobile_sdhi.c |    8 +-
 drivers/tty/serial/sh-sci.c       |    8 +-
 include/linux/dma-simple.h        |  124 ++++
 include/linux/mmc/sh_mmcif.h      |    8 +-
 include/linux/sh_dma.h            |   39 +-
 sound/soc/sh/siu_pcm.c            |    8 +-
 12 files changed, 1334 insertions(+), 946 deletions(-)
 create mode 100644 drivers/dma/dma-simple.c
 create mode 100644 include/linux/dma-simple.h

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
