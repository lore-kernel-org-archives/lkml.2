Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755814Ab0I3Mqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:46:51 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37151 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752379Ab0I3Mqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:46:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QeUTWS1oAEUZF2p7fuBOCU6Dq0tiID8cM5GtqFfbSvAUGGCyy++45rlQ7Pxuz4RzkQ
         LNW0K1VVlD0gO/wq2VkePnKMSFVIz1ytoERFgG581bsg1JhFoaC9OpKE3007ZOchlFK6
         X/aX0K4SY8HysrvmOwQUCXxs15HWSW8EvvzKs=
Date: Thu, 30 Sep 2010 14:43:16 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/6] x86, amd_nb: Enable GART support for AMD family 0x15
 CPUs
Message-ID: <20100930124316.GG20545@loge.amd.com>
References: <20100930121839.GA20545@loge.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930121839.GA20545@loge.amd.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

AMD CPU family 0x15 still supports GART for compatibility reasons.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
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
index 570fdde..2615c37 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -517,6 +517,7 @@
 #define PCI_DEVICE_ID_AMD_11H_NB_DRAM	0x1302
 #define PCI_DEVICE_ID_AMD_11H_NB_MISC	0x1303
 #define PCI_DEVICE_ID_AMD_11H_NB_LINK	0x1304
+#define PCI_DEVICE_ID_AMD_15H_NB_MISC	0x1603
 #define PCI_DEVICE_ID_AMD_LANCE		0x2000
 #define PCI_DEVICE_ID_AMD_LANCE_HOME	0x2001
 #define PCI_DEVICE_ID_AMD_SCSI		0x2020
-- 
1.6.4.4

