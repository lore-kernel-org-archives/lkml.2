Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751245Ab1LJMvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 07:51:13 -0500
Received: from www17.your-server.de ([213.133.104.17]:55095 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab1LJMvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 07:51:11 -0500
Subject: [PATCH] IB/ehca: Use kcalloc instead of kzalloc to allocate array
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Date: Tue, 29 Nov 2011 22:08:00 +0100
Message-ID: <1322600880.1534.303.camel@localhost.localdomain>
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

diff -u -p a/drivers/infiniband/hw/ehca/ehca_qp.c b/drivers/infiniband/hw/ehca/ehca_qp.c
--- a/drivers/infiniband/hw/ehca/ehca_qp.c 2011-11-13 11:07:26.513489332 +0100
+++ b/drivers/infiniband/hw/ehca/ehca_qp.c 2011-11-28 19:51:39.771888018 +0100
@@ -853,10 +853,9 @@ static struct ehca_qp *internal_create_q
 			/* alloc array to cache subsequent modify qp parms
 			 * for autodetect mode
 			 */
-			my_qp->mod_qp_parm =
-				kzalloc(EHCA_MOD_QP_PARM_MAX *
-					sizeof(*my_qp->mod_qp_parm),
-					GFP_KERNEL);
+			my_qp->mod_qp_parm = kcalloc(EHCA_MOD_QP_PARM_MAX,
+						     sizeof(*my_qp->mod_qp_parm),
+						     GFP_KERNEL);
 			if (!my_qp->mod_qp_parm) {
 				ehca_err(pd->device,
 					 "Could not alloc mod_qp_parm");
