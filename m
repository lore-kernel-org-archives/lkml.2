Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036Ab0JDU1g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:27:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:39872 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753825Ab0JDU1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:27:34 -0400
Date: Mon, 4 Oct 2010 20:27:17 GMT
From: tip-bot for Andreas Herrmann <andreas.herrmann3@amd.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andreas.herrmann3@amd.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20100930124316.GG20545@loge.amd.com>
References: <20100930124316.GG20545@loge.amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/amd-nb] x86, amd_nb: Enable GART support for AMD family 0x15 CPUs
Message-ID: <tip-5c80cc78de46aef6cd5e714208da05c3f7f548f8@git.kernel.org>
Git-Commit-ID: 5c80cc78de46aef6cd5e714208da05c3f7f548f8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 04 Oct 2010 20:27:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c80cc78de46aef6cd5e714208da05c3f7f548f8
Gitweb:     http://git.kernel.org/tip/5c80cc78de46aef6cd5e714208da05c3f7f548f8
Author:     Andreas Herrmann <andreas.herrmann3@amd.com>
AuthorDate: Thu, 30 Sep 2010 14:43:16 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 1 Oct 2010 16:18:32 -0700

x86, amd_nb: Enable GART support for AMD family 0x15 CPUs

AMD CPU family 0x15 still supports GART for compatibility reasons.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
LKML-Reference: <20100930124316.GG20545@loge.amd.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/amd_nb.c |    4 +++-
 include/linux/pci_ids.h  |    1 +
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/amd_nb.c b/arch/x86/kernel/amd_nb.c
index 4ffc38d..8f6463d 100644
--- a/arch/x86/kernel/amd_nb.c
+++ b/arch/x86/kernel/amd_nb.c
@@ -15,6 +15,7 @@ static u32 *flush_words;
 struct pci_device_id k8_nb_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB_MISC) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_10H_NB_MISC) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_MISC) },
 	{}
 };
 EXPORT_SYMBOL(k8_nb_ids);
@@ -45,7 +46,8 @@ int cache_k8_northbridges(void)
 		k8_northbridges.num++;
 
 	/* some CPU families (e.g. family 0x11) do not support GART */
-	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10)
+	if (boot_cpu_data.x86 == 0xf || boot_cpu_data.x86 == 0x10 ||
+	    boot_cpu_data.x86 == 0x15)
 		k8_northbridges.gart_supported = 1;
 
 	k8_northbridges.nb_misc = kmalloc((k8_northbridges.num + 1) *
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 10d3330..edc0279 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -514,6 +514,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_DRAM	0x1302
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
+#define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
 #define PCI_DEVICE_ID_AMD_SCSI		0x2020
