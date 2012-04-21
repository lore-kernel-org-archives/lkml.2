Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254Ab2DUOI2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 10:08:28 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:37915 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751300Ab2DUOI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 10:08:27 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Mike Miller <mike.miller@hp.com>
Cc: kernel-janitors@vger.kernel.org, iss_storagedev@hp.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/block/cciss.c: correct size computation
Date: Sat, 21 Apr 2012 16:08:19 +0200
Message-Id: <1335017299-30356-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The size argument to remap_pci_mem should be the size of desired structure,
not the pointer to it.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@expression@
expression *x;
@@

x =
 <+...
-sizeof(x)
+sizeof(*x)
...+>
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/block/cciss.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index b0f553b..9f50d7d 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -4209,7 +4209,7 @@ static int __devinit cciss_find_cfgtables(ctlr_info_t *h)
 	if (rc)
 		return rc;
 	h->cfgtable = remap_pci_mem(pci_resource_start(h->pdev,
-		cfg_base_addr_index) + cfg_offset, sizeof(h->cfgtable));
+		cfg_base_addr_index) + cfg_offset, sizeof(*h->cfgtable));
 	if (!h->cfgtable)
 		return -ENOMEM;
 	rc = write_driver_ver_to_cfgtable(h->cfgtable);

