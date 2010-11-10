Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0KJCpP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:45:15 -0500
Received: from mga09.intel.com ([134.134.136.24]:28431 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab0KJCoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:44:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,176,1288594800"; 
   d="scan'208";a="571927264"
Message-Id: <20101110024223.706356831@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 10 Nov 2010 10:35:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>
cc: Christoph Hellwig <hch@lst.de>, Jan Engelhardt <jengelh@medozas.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/5] writeback: trace wakeup event for background writeback
References: <20101110023500.404859581@intel.com>
Content-Disposition: inline; filename=mutt-wfg-t61-1000-20494-6680a464460b57571
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tracks when balance_dirty_pages() tries to wakeup the flusher
thread for background writeback (if it was not started already).

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

 fs/fs-writeback.c                |    1 +
 include/trace/events/writeback.h |    1 +
 2 files changed, 2 insertions(+)

--- linux-next.orig/include/trace/events/writeback.h	2010-11-07 21:54:19.000000000 +0800
+++ linux-next/include/trace/events/writeback.h	2010-11-07 21:56:42.000000000 +0800
@@ -81,6 +81,7 @@ DEFINE_EVENT(writeback_class, name, \
 	TP_ARGS(bdi))
 
 DEFINE_WRITEBACK_EVENT(writeback_nowork);
+DEFINE_WRITEBACK_EVENT(writeback_wake_background);
 DEFINE_WRITEBACK_EVENT(writeback_wake_thread);
 DEFINE_WRITEBACK_EVENT(writeback_wake_forker_thread);
 DEFINE_WRITEBACK_EVENT(writeback_bdi_register);
--- linux-next.orig/fs/fs-writeback.c	2010-11-07 21:54:19.000000000 +0800
+++ linux-next/fs/fs-writeback.c	2010-11-07 21:56:42.000000000 +0800
@@ -169,6 +169,7 @@ void bdi_start_background_writeback(stru
 	 * We just wake up the flusher thread. It will perform background
 	 * writeback as soon as there is no other work to do.
 	 */
+	trace_writeback_wake_background(bdi);
 	spin_lock_bh(&bdi->wb_lock);
 	bdi_wakeup_flusher(bdi);
 	spin_unlock_bh(&bdi->wb_lock);


