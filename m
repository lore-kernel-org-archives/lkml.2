Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab1DSJQA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 05:16:00 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.185]:59344
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753701Ab1DSJP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 05:15:58 -0400
X-SpamScore: -27
X-BigFish: VPS-27(zzbb2cK179dN1432N98dKzz1202hzz15d4R8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJW72H-02-1DS-02
X-M-MSG: 
Date: Tue, 19 Apr 2011 11:15:52 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: [PATCH] x86, gart: Rename pci-gart_64.c to amd64_gart.c
Message-ID: <20110419091552.GO2192@amd.com>
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
 <1303134346-5805-5-git-send-email-joerg.roedel@amd.com>
 <4DAC4EC0.80008@zytor.com>
 <4DAC5099.4010403@kernel.org>
 <20110418145941.GJ2192@amd.com>
 <20110418155033.GC8623@elte.hu>
 <20110419061259.GL2192@amd.com>
 <20110419072520.GD25353@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110419072520.GD25353@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 03:25:20AM -0400, Ingo Molnar wrote:
> * Roedel, Joerg <Joerg.Roedel@amd.com> wrote:

> > Hmm, that seems long. How about just amd64_gart.c?
> 
> Sure.

Okay, here it is.


>From 35842cba238969f102c6b24c95325e5c09fa3fed Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Tue, 19 Apr 2011 11:04:32 +0200
Subject: [PATCH] x86, gart: Rename pci-gart_64.c to amd64_gart.c

This file contains only code relevant for the AMD NB GART
present in most 64 bit AMD processors. Rename the file so
that its name represent that it is specific to AMD hardware.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/x86/x86_64/boot-options.txt       |    2 +-
 arch/x86/kernel/Makefile                        |    2 +-
 arch/x86/kernel/{pci-gart_64.c => amd64_gart.c} |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/x86/kernel/{pci-gart_64.c => amd64_gart.c} (100%)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 092e596..6512fde 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -206,7 +206,7 @@ IOMMU (input/output memory management unit)
       (e.g. because you have < 3 GB memory).
       Kernel boot message: "PCI-DMA: Disabling IOMMU"
 
-   2. <arch/x86_64/kernel/pci-gart.c>: AMD GART based hardware IOMMU.
+   2. <arch/x86_64/kernel/amd64_gart.c>: AMD GART based hardware IOMMU.
       Kernel boot message: "PCI-DMA: using GART IOMMU"
 
    3. <arch/x86_64/kernel/pci-swiotlb.c> : Software IOMMU implementation. Used
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 7338ef2..2c49bb2 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -117,7 +117,7 @@ obj-$(CONFIG_OF)			+= devicetree.o
 ifeq ($(CONFIG_X86_64),y)
 	obj-$(CONFIG_AUDIT)		+= audit_64.o
 
-	obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
+	obj-$(CONFIG_GART_IOMMU)	+= amd64_gart.o aperture_64.o
 	obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
 	obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o amd_iommu.o
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/amd64_gart.c
similarity index 100%
rename from arch/x86/kernel/pci-gart_64.c
rename to arch/x86/kernel/amd64_gart.c
-- 
1.7.1

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

