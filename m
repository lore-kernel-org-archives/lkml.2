Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1GKOTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:19:52 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:56739 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751948Ab1GKOTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:19:51 -0400
Subject: [PATCH] block: reorder request_queue to remove 64 bit alignment
 padding
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jul 2011 15:19:48 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1310393989.3058.5.camel@castor.rsk>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder request_queue to remove 16 bytes of alignment padding in 64 bit
builds.

On my config this shrinks the size of this structure from 1608 to 1592
bytes and therefore needs one fewer cachelines.

Also trivially move the open bracket { to be on the same line as the
structure name to make it easier to grep. 


Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
----

patch against v3.0-rc6
compiled & tested on x86_64

regards
Richard


diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1a23722..c4649e8 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -260,8 +260,7 @@ struct queue_limits {
 	unsigned char		discard_zeroes_data;
 };
 
-struct request_queue
-{
+struct request_queue {
 	/*
 	 * Together with queue_head for cacheline sharing
 	 */
@@ -304,14 +303,14 @@ struct request_queue
 	void			*queuedata;
 
 	/*
-	 * queue needs bounce pages for pages above this limit
+	 * various queue flags, see QUEUE_* below
 	 */
-	gfp_t			bounce_gfp;
+	unsigned long		queue_flags;
 
 	/*
-	 * various queue flags, see QUEUE_* below
+	 * queue needs bounce pages for pages above this limit
 	 */
-	unsigned long		queue_flags;
+	gfp_t			bounce_gfp;
 
 	/*
 	 * protects queue structures from reentrancy. ->__queue_lock should
@@ -334,8 +333,8 @@ struct request_queue
 	unsigned int		nr_congestion_off;
 	unsigned int		nr_batching;
 
-	void			*dma_drain_buffer;
 	unsigned int		dma_drain_size;
+	void			*dma_drain_buffer;
 	unsigned int		dma_pad_mask;
 	unsigned int		dma_alignment;
 


