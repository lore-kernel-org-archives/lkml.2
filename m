Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab2EJOas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:30:48 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56028 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab2EJOap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:30:45 -0400
From: Borislav Petkov <bp@amd64.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, EDAC devel <linux-edac@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 1/9] x86, amd_nb: Export model 0x10 and later PCI id
Date: Thu, 10 May 2012 16:30:21 +0200
Message-Id: <1336660229-32644-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.9.3.362.g71319
In-Reply-To: <1336660229-32644-1-git-send-email-bp@amd64.org>
References: <1336660229-32644-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add the F3 PCI id of F15h, model 0x10 to pci_ids.h and to the amd_nb
code which generates the list of northbridges on an AMD box. Shorten
define name while at it so that it fits into pci_ids.h.

Cc: Clemens Ladisch <clemens@ladisch.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/kernel/amd_nb.c |    1 +
 drivers/hwmon/k10temp.c  |    5 +----
 include/linux/pci_ids.h  |    1 +
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index be16854591cc..153a0ee88fb1 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -16,6 +16,7 @@ const struct pci_device_id amd_nb_misc_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
 	{}
 };
 EXPORT_SYMBOL(amd_nb_misc_ids);
diff --git a/drivers/hwmon/k10temp.c b/drivers/hwmon/k10temp.c
index 307bb325dde9..723675ad8e4d 100644
--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -33,9 +33,6 @@ static bool force;
 module_param(force, bool, 0444);
 MODULE_PARM_DESC(force, "force loading on processors with erratum 319");
 
-/* PCI-IDs for Northbridge devices not used anywhere else */
-#define PCI_DEVICE_ID_AMD_15H_M10H_NB_F3	0x1403
-
 /* CPUID function 0x80000001, ebx */
 #define CPUID_PKGTYPE_MASK	0xf0000000
 #define CPUID_PKGTYPE_F		0x00000000
@@ -213,7 +210,7 @@ static DEFINE_PCI_DEVICE_TABLE(k10temp_id_table) = {
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_11H_NB_MISC) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_CNB17H_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
-	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_NB_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
 	{}
 };
 MODULE_DEVICE_TABLE(pci, k10temp_id_table);
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3329965ed63f..ba943aa2247e 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -517,6 +517,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_DRAM	0x1302
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
+#define PCI_DEVICE_ID_AMD_15H_M10H_F3	0x1403
 #define PCI_DEVICE_ID_AMD_15H_NB_F0	0x1600
 #define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
 #define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
-- 
1.7.9.3.362.g71319

