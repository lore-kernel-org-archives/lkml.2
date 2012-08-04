Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752877Ab2HDMI1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 08:08:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40886 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2HDMHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 08:07:53 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: axboe@kernel.dk, tj@kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 2/3] Documentation: update tunable options in block/cfq-iosched.txt
Date: Sat,  4 Aug 2012 08:07:44 -0400
Message-Id: <1344082064-2621-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update tunable options in block/cfq-iosched.txt.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 Documentation/block/cfq-iosched.txt |   77 +++++++++++++++++++++++++++++++++++
 1 file changed, 77 insertions(+)

diff --git a/Documentation/block/cfq-iosched.txt b/Documentation/block/cfq-iosched.txt
index 6d670f5..d89b4fe 100644
--- a/Documentation/block/cfq-iosched.txt
+++ b/Documentation/block/cfq-iosched.txt
@@ -1,3 +1,14 @@
+CFQ (Complete Fairness Queueing)
+===============================
+
+The main aim of CFQ scheduler is to provide a fair allocation of the disk
+I/O bandwidth for all the processes which requests an I/O operation.
+
+CFQ maintains the per process queue for the processes which request I/O
+operation(syncronous requests). In case of asynchronous requests, all the
+requests from all the processes are batched together according to their
+process's I/O priority.
+
 CFQ ioscheduler tunables
 ========================
 
@@ -25,6 +36,72 @@ there are multiple spindles behind single LUN (Host based hardware RAID
 controller or for storage arrays), setting slice_idle=0 might end up in better
 throughput and acceptable latencies.
 
+back_seek_max
+-------------
+This specifies, given in Kbytes, the maximum "distance" for backward seeking.
+The distance is the amount of space from the current head location to the
+sectors that are backward in terms of distance.
+
+This parameter allows the scheduler to anticipate requests in the "backward"
+direction and consider them as being the "next" if they are within this
+distance from the current head location.
+
+back_seek_penalty
+-----------------
+This parameter is used to compute the cost of backward seeking. If the
+backward distance of request is just 1/back_seek_penalty from a "front"
+request, then the seeking cost of two requests is considered equivalent.
+
+So scheduler will not bias toward one or the other request (otherwise scheduler
+will bias toward front request). Default value of back_seek_penalty is 2.
+
+fifo_expire_async
+-----------------
+This parameter is used to set the timeout of asynchronous requests. Default
+value of this is 248ms.
+
+fifo_expire_sync
+----------------
+This parameter is used to set the timeout of synchronous requests. Default
+value of this is 124ms. In case to favor synchronous requests over asynchronous
+one, this value should be decreased relative to fifo_expire_async.
+
+slice_async
+-----------
+This parameter is same as of slice_sync but for asynchronous queue. The
+default value is 40ms.
+
+slice_async_rq
+--------------
+This parameter is used to limit the dispatching of asynchronous request to
+device request queue in queue's slice time. The maximum number of request that
+are allowed to be dispatched also depends upon the io priority. Default value
+for this is 2.
+
+slice_sync
+----------
+When a queue is selected for execution, the queues IO requests are only
+executed for a certain amount of time(time_slice) before switching to another
+queue. This parameter is used to calculate the time slice of synchronous
+queue.
+
+time_slice is computed using the below equation:-
+time_slice = slice_sync + (slice_sync/5 * (4 - prio)). To increase the
+time_slice of synchronous queue, increase the value of slice_sync. Default
+value is 100ms.
+
+quantum
+-------
+This specifies the number of request dispatched to the device queue. In a
+queue's time slice, a request will not be dispatched if the number of request
+in the device exceeds this parameter. This parameter is used for synchronous
+request.
+
+In case of storage with several disk, this setting can limit the parallel
+processing of request. Therefore, increasing the value can imporve the
+performace although this can cause the latency of some I/O to increase due
+to more number of requests.
+
 CFQ IOPS Mode for group scheduling
 ===================================
 Basic CFQ design is to provide priority based time slices. Higher priority
-- 
1.7.9.5

