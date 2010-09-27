Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398Ab0I0W6A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 18:58:00 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:35818 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752Ab0I0W56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 18:57:58 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH RFCv3 0/4] dma: add support for scatterlist to scatterlist copy
Date: Mon, 27 Sep 2010 15:57:53 -0700
Message-Id: <1285628277-26894-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 27 Sep 2010 15:57:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for scatterlist to scatterlist copies to the
generic DMAEngine API. Both the fsldma and ste_dma40 drivers currently
implement a similar API using different, non-generic methods. This series
converts both of them to the new, standardized API.

By doing this as part of the core DMAEngine API, the individual drivers
have control over how to chain their descriptors together. This is
different to the previous implementation, which called
device_prep_dma_memcpy() multiple times.

Neither implementation has been tested on real hardware. I attempted a
conversion of the ste_dma40 driver which should do the right thing, but the
authors should check and make sure.

Ira W. Snyder (4):
  dma: add support for scatterlist to scatterlist copy
  fsldma: implement support for scatterlist to scatterlist copy
  fsldma: remove DMA_SLAVE support
  ste_dma40: implement support for scatterlist to scatterlist copy

 arch/powerpc/include/asm/fsldma.h |  115 ++------------
 drivers/dma/dmaengine.c           |    2 +
 drivers/dma/fsldma.c              |  321 +++++++++++++++++--------------------
 drivers/dma/ste_dma40.c           |   17 ++
 include/linux/dmaengine.h         |    6 +
 5 files changed, 185 insertions(+), 276 deletions(-)

