Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755591Ab1G0WEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 18:04:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:24579 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524Ab1G0Vsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 17:48:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,278,1309762800"; 
   d="scan'208";a="30900572"
From: Andi Kleen <andi@firstfloor.org>
References: <20110727247.325703029@firstfloor.org>
In-Reply-To: <20110727247.325703029@firstfloor.org>
To: jaxboe@fusionio.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [37/99] block: export blk_{get,put}_queue()
Message-Id: <20110727214835.F34202403FF@tassilo.jf.intel.com>
Date: Wed, 27 Jul 2011 14:48:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jens Axboe <jaxboe@fusionio.com>

commit d86e0e83b32bc84600adb0b6ea1fce389b266682 upstream.

We need them in SCSI to fix a bug, but currently they are not
exported to modules. Export them.

Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 block/blk-core.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.35.y/block/blk-core.c
===================================================================
--- linux-2.6.35.y.orig/block/blk-core.c
+++ linux-2.6.35.y/block/blk-core.c
@@ -311,6 +311,7 @@ void blk_unplug_timeout(unsigned long da
 	trace_block_unplug_timer(q);
 	kblockd_schedule_work(q, &q->unplug_work);
 }
+EXPORT_SYMBOL(blk_put_queue);
 
 void blk_unplug(struct request_queue *q)
 {
@@ -640,6 +641,7 @@ int blk_get_queue(struct request_queue *
 
 	return 1;
 }
+EXPORT_SYMBOL(blk_get_queue);
 
 static inline void blk_free_request(struct request_queue *q, struct request *rq)
 {
