Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0FLCfd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 22:35:33 -0400
Received: from smtp-out.google.com ([74.125.121.35]:16677 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0FLCfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 22:35:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding;
	b=S49l1KsB0+Idl3Bx8Y+lYB/wp77EE4xt7aImfn9n/j4w/PBIwyz9984k1LQi9FGN5
	wDa32+kt0ZV1zqa8LZP+g==
Subject: [PATCH 1/2] Remove preempt_enable/disable calls around sched_clock()
To: jaxboe@fusionio.com
From: Divyesh Shah <dpshah@google.com>
Cc: peterz@infradead.org, mingo@elte.hu, piotr@hosowicz.com,
       linux-kernel@vger.kernel.org, vgoyal@redhat.com
Date: Fri, 11 Jun 2010 19:34:52 -0700
Message-ID: <20100612023409.14850.76309.stgit@austin.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

calls in the block layer. This was a temporary fix added.

Signed-off-by: Divyesh Shah <dpshah@google.com>
---
 include/linux/blkdev.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 09a8402..ebe788e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1218,16 +1218,12 @@ int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
  */
 static inline void set_start_time_ns(struct request *req)
 {
-	preempt_disable();
 	req->start_time_ns = sched_clock();
-	preempt_enable();
 }
 
 static inline void set_io_start_time_ns(struct request *req)
 {
-	preempt_disable();
 	req->io_start_time_ns = sched_clock();
-	preempt_enable();
 }
 
 static inline uint64_t rq_start_time_ns(struct request *req)

