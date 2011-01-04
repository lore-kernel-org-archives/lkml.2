Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab1ADXvX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 18:51:23 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:33048 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751768Ab1ADXvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 18:51:21 -0500
Message-Id: <20110104232419.097998611@efficios.com>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 18:16:30 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Jeff Moyer <jmoyer@redhat.com>,
        Jens Axboe <jens.axboe@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Alan.Brunelle@hp.com
Subject: [RFC patch 1/5] trace event block fix unassigned field
References: <20110104231629.996422888@efficios.com>
Content-Disposition: inline; filename=trace-event-block-fix-unassigned-field.patch
X-Poly-FromMTA: (test.dorsal.polymtl.ca [132.207.72.60]) at Tue,  4 Jan 2011 23:24:19 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "error" field in block_bio_complete is not assigned, leaving the memory area
uninitialized (keeping garbage data). Initialize it to 0.

We should eventually remove this field when we find out if blktrace can live
without it.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Jeff Moyer <jmoyer@redhat.com>
CC: Jens Axboe <jens.axboe@oracle.com>
CC: Li Zefan <lizf@cn.fujitsu.com>
CC: Alan.Brunelle@hp.com
---
 include/trace/events/block.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/include/trace/events/block.h
===================================================================
--- linux-2.6-lttng.orig/include/trace/events/block.h
+++ linux-2.6-lttng/include/trace/events/block.h
@@ -228,6 +228,7 @@ TRACE_EVENT(block_bio_complete,
 		__entry->dev		= bio->bi_bdev->bd_dev;
 		__entry->sector		= bio->bi_sector;
 		__entry->nr_sector	= bio->bi_size >> 9;
+		__entry->error		= 0;
 		blk_fill_rwbs(__entry->rwbs, bio->bi_rw, bio->bi_size);
 	),
 

