Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135Ab2IYNFM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 09:05:12 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:29972
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863Ab2IYNFK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 09:05:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Id6f1izz1202h1d1ah1d2ahzz15d4Iz2dh668h839h944hd25he5bhf0ah11b5h121eh1220h1288h12a5h12a9h12bdh137ah13b6h1155h)
X-WSS-ID: 0MAWPO9-01-FX4-02
X-M-MSG: 
Date: Tue, 25 Sep 2012 15:04:56 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <joro@8bytes.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 12/19] x86, irq: Add data structure to keep AMD specific
 irq remapping information
Message-ID: <20120925130456.GZ2505@amd.com>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-13-git-send-email-joerg.roedel@amd.com>
 <20120826182126.GD3690@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120826182126.GD3690@breakpoint.cc>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 26, 2012 at 08:21:26PM +0200, Sebastian Andrzej Siewior wrote:
> On Mon, Aug 20, 2012 at 03:55:58PM +0200, Joerg Roedel wrote:
> > --- a/arch/x86/include/asm/hw_irq.h
> > +++ b/arch/x86/include/asm/hw_irq.h
> > @@ -101,6 +101,7 @@ static inline void set_io_apic_irq_attr(struct io_apic_irq_attr *irq_attr,
> >  	irq_attr->polarity	= polarity;
> >  }
> >  
> > +/* Intel specific interrupt remapping information */
> >  struct irq_2_iommu {
> >  	struct intel_iommu *iommu;
> >  	u16 irte_index;
> > @@ -108,6 +109,12 @@ struct irq_2_iommu {
> >  	u8  irte_mask;
> >  };
> >  
> > +/* AMD specific interrupt remapping information */
> > +struct irq_2_irte {
> > +	u16 devid; /* Device ID for IRTE table */
> > +	u16 index; /* Index into IRTE table*/
> > +};
> so irte_index like in iommu case would make the comment superfluous. However
> the struct is already named _irte...
> However, the "{Intel|AMD} specific..." is helpfull since irte and such are
> present in both.

Yes, the structs also represent the differences in the remapping
hardware between Intel and AMD very well. On Intel there is one
remapping table per hardware IOMMU so it is important to get from a
given irq to the IOMMU and its remapping table to find the IRTE.

On AMD hardware there is a remapping table per device. So the
coresponding device id is stored in the struct to find the right
remapping table.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

