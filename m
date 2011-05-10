Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab1EJPds (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 11:33:48 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:25358
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752436Ab1EJPdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 11:33:46 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zzbb2dK9371O1432N98dKzz1202hzz8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LKZKJV-02-9OT-02
X-M-MSG: 
Date: Tue, 10 May 2011 17:32:56 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: [PATCH] x86, gart: Rename pci-gart_64.c to amd_gart_64.c 1TB
Message-ID: <20110510153256.GD30996@amd.com>
References: <1303134346-5805-5-git-send-email-joerg.roedel@amd.com>
 <4DAC4EC0.80008@zytor.com>
 <4DAC5099.4010403@kernel.org>
 <20110418145941.GJ2192@amd.com>
 <20110418155033.GC8623@elte.hu>
 <20110419061259.GL2192@amd.com>
 <20110419072520.GD25353@elte.hu>
 <4DAD919A.3080102@kernel.org>
 <20110419142904.GT2192@amd.com>
 <4DAF1A14.2090703@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4DAF1A14.2090703@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 01:38:28PM -0400, H. Peter Anvin wrote:
> On 04/19/2011 07:29 AM, Roedel, Joerg wrote:

> > The k8_nb was renamed to amd_nb recently. The NB is implemented in all
> > 64 bit AMD processors and there are more today then K8. The k8_nb was
> > historically chosen and misleading today.
> 
> OK, fair enough.  However, unless it is actually used in 32-bit mode
> calling it amd_gart_64.c is probably better than amd64_gart.c since an
> "amd64" processor can also be run in 32-bit mode.

Fine with me :) Here is the patch.

>From fffcda1183e93df84ad73ba7eb7782a5c354e2b3 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joerg.roedel@amd.com>
Date: Tue, 10 May 2011 17:22:06 +0200
Subject: [PATCH] x86, gart: Rename pci-gart_64.c to amd_gart_64.c

This file only contains code relevant for the northbridge
gart in AMD processors. This patch renames the file to
represent this fact in the filename.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 Documentation/x86/x86_64/boot-options.txt        |    2 +-
 arch/x86/kernel/Makefile                         |    2 +-
 arch/x86/kernel/{pci-gart_64.c => amd_gart_64.c} |    0
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/x86/kernel/{pci-gart_64.c => amd_gart_64.c} (100%)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 092e596..c54b4f5 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -206,7 +206,7 @@ IOMMU (input/output memory management unit)
       (e.g. because you have < 3 GB memory).
       Kernel boot message: "PCI-DMA: Disabling IOMMU"
 
-   2. <arch/x86_64/kernel/pci-gart.c>: AMD GART based hardware IOMMU.
+   2. <arch/x86/kernel/amd_gart_64.c>: AMD GART based hardware IOMMU.
       Kernel boot message: "PCI-DMA: using GART IOMMU"
 
    3. <arch/x86_64/kernel/pci-swiotlb.c> : Software IOMMU implementation. Used
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 7338ef2..97ebf82e 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -117,7 +117,7 @@ obj-$(CONFIG_OF)			+= devicetree.o
 ifeq ($(CONFIG_X86_64),y)
 	obj-$(CONFIG_AUDIT)		+= audit_64.o
 
-	obj-$(CONFIG_GART_IOMMU)	+= pci-gart_64.o aperture_64.o
+	obj-$(CONFIG_GART_IOMMU)	+= amd_gart_64.o aperture_64.o
 	obj-$(CONFIG_CALGARY_IOMMU)	+= pci-calgary_64.o tce_64.o
 	obj-$(CONFIG_AMD_IOMMU)		+= amd_iommu_init.o amd_iommu.o
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/amd_gart_64.c
similarity index 100%
rename from arch/x86/kernel/pci-gart_64.c
rename to arch/x86/kernel/amd_gart_64.c
-- 
1.7.4.1


