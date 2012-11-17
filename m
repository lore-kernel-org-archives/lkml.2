Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab2KQPIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 10:08:36 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:28383 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2KQPIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 10:08:35 -0500
Date: Sat, 17 Nov 2012 18:08:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Neela Syam Kolli <megaraidlinux@lsi.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] [SCSI] MegaRAID: use GFP_ATOMIC under spin lock
Message-ID: <20121117150821.GB19951@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're holding a spin_lock here so we should use GFP_ATOMIC.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index 25506c7..5205275 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -568,7 +568,7 @@ mraid_mm_attach_buf(mraid_mmadp_t *adp, uioc_t *kioc, int xferlen)
 
 	kioc->pool_index	= right_pool;
 	kioc->free_buf		= 1;
-	kioc->buf_vaddr 	= pci_pool_alloc(pool->handle, GFP_KERNEL,
+	kioc->buf_vaddr		= pci_pool_alloc(pool->handle, GFP_ATOMIC,
 							&kioc->buf_paddr);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
