Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306Ab1AWQaS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 11:30:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55626 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1AWQaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 11:30:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=l+nXy5SOyKuht3xqoDH5qGskA6GJSavTj5NakYpjZRv68ffJycrH21YIs4FJtre4vR
         W2BpJRV+yoFunJmpWPrltW24+A2EOGtDvaEL0avSisBfNbOvjqA7V5oNAAMfzuqFRrJC
         vzdRbZevhYRAlEKAuUnca9I8TSjthvGsfDJTE=
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: tom@opengridcomputing.com
Cc: swise@opengridcomputing.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH] infiniband: hw: amso1100: Fixed compile warning.
Date: Sun, 23 Jan 2011 17:30:03 +0100
Message-Id: <1295800203-9552-1-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed compile warning by use "unsigned long" instead of "u64"
on assign NULL to "c2_vq_req->reply_msg".

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 drivers/infiniband/hw/amso1100/c2_vq.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/amso1100/c2_vq.c b/drivers/infiniband/hw/amso1100/c2_vq.c
index 9ce7819..807b730 100644
--- a/drivers/infiniband/hw/amso1100/c2_vq.c
+++ b/drivers/infiniband/hw/amso1100/c2_vq.c
@@ -107,7 +107,7 @@ struct c2_vq_req *vq_req_alloc(struct c2_dev *c2dev)
 	r = kmalloc(sizeof(struct c2_vq_req), GFP_KERNEL);
 	if (r) {
 		init_waitqueue_head(&r->wait_object);
-		r->reply_msg = (u64) NULL;
+		r->reply_msg = (unsigned long) NULL;
 		r->event = 0;
 		r->cm_id = NULL;
 		r->qp = NULL;
@@ -123,7 +123,7 @@ struct c2_vq_req *vq_req_alloc(struct c2_dev *c2dev)
  */
 void vq_req_free(struct c2_dev *c2dev, struct c2_vq_req *r)
 {
-	r->reply_msg = (u64) NULL;
+	r->reply_msg = (unsigned long) NULL;
 	if (atomic_dec_and_test(&r->refcnt)) {
 		kfree(r);
 	}
@@ -151,7 +151,7 @@ void vq_req_get(struct c2_dev *c2dev, struct c2_vq_req *r)
 void vq_req_put(struct c2_dev *c2dev, struct c2_vq_req *r)
 {
 	if (atomic_dec_and_test(&r->refcnt)) {
-		if (r->reply_msg != (u64) NULL)
+		if (r->reply_msg != (unsigned long) NULL)
 			vq_repbuf_free(c2dev,
 				       (void *) (unsigned long) r->reply_msg);
 		kfree(r);
-- 
1.7.1

