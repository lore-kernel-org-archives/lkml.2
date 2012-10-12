Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab2JLVK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 17:10:27 -0400
Received: from e24smtp05.br.ibm.com ([32.104.18.26]:57373 "EHLO
	e24smtp05.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981Ab2JLVKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 17:10:24 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        Steve Wise <swise@chelsio.com>, Roland Dreier <roland@kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Subject: [PATCH] iw_cxgb4: do not free chunk that we have failed to allocate
Date: Fri, 12 Oct 2012 18:10:11 -0300
Message-Id: <1350076211-24310-1-git-send-email-cascardo@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101221-2362-0000-0000-000008ACB84E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the error path of registering memory, in case there is a failure when
trying to allocate a chunk from the memory pool, it will try to free the
same chunk, which will BUG.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>
---
 drivers/infiniband/hw/cxgb4/mem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/mem.c b/drivers/infiniband/hw/cxgb4/mem.c
index 57e07c6..afd8179 100644
--- a/drivers/infiniband/hw/cxgb4/mem.c
+++ b/drivers/infiniband/hw/cxgb4/mem.c
@@ -468,7 +468,7 @@ struct ib_mr *c4iw_register_phys_mem(struct ib_pd *pd,
 	ret = alloc_pbl(mhp, npages);
 	if (ret) {
 		kfree(page_list);
-		goto err_pbl;
+		goto err;
 	}
 
 	ret = write_pbl(&mhp->rhp->rdev, page_list, mhp->attr.pbl_addr,
-- 
1.7.1

