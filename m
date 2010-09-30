Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756118Ab0I3Vqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 17:46:50 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:41521 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab0I3Vqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 17:46:49 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 0/4] dma: add support for scatterlist to scatterlist copy
Date: Thu, 30 Sep 2010 14:46:43 -0700
Message-Id: <1285883207-13761-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 30 Sep 2010 14:46:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for scatterlist to scatterlist copies to the
generic DMAEngine API. Both the fsldma and ste_dma40 drivers currently
implement a similar API using different, non-generic methods. This series
converts both of them to the new, standardized API.

By doing this as part of the core DMAEngine API, the individual drivers
have control over how to chain their descriptors together. In addition,
this makes graceful failure much easier to support.

The fsldma implementation has been tested on real hardware, using slightly
modified versions of the patches posted a few weeks ago, titled:
[PATCH RFCv2 0/5] CARMA Board Support

These patches will be re-submitted with the appropriate changes after we're
happy with this series.

Thanks to all that provided input!
Ira

Changes since v3:
- ste40_dma's implementation now returns NULL (thanks Dan!)
- fsldma now uses a custom command for external control
- fsldma now uses the standard struct dma_slave_config
- tested on real hardware

Ira W. Snyder (4):
  dma: add support for scatterlist to scatterlist copy
  fsldma: implement support for scatterlist to scatterlist copy
  fsldma: improved DMA_SLAVE support
  ste_dma40: implement support for scatterlist to scatterlist copy

 arch/powerpc/include/asm/fsldma.h |  137 ---------------
 drivers/dma/dmaengine.c           |    2 +
 drivers/dma/fsldma.c              |  328 ++++++++++++++++++-------------------
 drivers/dma/ste_dma40.c           |   17 ++
 include/linux/dmaengine.h         |    9 +
 5 files changed, 184 insertions(+), 309 deletions(-)
 delete mode 100644 arch/powerpc/include/asm/fsldma.h

