Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1AGBy4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 20:54:56 -0500
Received: from mail.openrapids.net ([64.15.138.104]:51300 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755112Ab1AGByz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 20:54:55 -0500
Date: Thu, 6 Jan 2011 20:54:53 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Jeff Moyer <jmoyer@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Li Zefan <lizf@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] blktrace: add missing probe argument to block_bio_complete
Message-ID: <20110107015453.GB5109@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 20:52:39 up 44 days,  6:55,  6 users,  load average: 0.01, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blktrace.c block bio complete callback needs to gain a new argument to reflect
the newly added "error" tracepoint argument. This is needed to match the new
block_bio_complete TRACE_EVENT as of
commit de983a7bfcb7c020901ca6e2314cf55a4207ab5a.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Jeff Moyer <jmoyer@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Jens Axboe <axboe@kernel.dk>
CC: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/blktrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-2.6-lttng/kernel/trace/blktrace.c
===================================================================
--- linux-2.6-lttng.orig/kernel/trace/blktrace.c
+++ linux-2.6-lttng/kernel/trace/blktrace.c
@@ -785,7 +785,8 @@ static void blk_add_trace_bio_bounce(voi
 }
 
 static void blk_add_trace_bio_complete(void *ignore,
-				       struct request_queue *q, struct bio *bio)
+				       struct request_queue *q, struct bio *bio,
+				       int error)
 {
 	blk_add_trace_bio(q, bio, BLK_TA_COMPLETE);
 }
-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
