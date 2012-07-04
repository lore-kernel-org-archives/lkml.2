Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2GDQSs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:18:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56225 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683Ab2GDQR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:17:58 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] dma: sh: stop using .private
Date: Wed,  4 Jul 2012 18:17:39 +0200
Message-Id: <1341418663-24432-1-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
X-Provags-ID: V02:K0:3IZbKtW46gK7BjYBScNNP4GgORYmJH9GpG8BtIWs6tY
 OD/MGKHf2ilTTLE0mPCC0MF4rZlyn7HaMsy7VV/aP1S3nddOZj
 lABcVAyHQu3YNox36wCciyVkV8Thab5GQVq54qyihYuRE8MF+9
 UkdVQggW+IENWtD+1z/vZm5KTs3xfK0nlujA2jdplkMs/KWM+R
 ycJYUjL0hoBrG6GMFWN1GMcTCaH7qDsm+36fddxdIHswK8KScx
 0wn6K5w7NLcKoEge3yf87mRQsaJoQbds9wtXNfM7VTC1uemtyU
 jxlsZBRCcVExwK8Q8grNMeyuPQzU86/LsQdP2U1rPW5T9tcQ0V
 hjnR+VjVeGODOS8aKEKGDbOEpfghwpc5/kmYsIQBroKkRh+ZBh
 BfbqMchub5Aog==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vinod

Here's an attempt to convert the shdma driver to a new method, whereby a 
centrally provided filter function is used and the DMA_SLAVE_CONFIG command 
is enabled for slave operation. The last patch is an illustration of how 
this new method shall be used. If this approach is acceptable, I'll also 
convert the remaining shdma user drivers. This patch series goes on top of 
my earlier patches to split shdma.c. It might be easier at some point for 
you to have me provide you a git tree to pull from.

Chris, this time the mmc patch is not yet to be applied. We first have to 
sort out the dmaengine API.

Guennadi Liakhovetski (4):
  dmaengine: shdma: prepare to stop using struct dma_chan::private
  dma: sh: use an integer slave ID to improve API compatibility
  dma: sh: provide a migration path for slave drivers to stop using
    .private
  mmc: sh_mmcif: switch to the new DMA channel allocation and
    configuration

 drivers/dma/sh/shdma-base.c |  130 ++++++++++++++++++++++++++++++++-----------
 drivers/dma/sh/shdma.c      |   35 +++++------
 drivers/dma/sh/shdma.h      |    2 +
 drivers/mmc/host/sh_mmcif.c |   90 +++++++++++++++++-------------
 include/linux/sh_dma.h      |   12 ++--
 include/linux/shdma-base.h  |    7 +-
 6 files changed, 177 insertions(+), 99 deletions(-)

-- 
1.7.2.5

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
