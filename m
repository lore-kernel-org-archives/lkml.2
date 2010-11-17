Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab0KQNY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 08:24:58 -0500
Received: from mga03.intel.com ([143.182.124.21]:32355 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754390Ab0KQNY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 08:24:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,211,1288594800"; 
   d="scan'208";a="349879230"
Date: Wed, 17 Nov 2010 21:02:13 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: spectra: fix build error
Message-ID: <20101117130212.GA2029@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_queue_ordered() has been deprecated and replaced with
blk_queue_flush() by Tejun. However, use of blk_queue_ordered()
in spectra nand driver has not been converted yet and thus results
in the following build error.

drivers/staging/spectra/ffsport.c: In function SBD_setup_device:
drivers/staging/spectra/ffsport.c:659: error: implicit declaration of function blk_queue_ordered
drivers/staging/spectra/ffsport.c:659: error: QUEUE_ORDERED_DRAIN_FLUSH undeclared (first use in this function)
drivers/staging/spectra/ffsport.c:659: error: (Each undeclared identifier is reported only once
drivers/staging/spectra/ffsport.c:659: error: for each function it appears in.)

Signed-off-by: Yong Wang <yong.y.wang@intel.com>
Cc: Tejun Heo <tj@kernel.org>
---
 drivers/staging/spectra/ffsport.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/spectra/ffsport.c b/drivers/staging/spectra/ffsport.c
index c7932da..63a9d0a 100644
--- a/drivers/staging/spectra/ffsport.c
+++ b/drivers/staging/spectra/ffsport.c
@@ -656,7 +656,7 @@ static int SBD_setup_device(struct spectra_nand_dev *dev, int which)
 	/* Here we force report 512 byte hardware sector size to Kernel */
 	blk_queue_logical_block_size(dev->queue, 512);
 
-	blk_queue_ordered(dev->queue, QUEUE_ORDERED_DRAIN_FLUSH);
+	blk_queue_flush(dev->queue, REQ_FLUSH);
 
 	dev->thread = kthread_run(spectra_trans_thread, dev, "nand_thd");
 	if (IS_ERR(dev->thread)) {
-- 
1.5.5.1

