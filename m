Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab2CWIgk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:36:40 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:45178 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab2CWIgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:36:36 -0400
Date: Fri, 23 Mar 2012 11:36:25 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] block: use caller's GFP flags instead of GFP_KERNEL
Message-ID: <20120323083624.GC18239@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F6C3611.006A,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should use the GFP flags that the caller specified instead of picking
our own.  All the callers specify GFP_KERNEL so this doesn't make a
difference to how the kernel runs, it's just a cleanup.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/block/blk-core.c b/block/blk-core.c
index 3a78b00..414e822 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -483,7 +483,7 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (!q)
 		return NULL;
 
-	q->id = ida_simple_get(&blk_queue_ida, 0, 0, GFP_KERNEL);
+	q->id = ida_simple_get(&blk_queue_ida, 0, 0, gfp_mask);
 	if (q->id < 0)
 		goto fail_q;
 
