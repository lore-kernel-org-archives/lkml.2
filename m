Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0GCQEp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:04:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880Ab0GCQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:04:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=BrBt0pu4Ap5xO/ZtiiXWEN1a2LttNsWjgNuA5491wqM53em6GndPiPq34CSf9+4wzw
         RWUlv4O44nnsQnvxGzOD5jcVxkK/fpUwJ1l+HlBIq2bR22yi9Bmz+s0d8D2IkCWQ/tip
         x4Xszn3XPw9Ghq3p2CIHimp8l1wd5WBWxJtxE=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 17/19] drivers/pci: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:04:39 +0400
Message-Id: <1278173080-11983-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/pci/setup-irq.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-irq.c b/drivers/pci/setup-irq.c
index aa795fd..eec9738 100644
--- a/drivers/pci/setup-irq.c
+++ b/drivers/pci/setup-irq.c
@@ -59,7 +59,6 @@ pci_fixup_irqs(u8 (*swizzle)(struct pci_dev *, u8 *),
 	       int (*map_irq)(struct pci_dev *, u8, u8))
 {
 	struct pci_dev *dev = NULL;
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	for_each_pci_dev(dev)
 		pdev_fixup_irq(dev, swizzle, map_irq);
-	}
 }
-- 
1.7.0.4

