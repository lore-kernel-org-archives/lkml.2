Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1GHB7d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 21:59:33 -0400
Received: from mga11.intel.com ([192.55.52.93]:46827 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab1GHB7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 21:59:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,496,1304319600"; 
   d="scan'208";a="27690498"
Subject: [patch]block: document blk_plug list access
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 09:59:29 +0800
Message-ID: <1310090369.15392.264.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm often confused why not disable preempt when changing blk_plug list. It
would be better to add comments here in case others have the similar concerns.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/blkdev.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2011-07-08 09:21:19.000000000 +0800
+++ linux/include/linux/blkdev.h	2011-07-08 09:34:39.000000000 +0800
@@ -857,6 +857,12 @@ struct request_queue *blk_alloc_queue(gf
 struct request_queue *blk_alloc_queue_node(gfp_t, int);
 extern void blk_put_queue(struct request_queue *);
 
+/*
+ * Note: Code in between changing the blk_plug list/cb_list or element of such
+ * lists is preemptable, but such code can't do sleep (or be very careful),
+ * otherwise data is corrupted. For details, please check schedule() where
+ * blk_schedule_flush_plug() is called.
+ */
 struct blk_plug {
 	unsigned long magic;
 	struct list_head list;


