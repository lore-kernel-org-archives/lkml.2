Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759795Ab2EIPJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:09:33 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59132 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503Ab2EIPJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:09:25 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: [PATCH 0/9 v3] extract an shdma base library from shdma.c
Date: Wed,  9 May 2012 17:09:12 +0200
Message-Id: <1336576161-27082-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:pKCoRkM0A71pZOb2DYzU7j4VqtmXvepWJJzxlvpiVTs
 RahOL9OUde4vtsvM5UFNNSqLEGdup3k8Om4uJyd0XtAuyePdp1
 4nqtXjXNvkZ/a7eYkzcnjAPYFdjkwA89SIcIeDhBaIQSW0iLkE
 OL+r6irp5EkPrOdXNG29E3cuz4gFoYJa2rY4R5N6yxiolA8MHh
 Di7uqo5L+B+O0Kja6UYexAqnsoGkVCCmipmwFmm2V7KJdPqrrp
 wOwC3zH0oMMsax3dMDtvHveHLSAjmQigvP1S4KcWar2BuMC7AG
 Pxm8nePhgUzElMXI2az5i/xZzjKW+sxwlKDlXoach9uMreAnZg
 u6/3mmo2AH0hjioasKTpGRilbpIYLVXkJ4uxjWWx3nw1vrKPAi
 QR8W9QsF11y/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v3 of the shdma driver split. It is no longer trying to be 
generic, instead it is kept sh-specific, until we have better conditions 
for making it generic. Apart from moving to an own directory with the 
rest of shdma driver files, it has been updated to the top of the current 
slave-dma tree. The comment from Sascha Hauer to v2 of this patch-set 
has also been addressed - thanks! Two more client drivers have also been 
added - fsi and renesas_usbhs. Would be really great to get it into 3.5 - 
it is blocking the addition of one more DMAC variant.

Guennadi Liakhovetski (9):
  dmaengine: add an shdma-base library
  dma: shdma: prepare for conversion to the shdma base library
  mmc: sh_mmcif: remove unneeded struct sh_mmcif_dma, prepare to shdma
    conversion
  mmc: sh_mobile_sdhi: prepare for conversion to the shdma base library
  serial: sh-sci: prepare for conversion to the shdma base library
  ASoC: siu: prepare for conversion to the shdma base library
  usb: renesas_usbhs: prepare for conversion to the shdma base library
  ASoC: fsi: prepare for conversion to the shdma base library
  dma: shdma: convert to the shdma base library

 drivers/dma/sh/Makefile           |    1 +
 drivers/dma/sh/shdma-base.c       |  868 ++++++++++++++++++++++++++++
 drivers/dma/sh/shdma.c            | 1122 +++++++++----------------------------
 drivers/dma/sh/shdma.h            |   44 +-
 drivers/mmc/host/sh_mmcif.c       |   24 +-
 drivers/mmc/host/sh_mobile_sdhi.c |    8 +-
 drivers/tty/serial/sh-sci.c       |    8 +-
 drivers/usb/renesas_usbhs/fifo.c  |   10 +-
 include/linux/mmc/sh_mmcif.h      |    8 +-
 include/linux/sh_dma.h            |   33 +-
 include/linux/shdma-base.h        |  123 ++++
 sound/soc/sh/fsi.c                |    4 +-
 sound/soc/sh/siu_pcm.c            |    8 +-
 13 files changed, 1326 insertions(+), 935 deletions(-)
 create mode 100644 drivers/dma/sh/shdma-base.c
 create mode 100644 include/linux/shdma-base.h

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
