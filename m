Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0H0Odi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 10:33:38 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:55875 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753381Ab0H0Odg convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:3:1>);
	Fri, 27 Aug 2010 10:33:36 -0400
Message-Id: <4C77E8E20200007800012970@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 27 Aug 2010 15:33:38 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <jaxboe@fusionio.com>, <hch@lst.de>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH] fix use of REQ_WRITE in blk_rq_map_kern()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

REQ_WRITE clearly isn't meant to be used as a shift count, other than
BIO_RW was.

Signed-off-by: Jan Beulich <jbeulich@novell.com>

---
 block/blk-map.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.36-rc2/block/blk-map.c	2010-08-24 15:57:04.000000000 +0200
+++ 2.6.36-rc2-blk-map-REQ_WRITE/block/blk-map.c	2010-08-27 12:57:08.000000000 +0200
@@ -307,7 +307,7 @@ int blk_rq_map_kern(struct request_queue
 		return PTR_ERR(bio);
 
 	if (rq_data_dir(rq) == WRITE)
-		bio->bi_rw |= (1 << REQ_WRITE);
+		bio->bi_rw |= REQ_WRITE;
 
 	if (do_copy)
 		rq->cmd_flags |= REQ_COPY_USER;



