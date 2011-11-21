Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab1KUOvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:51:13 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:20675 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab1KUOvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:51:12 -0500
Date: Mon, 21 Nov 2011 17:50:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mpi/mpi-mpow: NULL dereference on allocation failure
Message-ID: <20111121145056.GB19092@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4ECA655F.008C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can't call mpi_free() on the elements if the first kzalloc() fails.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/lib/mpi/mpi-mpow.c b/lib/mpi/mpi-mpow.c
index 4cc7593..7328d0d 100644
--- a/lib/mpi/mpi-mpow.c
+++ b/lib/mpi/mpi-mpow.c
@@ -73,7 +73,7 @@ int mpi_mulpowm(MPI res, MPI *basearray, MPI *exparray, MPI m)
 
 	G = kzalloc((1 << k) * sizeof *G, GFP_KERNEL);
 	if (!G)
-		goto nomem;
+		goto err_out;
 
 	/* and calculate */
 	tmp = mpi_alloc(mpi_get_nlimbs(m) + 1);
@@ -129,5 +129,6 @@ nomem:
 	for (i = 0; i < (1 << k); i++)
 		mpi_free(G[i]);
 	kfree(G);
+err_out:
 	return rc;
 }
