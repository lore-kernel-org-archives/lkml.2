Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab1FHJhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:37:47 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:22179
	"EHLO CH1EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752955Ab1FHJhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:37:45 -0400
X-SpamScore: -21
X-BigFish: VPS-21(zz936eK1432N98dKzz1202hzz15d4Rz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMGTER-01-5JT-02
X-M-MSG: 
Date: Wed, 8 Jun 2011 11:38:01 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: David Woodhouse <dwmw2@infradead.org>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, David Brown <davidb@codeaurora.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 4/4] x86: intel-iommu: move to drivers/iommu/
Message-ID: <20110608093801.GH4407@amd.com>
References: <1307522062-19273-1-git-send-email-ohad@wizery.com>
 <1307522062-19273-5-git-send-email-ohad@wizery.com>
 <1307524659.4771.12.camel@i7.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1307524659.4771.12.camel@i7.infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 05:17:38AM -0400, David Woodhouse wrote:
> On Wed, 2011-06-08 at 11:34 +0300, Ohad Ben-Cohen wrote:
> > --- a/drivers/pci/Makefile
> > +++ b/drivers/pci/Makefile
> > @@ -30,7 +30,7 @@ obj-$(CONFIG_PCI_MSI) += msi.o
> >  obj-$(CONFIG_HT_IRQ) += htirq.o
> >  
> >  # Build Intel IOMMU support
> > -obj-$(CONFIG_DMAR) += dmar.o iova.o intel-iommu.o
> > +obj-$(CONFIG_DMAR) += dmar.o iova.o
> >  
> >  obj-$(CONFIG_INTR_REMAP) += dmar.o intr_remapping.o
> >  
> 
> At least iova.o wants to go with it. That's one of the parts that is a
> candidate for harmonisation across IOMMU implementations, either by
> removing it or by having others use it too. It's how we allocate virtual
> I/O address space.
> 
> I suspect the interrupt remapping support may well want to move with it
> too. It's no more out-of-place in drivers/iommu than it is in
> drivers/pci. And then you can certainly move dmar.o too.

Interrupt remapping certainly makes sense too. I am not sure yet how to
generalize it because the AMD version of it is significantly different
from VT-d, but we'll see.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

