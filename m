Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0GCQD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 12:03:58 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755187Ab0GCQDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 12:03:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CJg24INrUt3stIiz+1t06q7Q9l/UQuoU1yvKijssFZn5/FyUIPHMw94Nt0xLpNbdtg
         BNVF8nie/Jk7w5+WA2d23YaP3IPs9J/0wTmGh29E00y94e4gusJCrCmr8p4/OsUtpCmG
         DEzKPkvk5/x7ZlqdSXjpLsn4yIR1MKBg8JA88=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, iommu@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 05/19] arch/x86/kernel: use for_each_pci_dev()
Date: Sat,  3 Jul 2010 20:03:51 +0400
Message-Id: <1278173032-11575-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use for_each_pci_dev() to simplify the code.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/x86/kernel/amd_iommu.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/amd_iommu.c b/arch/x86/kernel/amd_iommu.c
index 0d20286..29dd3b9 100644
--- a/arch/x86/kernel/amd_iommu.c
+++ b/arch/x86/kernel/amd_iommu.c
@@ -2609,8 +2609,7 @@ int __init amd_iommu_init_passthrough(void)
 
 	pt_domain->mode |= PAGE_MODE_NONE;
 
-	while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
-
+	for_each_pci_dev(dev) {
 		if (!check_device(&dev->dev))
 			continue;
 
-- 
1.7.0.4

