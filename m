Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737Ab2HIF2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 01:28:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52471 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab2HIF2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 01:28:16 -0400
Date: Thu, 9 Aug 2012 13:28:03 +0800
From: Shaohua Li <shli@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, hch@infradead.org, martin.petersen@oracle.com,
        vgoyal@redhat.com, neilb@suse.de
Subject: [RFC]block: disable discard request merge temporarily
Message-ID: <20120809052803.GA11814@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SCSI discard request merge never worked, and looks no solution for in
future, let's disable it temporarily.

Signed-off-by: Shaohua Li <shli@fusionio.com>

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4e72a9d..0e6efb1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -601,7 +601,7 @@ static inline void blk_clear_rl_full(struct request_list *rl, bool sync)
  * it already be started by driver.
  */
 #define RQ_NOMERGE_FLAGS	\
-	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA)
+	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | REQ_DISCARD)
 #define rq_mergeable(rq)	\
 	(!((rq)->cmd_flags & RQ_NOMERGE_FLAGS) && \
 	 (((rq)->cmd_flags & REQ_DISCARD) || \
