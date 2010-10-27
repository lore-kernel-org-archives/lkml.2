Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011Ab0J0R3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 13:29:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45590 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752416Ab0J0R3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 13:29:44 -0400
Date: Wed, 27 Oct 2010 13:29:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jens Axboe <jaxboe@fusionio.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: yummylln@yahoo.com.cn
Subject: [PATCH] blk-throttle: Fix calculation of max number of WRITES to be
 dispatched
Message-ID: <20101027172941.GD12981@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Currently we try to dispatch more READS and less WRITES (75%, 25%) in one
  dispatch round. ummy pointed out that there is a bug in max_nr_writes
  calculation. This patch fixes it.

Reported-by: ummy y <yummylln@yahoo.com.cn>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/blk-throttle.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/block/blk-throttle.c
===================================================================
--- linux-2.6.orig/block/blk-throttle.c	2010-10-27 10:57:25.000000000 -0400
+++ linux-2.6/block/blk-throttle.c	2010-10-27 11:02:33.733048194 -0400
@@ -645,7 +645,7 @@ static int throtl_dispatch_tg(struct thr
 {
 	unsigned int nr_reads = 0, nr_writes = 0;
 	unsigned int max_nr_reads = throtl_grp_quantum*3/4;
-	unsigned int max_nr_writes = throtl_grp_quantum - nr_reads;
+	unsigned int max_nr_writes = throtl_grp_quantum - max_nr_reads;
 	struct bio *bio;
 
 	/* Try to dispatch 75% READS and 25% WRITES */
