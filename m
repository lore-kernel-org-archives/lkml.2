Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab0GVSem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:34:42 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:43545 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750776Ab0GVSek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:34:40 -0400
Subject: Re: swiotlb detection should be memory hotplug aware ?
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>, "x86@kernel.org" <x86@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Petr Vandrovec <petr@vmware.com>
In-Reply-To: <20100722090329O.fujita.tomonori@lab.ntt.co.jp>
References: <20100721135750Z.fujita.tomonori@lab.ntt.co.jp>
	 <1279732414.10874.6.camel@ank32.eng.vmware.com>
	 <20100722084413I.fujita.tomonori@lab.ntt.co.jp>
	 <20100722090329O.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain
Organization: VMware INC.
Date: Thu, 22 Jul 2010 11:34:40 -0700
Message-Id: <1279823680.31733.20.camel@ank32.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2010-07-21 at 17:03 -0700, FUJITA Tomonori wrote:
> On Thu, 22 Jul 2010 08:44:42 +0900
> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> wrote:
> 
> > On Wed, 21 Jul 2010 10:13:34 -0700
> > Alok Kataria <akataria@vmware.com> wrote:
> > 
> > > > Basically, you want to add hot-plug memory and enable swiotlb, right?
> > > 
> > > Not really, I am planning to do something like this, 
> > > 
> > > @@ -52,7 +52,7 @@ int __init pci_swiotlb_detect(void)
> > >  
> > >  	/* don't initialize swiotlb if iommu=off (no_iommu=1) */
> > >  #ifdef CONFIG_X86_64
> > > -	if (!no_iommu && max_pfn > MAX_DMA32_PFN)
> > > +	if (!no_iommu && (max_pfn > MAX_DMA32_PFN || hotplug_possible()))
> > >  		swiotlb = 1;
> > 
> > Always enable swiotlb with memory hotplug enabled?

yep though only on systems which have hotpluggable memory support.

>  Wasting 64MB on a
> > x86_64 system with 128MB doesn't look to be a good idea. I don't think
> > that there is an easy solution for this issue though.

Good now that you agree that, that's the only feasible solution, do you
have any suggestions for any interfaces that are available from SRAT for
implementing hotplug_possible ?

> 
> btw, you need more work to enable switch on the fly.
> 
> You need to change the dma_ops pointer (see get_dma_ops()). It means
> that you need to track outstanding dma operations per device, locking,
> etc.

Yeah though if we are doing this during swiotlb_init time i.e. at bootup
as suggested in the pseudo patch, we don't need to worry about all this,
right ? 

Thanks,
Alok

