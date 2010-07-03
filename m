Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0GCQET (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:04:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab0GCQEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:04:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=T3074cs16FjXk5A5Qwf4m40/Qz1ZyMJboywjplnthAMfWm7IYo6UKuiFeJk8ca3OO9
         PrS/RISG08TrEvvTt4pv3EVqmvujnXNa2zGvANAUC8jyBXAAN13izOwcQ4H5IsQVUZIy
         oOUmMfmVjrjZvVnU9AX9RyVSZsI/mW56dV4fs=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 10/19] drivers/ide: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:04:11 +0400
Message-Id: <1278173052-11745-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/ide/ide-scan-pci.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ide/ide-scan-pci.c b/drivers/ide/ide-scan-pci.c
index 0e79eff..c3da53e 100644
--- a/drivers/ide/ide-scan-pci.c
+++ b/drivers/ide/ide-scan-pci.c
@@ -88,7 +88,7 @@ static int __init ide_scan_pcibus(void)
 	struct list_head *l, *n;
 
 	pre_init = 0;
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)))
+	for_each_pci_dev(dev)
 		ide_scan_pcidev(dev);
 
 	/*
-- 
1.7.0.4

