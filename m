Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab2JaF4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 01:56:32 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:63911 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753873Ab2JaF4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 01:56:23 -0400
From: Daniel J Blueman <daniel@numascale-asia.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        H Peter Anvin <hpa@zytor.com>, Steffen Persvold <sp@numascale.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: [PATCH 4/4] AMD64 EDAC: Use appropriate name for NB indexing
Date: Wed, 31 Oct 2012 13:55:32 +0800
Message-Id: <1351662932-22279-4-git-send-email-daniel@numascale-asia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351662932-22279-1-git-send-email-daniel@numascale-asia.com>
References: <1351662932-22279-1-git-send-email-daniel@numascale-asia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the same 'amd' prefix as related functions for clarity.

Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
---
 arch/x86/include/asm/amd_nb.h |    2 +-
 drivers/edac/amd64_edac.c     |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/amd_nb.h b/arch/x86/include/asm/amd_nb.h
index 0cc1045..39b5ddd 100644
--- a/arch/x86/include/asm/amd_nb.h
+++ b/arch/x86/include/asm/amd_nb.h
@@ -81,7 +81,7 @@ static inline struct amd_northbridge *node_to_amd_nb(u16 node)
 	return (node < amd_northbridges.num) ? &amd_northbridges.nb[node] : NULL;
 }
 
-static inline u16 get_node_id(struct pci_dev *pdev)
+static inline u16 amd_get_node_id(struct pci_dev *pdev)
 {
 	int i;
 
diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index 12cd675..59658b9 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -2558,7 +2558,7 @@ static int amd64_init_one_instance(struct pci_dev *F2)
 	struct mem_ctl_info *mci = NULL;
 	struct edac_mc_layer layers[2];
 	int err = 0, ret;
-	u16 nid = get_node_id(F2);
+	u16 nid = amd_get_node_id(F2);
 
 	ret = -ENOMEM;
 	pvt = kzalloc(sizeof(struct amd64_pvt), GFP_KERNEL);
@@ -2649,7 +2649,7 @@ err_ret:
 static int __devinit amd64_probe_one_instance(struct pci_dev *pdev,
 					     const struct pci_device_id *mc_type)
 {
-	u16 nid = get_node_id(pdev);
+	u16 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s;
 	int ret = 0;
@@ -2699,7 +2699,7 @@ static void __devexit amd64_remove_one_instance(struct pci_dev *pdev)
 {
 	struct mem_ctl_info *mci;
 	struct amd64_pvt *pvt;
-	u16 nid = get_node_id(pdev);
+	u16 nid = amd_get_node_id(pdev);
 	struct pci_dev *F3 = node_to_amd_nb(nid)->misc;
 	struct ecc_settings *s = ecc_stngs[nid];
 
-- 
1.7.9.5

