Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146Ab2BDWtQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 17:49:16 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:29677 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab2BDWtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 17:49:14 -0500
Date: Sat, 4 Feb 2012 23:49:40 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-rdma@vger.kernel.org
cc: linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@risingtidesystems.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>, Roland Dreier <roland@kernel.org>
Subject: [PATCH] IB: Don't return freed pointer from
 srpt_alloc_ioctx_ring()
Message-ID: <alpine.LNX.2.00.1202042346510.30244@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

 compile tested only.

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index cd5d05e..a59c685 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -687,6 +687,7 @@ err:
 	while (--i >= 0)
 		srpt_free_ioctx(sdev, ring[i], dma_size, dir);
 	kfree(ring);
+	ring = NULL;
 out:
 	return ring;
 }
-- 
1.7.9


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

