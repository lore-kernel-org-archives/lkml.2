Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab1HIOQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:16:40 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:57468 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab1HIOQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:16:39 -0400
From: Julia Lawall <julia@diku.dk>
To: Faisal Latif <faisal.latif@intel.com>
Cc: kernel-janitors@vger.kernel.org, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/infiniband/hw/nes/nes_verbs.c: add missing calls to ib_umem_release
Date: Tue,  9 Aug 2011 16:16:31 +0200
Message-Id: <1312899391-6619-1-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add calls to ib_umem_release, as in the other error-handling code in the
same function.

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/infiniband/hw/nes/nes_verbs.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 9f2f7d4..394d0e7 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2338,8 +2338,10 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	skip_pages = ((u32)region->offset) >> 12;
 
-	if (ib_copy_from_udata(&req, udata, sizeof(req)))
+	if (ib_copy_from_udata(&req, udata, sizeof(req))) {
+		ib_umem_release(region);
 		return ERR_PTR(-EFAULT);
+	}
 	nes_debug(NES_DBG_MR, "Memory Registration type = %08X.\n", req.reg_type);
 
 	switch (req.reg_type) {
@@ -2631,6 +2633,7 @@ static struct ib_mr *nes_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			return &nesmr->ibmr;
 	}
 
+	ib_umem_release(region);
 	return ERR_PTR(-ENOSYS);
 }
 

