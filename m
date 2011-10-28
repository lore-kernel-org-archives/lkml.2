Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933925Ab1J1X7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 19:59:13 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:42354 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754963Ab1J1X7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 19:59:08 -0400
From: Julia Lawall <julia@diku.dk>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] drivers/media/video/atmel-isi.c: eliminate a null pointer dereference
Date: Sat, 29 Oct 2011 01:58:16 +0200
Message-Id: <1319846297-2985-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The variable isi might be null or might be freed at the point of the call
to clk_put.  pclk contains the value that isi->pclk is expected to point to.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
expression E, E1;
identifier f;
statement S1,S2,S3;
@@

if (E == NULL)
{
  ... when != if (E == NULL || ...) S1 else S2
      when != E = E1
*E->f
  ... when any
  return ...;
}
else S3
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/media/video/atmel-isi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/atmel-isi.c b/drivers/media/video/atmel-isi.c
index 774715d..a3dafd6 100644
--- a/drivers/media/video/atmel-isi.c
+++ b/drivers/media/video/atmel-isi.c
@@ -1026,7 +1026,7 @@ err_alloc_ctx:
 err_alloc_descriptors:
 	kfree(isi);
 err_alloc_isi:
-	clk_put(isi->pclk);
+	clk_put(pclk);
 
 	return ret;
 }

