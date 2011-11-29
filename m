Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395Ab1LJMv4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 07:51:56 -0500
Received: from www17.your-server.de ([213.133.104.17]:55105 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1LJMvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 07:51:13 -0500
Subject: [PATCH] RDMA/cxgb4: Use kcalloc instead of kzalloc to allocate
 array
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.302.camel@localhost.localdomain>
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows which could
result from the multiplication of number of elements and size and it is also
a bit nicer to read.

The semantic patch that makes this change is available
in https://lkml.org/lkml/2011/11/25/107

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
--- a/drivers/infiniband/hw/cxgb4/qp.c 2011-11-13 11:07:26.503489176 +0100
+++ b/drivers/infiniband/hw/cxgb4/qp.c 2011-11-28 19:51:22.511565976 +0100
@@ -132,13 +132,13 @@ static int create_qp(struct c4iw_rdev *r
 		goto err1;
 
 	if (!user) {
-		wq->sq.sw_sq = kzalloc(wq->sq.size * sizeof *wq->sq.sw_sq,
-				 GFP_KERNEL);
+		wq->sq.sw_sq = kcalloc(wq->sq.size, sizeof(*wq->sq.sw_sq),
+				       GFP_KERNEL);
 		if (!wq->sq.sw_sq)
 			goto err2;
 
-		wq->rq.sw_rq = kzalloc(wq->rq.size * sizeof *wq->rq.sw_rq,
-				 GFP_KERNEL);
+		wq->rq.sw_rq = kcalloc(wq->rq.size, sizeof(*wq->rq.sw_rq),
+				       GFP_KERNEL);
 		if (!wq->rq.sw_rq)
 			goto err3;
 	}
