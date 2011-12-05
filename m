Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932659Ab1LESFO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:05:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59093 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab1LESFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:05:13 -0500
Date: Mon, 5 Dec 2011 10:04:49 -0800
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Message-ID: <tip-f62ef5f3e9cff065aa845e2b7f487e1810b8e57e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, frank.arnold@amd.com, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, frank.arnold@amd.com, tglx@linutronix.de,
        borislav.petkov@amd.com, mingo@elte.hu
In-Reply-To: <20111202072143.GA31916@alberich.amd.com>
References: <20111202072143.GA31916@alberich.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, amd: Fix up numa_node information for AMD CPU family 15h model 0-0fh northbridge functions
Git-Commit-ID: f62ef5f3e9cff065aa845e2b7f487e1810b8e57e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 10:04:55 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f62ef5f3e9cff065aa845e2b7f487e1810b8e57e
Gitweb:     http://git.kernel.org/tip/f62ef5f3e9cff065aa845e2b7f487e1810b8e57e
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Fri, 2 Dec 2011 08:21:43 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 18:13:11 +0100

x86, amd: Fix up numa_node information for AMD CPU family 15h model 0-0fh northbridge functions

I've received complaints that the numa_node attribute for family
15h model 00-0fh (e.g. Interlagos) northbridge functions shows
-1 instead of the proper node ID.

Correct this with attached quirks (similar to quirks for other
AMD CPU families used in multi-socket systems).

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: Frank Arnold <frank.arnold@amd.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/20111202072143.GA31916@alberich.amd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
