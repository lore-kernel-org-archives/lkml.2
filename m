Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631Ab1G2DNk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 23:13:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:17669 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753462Ab1G2DNh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 23:13:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="32865424"
Subject: [patch]block: document blk_plug
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jul 2011 11:13:35 +0800
Message-ID: <1311909215.15392.418.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton is asking to document blk_plug, so here is my attempt.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 include/linux/blkdev.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2011-07-29 10:51:29.000000000 +0800
+++ linux/include/linux/blkdev.h	2011-07-29 11:07:49.000000000 +0800
@@ -858,6 +858,17 @@ struct request_queue *blk_alloc_queue_no
 extern void blk_put_queue(struct request_queue *);
 
 /*
+ * blk_plug gives each task a request list. Since blk_start_plug() called,
+ * requests from the task will be added to the per-task list and then moved
+ * to global request_queue in a batch way at appropriate time(either
+ * blk_finish_plug() is called or task goes to sleep). blk_plug has some
+ * advantages:
+ * 1. Better request merge. The assumption here is requests from a task have
+ *    better chances to be merged.
+ * 2. Better scalability. Requests are moved from per-task list to global
+ *    request_queue in a batch way, so the total times grabing global
+ *    request_queue lock are reduced.
+ *
  * Note: Code in between changing the blk_plug list/cb_list or element of such
  * lists is preemptable, but such code can't do sleep (or be very careful),
  * otherwise data is corrupted. For details, please check schedule() where


