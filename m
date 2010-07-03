Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0GCQFg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:05:36 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab0GCQEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:04:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dgeqtFJfStChRDY/qfTrYnddAlByELsOYZBAuk92SVzwkoM7megF4wZNmgDSJQVdoI
         43Yqya4UEyriw4WBqAHipgtoKe3qgBhJtsVM5GcUsPKqmWPUQTMy9A1KAiTb/fwgDSGt
         Ny4GJxBQlEzttQDKz2lTkP7gEHfcSjjU6fiDo=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Yu Zhao <yu.zhao@intel.com>,
       Dexuan Cui <dexuan.cui@intel.com>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 15/19] drivers/pci: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:04:31 +0400
Message-Id: <1278173072-11915-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/pci/quirks.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 3a81d9d..be632fa 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -2760,7 +2760,7 @@ static int __init pci_apply_final_quirks(void)
 		printk(KERN_DEBUG "PCI: CLS %u bytes\n",
 		       pci_cache_line_size << 2);
 
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	for_each_pci_dev(dev) {
 		pci_fixup_device(pci_fixup_final, dev);
 		/*
 		 * If arch hasn't set it explicitly yet, use the CLS
-- 
1.7.0.4

