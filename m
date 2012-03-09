Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030737Ab2CIUVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:21:55 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030667Ab2CITrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:47:36 -0500
Message-Id: <20120309190205.473842025@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:02:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steffen Maier <maier@linux.vnet.ibm.com>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 39/95] S390: qdio: fix handler function arguments for zfcp data router
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Maier <maier@linux.vnet.ibm.com>

commit 7b3cc67d4445995a025a4b55a7dc687b6829b4ca upstream.

Git commit 25f269f17316549e "[S390] qdio: EQBS retry after CCQ 96"
introduced a regression in regard to the zfcp data router.
Revoke the incorrect simplification of the function call arguments
for the qdio handler to make the zfcp hardware data router working
again.

This is applicable to 3.2+ kernels.

Signed-off-by: Steffen Maier <maier@linux.vnet.ibm.com>
Reviewed-by: Jan Glauber <jang@linux.vnet.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/s390/cio/qdio_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -167,7 +167,7 @@ again:
 	DBF_ERROR("%4x EQBS ERROR", SCH_NO(q));
 	DBF_ERROR("%3d%3d%2d", count, tmp_count, nr);
 	q->handler(q->irq_ptr->cdev, QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
-		   0, -1, -1, q->irq_ptr->int_parm);
+		   q->nr, q->first_to_kick, count, q->irq_ptr->int_parm);
 	return 0;
 }
 
@@ -215,7 +215,7 @@ again:
 	DBF_ERROR("%4x SQBS ERROR", SCH_NO(q));
 	DBF_ERROR("%3d%3d%2d", count, tmp_count, nr);
 	q->handler(q->irq_ptr->cdev, QDIO_ERROR_ACTIVATE_CHECK_CONDITION,
-		   0, -1, -1, q->irq_ptr->int_parm);
+		   q->nr, q->first_to_kick, count, q->irq_ptr->int_parm);
 	return 0;
 }
 


