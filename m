Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2DPPWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:22:21 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:51717 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715Ab2DPPWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:22:20 -0400
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Kevin Curtis <kevin.curtis@farsite.co.uk>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/net/wan/farsync.c: add missing iounmap
Date: Mon, 16 Apr 2012 17:22:12 +0200
Message-Id: <1334589732-25876-1-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Free card->mem in the error-handling code since it was successfully
allocated just above.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/wan/farsync.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index ebb9f24..1a62318 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -2483,6 +2483,7 @@ fst_add_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 		pr_err("Control memory remap failed\n");
 		pci_release_regions(pdev);
 		pci_disable_device(pdev);
+		iounmap(card->mem);
 		kfree(card);
 		return -ENODEV;
 	}

