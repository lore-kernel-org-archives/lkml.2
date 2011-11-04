Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab1KDU2v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 16:28:51 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:48772 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1KDU2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 16:28:48 -0400
Date: Fri, 4 Nov 2011 15:41:03 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, thellstrom@vmware.com, thomas@shipmail.org,
        airlied@redhat.com, jglisse@redhat.com, bskeggs@redhat.com,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH] TTM DMA pool v2.2 or [GIT PULL]
 (stable/ttm.dma_pool.v2.3) for 3.3
Message-ID: <20111104194102.GA15923@phenom.dumpdata.com>
References: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
 <20111104183110.GC2015@homer.localdomain>
 <20111104184453.GB1616@phenom.dumpdata.com>
 <20111104192451.GE2015@homer.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104192451.GE2015@homer.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EB44ADC.006F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 03:24:51PM -0400, Jerome Glisse wrote:
> On Fri, Nov 04, 2011 at 02:44:53PM -0400, Konrad Rzeszutek Wilk wrote:
> > > > git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/ttm.dma_pool.v2.3
> > > > 
> > > 
> > > On what hw did you tested ? With and without xen ? Here radeon
> > 
> > On AMD and Intel. And with both Nvidia and Radeon cards.
> > 64-bit cards (I have a patch where I forced the 64-bit card to use
> > the TTM DMA pool code to test) and 32-bit cards (ATI ES1000)
> > 
> > On baremetal and Xen. Um, Fedora Core 16 as distro.
> > 
> > Oh, and I also tried PPC (Power Mac 4) but could not get it to boot
> > the 3.1 kernel. Something with the LILO grub loader did not work.
> > 
> > > that doesn't need dma32 doesn't work when forcing swiotlb which
> > > kind of expected i guess. Should we expose if swiotlb is enabled
> > 
> > You did 'swiotlb=force' ?
> > > forced so we use dma pool in such case ?
> 
> Issue is that when booted without force swiotlb_nr_tlb still return
> positive thus we endup using the dma pool path.

Did " Using software bounce buffering for IO (SWIOTLB)" or "software IO TLB at"
show up in the dmesg output? You might have to run it with 'debug loglevel=8'?
Presumarily yes, since the code "swiotlb: Expose.." sets
  io_tlb_nslabs = 0

if there is no need for it. And since io_tlb_nslabs is set, then the code
did start.

Some AMD boxes with the AMD-Vi chipset enable the SWIOTLB b/c not all of
the PCI devices are on the IOMMU chipset path. The Intel VT-d does the same
thing.

Hmm, I think the reason for those devices to turn SWIOTLB on is that they
are not comfortable handling 32-bit devices, and the TTM DMA pool code would
only turn itself on when the radeon|nouveau was 32-bit _and_ SWIOTLB was enabled.

.. Testing the patches you posted on my AMD box.
