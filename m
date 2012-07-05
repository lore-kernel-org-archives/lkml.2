Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab2GEK3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 06:29:53 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:61000 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240Ab2GEK3t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 06:29:49 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/7 v2] dma: sh: stop using .private
Date: Thu,  5 Jul 2012 12:29:36 +0200
Message-Id: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:+X+ATXhrYM3VIdmTeVIF+eKRusn0TOtRfB9xWfjyeWj
 HOFxZiBNXXXovTtImJZ4A3Ho4qH8dXfHdjxEl+A442BJUabYx+
 5Fjwpmf5waKyLCyd8tm88YC63WRt+ixDDzhZn8QVjzCZG1Ycs8
 JDBRxNka5GKEINeLXaAnmBBG7ZgXbSyPjH9bBk7ff3AxzKRodB
 70e7wTHgjnMF9MCIojeMZf+VrY2AStNaMn3thRda/rxaaV3z/e
 pHdoPCbVCH/fxEL6VjfRty+U4owVwu58LHP1t8J/Sr7ejaLqC3
 2P14hbf/bwqjfLbMPIRNHMJIwyR3F3mglRJRnsBPdxrplnQ+uW
 bMyd8HZvYJUMKGZhjMHAwSXe1dE8/lmqDEv4vd4r5cbhhuGBmk
 heUHF0Ahjz/4A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series supersedes the one from yesterday with the same title. 
The 4 patches from v1 are all unchanged, v2 just prepends them with 3 more 
preparatory patches. From the original series description:

Here's an attempt to convert the shdma driver to a new method, whereby a 
centrally provided filter function is used and the DMA_SLAVE_CONFIG command 
is enabled for slave operation. The last patch is an illustration of how 
this new method shall be used. If this approach is acceptable, I'll also 
convert the remaining shdma user drivers. This patch series goes on top of 
my earlier patches to split shdma.c.

As suggested yesterday, I've pushed both my current shdma patch series to 
github in branches:

git://github.com/lyakh/linux.git shdma-base
git://github.com/lyakh/linux.git shdma-config

for the preceding base shdma-split series and for this one respectively.

As before, the last patch in the series is FYI only for now.

Guennadi Liakhovetski (7):
  dmaengine: shdma: (cosmetic) simplify a static function
  ASoC: siu: don't use DMA device for channel filtering
  sh: remove unused DMA device pointer from SIU platform data
  dmaengine: shdma: prepare to stop using struct dma_chan::private
  dma: sh: use an integer slave ID to improve API compatibility
  dma: sh: provide a migration path for slave drivers to stop using
    .private
  mmc: sh_mmcif: switch to the new DMA channel allocation and
    configuration

 arch/sh/include/asm/siu.h              |    1 -
 arch/sh/kernel/cpu/sh4a/setup-sh7722.c |    1 -
 drivers/dma/sh/shdma-base.c            |  130 ++++++++++++++++++++++++--------
 drivers/dma/sh/shdma.c                 |   39 +++++-----
 drivers/dma/sh/shdma.h                 |    2 +
 drivers/mmc/host/sh_mmcif.c            |   90 +++++++++++++----------
 include/linux/sh_dma.h                 |   12 ++--
 include/linux/shdma-base.h             |    7 +-
 sound/soc/sh/siu_pcm.c                 |    4 -
 9 files changed, 179 insertions(+), 107 deletions(-)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
