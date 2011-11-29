Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751349Ab1LJMvV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 07:51:21 -0500
Received: from www17.your-server.de ([213.133.104.17]:55107 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1LJMvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 07:51:14 -0500
Subject: [PATCH] IB/qib: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.306.camel@localhost.localdomain>
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

diff -u -p a/drivers/infiniband/hw/qib/qib_init.c b/drivers/infiniband/hw/qib/qib_init.c
--- a/drivers/infiniband/hw/qib/qib_init.c 2011-11-13 11:07:26.730159415 +0100
+++ b/drivers/infiniband/hw/qib/qib_init.c 2011-11-28 19:51:23.644920442 +0100
@@ -116,7 +116,7 @@ int qib_create_ctxts(struct qib_devdata
 	 * Allocate full ctxtcnt array, rather than just cfgctxts, because
 	 * cleanup iterates across all possible ctxts.
 	 */
-	dd->rcd = kzalloc(sizeof(*dd->rcd) * dd->ctxtcnt, GFP_KERNEL);
+	dd->rcd = kcalloc(dd->ctxtcnt, sizeof(*dd->rcd), GFP_KERNEL);
 	if (!dd->rcd) {
 		qib_dev_err(dd, "Unable to allocate ctxtdata array, "
 			    "failing\n");
@@ -1435,9 +1435,8 @@ int qib_setup_eagerbufs(struct qib_ctxtd
 	egrperchunk = rcd->rcvegrbufs_perchunk;
 	size = rcd->rcvegrbuf_size;
 	if (!rcd->rcvegrbuf) {
-		rcd->rcvegrbuf =
-			kzalloc(chunk * sizeof(rcd->rcvegrbuf[0]),
-				GFP_KERNEL);
+		rcd->rcvegrbuf = kcalloc(chunk, sizeof(rcd->rcvegrbuf[0]),
+					 GFP_KERNEL);
 		if (!rcd->rcvegrbuf)
 			goto bail;
 	}
