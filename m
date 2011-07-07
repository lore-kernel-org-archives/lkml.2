Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab1GGKwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 06:52:12 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:13314 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab1GGKwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 06:52:10 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz4015L1432N98dKzz1202hzz15d4R8275bh8275dhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNYM6V-01-02G-02
X-M-MSG: 
Date: Thu, 7 Jul 2011 12:52:04 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [git pull] IOMMU updates for 3.1
Message-ID: <20110707105204.GE1956@amd.com>
References: <20110707085359.GC1956@amd.com>
 <20110707094558.GB15058@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110707094558.GB15058@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 05:45:58AM -0400, Ingo Molnar wrote:
> >   git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu-3.1
> Fails to build with INTR_REMAP=y && CONFIG_DMAR=n:
> 
>  arch/x86/built-in.o: In function `lapic_resume':
>  apic.c:(.text+0x16329): undefined reference to `intr_remapping_enabled'
>  apic.c:(.text+0x1651d): undefined reference to `intr_remapping_enabled'
>  apic.c:(.text+0x1652b): undefined reference to `reenable_intr_remapping'
>  [...]

Fixed with:

commit 6b385b46ee17d7e1a68d3411b8cdb2342e0f0445
Author: Joerg Roedel <joerg.roedel@amd.com>
Date:   Thu Jul 7 12:18:48 2011 +0200

    iommu/core: Fix build with INTR_REMAP=y && CONFIG_DMAR=n
    
    IOMMU_API is not selected when no DMA remapping driver is
    selected, but the whole drivers/iommu/ directory is only
    built with IOMMU_API=y. Fixed with this patch by including
    the directory with IOMMU_SUPPORT instead.
    
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

diff --git a/drivers/Makefile b/drivers/Makefile
index 2f7a71a..2b551e9 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -122,4 +122,4 @@ obj-y				+= ieee802154/
 obj-y				+= clk/
 
 obj-$(CONFIG_HWSPINLOCK)	+= hwspinlock/
-obj-$(CONFIG_IOMMU_API)		+= iommu/
+obj-$(CONFIG_IOMMU_SUPPORT)	+= iommu/

and pushed result to

	git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu-3.1

again. I just pushed so it may take some time until the result appears
on the mirrors.

Thanks,

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

