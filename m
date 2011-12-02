Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab1LBHVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 02:21:49 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52859 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1LBHVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 02:21:47 -0500
Date: Fri, 2 Dec 2011 08:21:43 +0100
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Frank Arnold <frank.arnold@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] x86, amd: Fixup numa_node information for AMD CPU family 15h
 model 0-0fh northbridge functions
Message-ID: <20111202072143.GA31916@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

I've received complaints that the numa_node attribute for family 15h
model 00-0fh (e.g. Interlagos) northbridge functions shows -1 instead
of the proper node ID.

Correct this with attached quirks (similar to quirks for other AMD CPU
families used in multi-socket systems).

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/kernel/quirks.c |   13 +++++++++++++
 include/linux/pci_ids.h  |    4 ++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index b78643d..03920a1 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -553,4 +553,17 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC,
 			quirk_amd_nb_node);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_LINK,
 			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F0,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F1,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F2,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F3,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F4,
+			quirk_amd_nb_node);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F5,
+			quirk_amd_nb_node);
+
 #endif
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 172ba70..2aaee0c 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -517,8 +517,12 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_DRAM	0x1302
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
+#define PCI_DEVICE_ID_AMD_15H_NB_F0	0x1600
+#define PCI_DEVICE_ID_AMD_15H_NB_F1	0x1601
+#define PCI_DEVICE_ID_AMD_15H_NB_F2	0x1602
 #define PCI_DEVICE_ID_AMD_15H_NB_F3	0x1603
 #define PCI_DEVICE_ID_AMD_15H_NB_F4	0x1604
+#define PCI_DEVICE_ID_AMD_15H_NB_F5	0x1605
 #define PCI_DEVICE_ID_AMD_CNB17H_F3	0x1703
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
-- 
1.7.8.rc4

