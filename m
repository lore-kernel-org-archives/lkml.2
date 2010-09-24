Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758009Ab0IXTqP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 15:46:15 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:47097 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757986Ab0IXTqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 15:46:12 -0400
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH RFCv1 0/2] dma: add support for sg-to-sg transfers
Date: Fri, 24 Sep 2010 12:46:09 -0700
Message-Id: <1285357571-23377-1-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.1
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Fri, 24 Sep 2010 12:46:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds support for scatterlist to scatterlist transfers to the
generic DMAEngine API. I have unconditionally enabled it when the fsldma
driver is used to make testing easier. This feature should probably be
selected by individual drivers.

This series is intended to lay the groundwork for further changes to the
series titled "CARMA Board Support". That series will be updated when I
have time and hardware to test with.

This series has not been runtime tested yet. I am posting it only to
gain comments before I spend the effort to update the driver that
depends on this.

To help reviewers, I'd like to comment on the architecture of
dma_async_memcpy_sg_to_sg(). It explicitly avoids using descriptor
chaining due to the way that feature interacts with the fsldma
controller's external start feature. To use the external start feature
properly, the in-memory descriptor chain must not be fragmented into
multiple smaller chains. This is what is achieved by submitting all
descriptors without using chaining.

Ira W. Snyder (2):
  dmaengine: add support for scatterlist to scatterlist transfers
  fsldma: use generic support for scatterlist to scatterlist transfers

 arch/powerpc/include/asm/fsldma.h |  115 ++------------------
 drivers/dma/Kconfig               |    4 +
 drivers/dma/dmaengine.c           |  119 ++++++++++++++++++++
 drivers/dma/fsldma.c              |  219 +++++++------------------------------
 include/linux/dmaengine.h         |   10 ++
 5 files changed, 181 insertions(+), 286 deletions(-)

