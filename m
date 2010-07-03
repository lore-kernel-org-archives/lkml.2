Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab0GCQEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:04:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59513 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755742Ab0GCQEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:04:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pboILmoolO88fMqeozurhGbtemJM/vzT5+yFSUgr3MwBm7OUVjmN+blr3WTmks8vrh
         hVW6u85GFoEyfn4E7vycjlqpfIfpwfggsG5rDtSASOhnAlGy660fU+NQMZbYnp5K0JDS
         t9C3IqFJSmPnkwK9Q9f+Yqgu2aTIv40EzvElA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 14/19] drivers/pci: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:04:28 +0400
Message-Id: <1278173068-11881-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/pci/proc.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/proc.c b/drivers/pci/proc.c
index 449e890..2fd73fb 100644
--- a/drivers/pci/proc.c
+++ b/drivers/pci/proc.c
@@ -485,9 +485,9 @@ static int __init pci_proc_init(void)
 	proc_create("devices", 0, proc_bus_pci_dir,
 		    &proc_bus_pci_dev_operations);
 	proc_initialized = 1;
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
+	for_each_pci_dev(dev)
 		pci_proc_attach_device(dev);
-	}
+
 	return 0;
 }
 
-- 
1.7.0.4

