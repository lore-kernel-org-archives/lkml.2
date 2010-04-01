Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758711Ab0DATVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:21:11 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:58957 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab0DATVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:21:08 -0400
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAL6OtEurRN+J/2dsb2JhbACbPXGdJZkKhQEEgyM
X-IronPort-AV: E=Sophos;i="4.51,350,1267401600"; 
   d="scan'208";a="507084181"
From: Tom Lyon <pugs@lyon-about.com>
To: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged processes
Date: Thu, 1 Apr 2010 12:18:27 -0700
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201003311708.38961.pugs@lyon-about.com> <201004010840.34574.pugs@lyon-about.com> <20100401160746.GH24846@8bytes.org>
In-Reply-To: <20100401160746.GH24846@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004011218.28002.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010 09:07:47 am Joerg Roedel wrote:
> On Thu, Apr 01, 2010 at 08:40:34AM -0700, Tom Lyon wrote:
> > On Thursday 01 April 2010 05:52:18 am Joerg Roedel wrote:
> > > > The point of this patch is to beef up the uio_pci_generic driver so
> > > > that a non-privileged user process can run a user level driver for
> > > > most PCIe devices. This can only be safe if there is an IOMMU in the
> > > > system with per-device domains.  Privileged users (CAP_SYS_RAWIO) are
> > > > allowed if there is no IOMMU.
> > >
> > > If you rely on an IOMMU you can use the IOMMU-API instead of the
> > > DMA-API for dma mappings. This change makes this driver suitable for
> > > KVM use too. If the interface is designed clever enough we can even use
> > > it for IOMMU emulation for pass-through devices.
> >
> > The use with privileged processes and no IOMMUs is still quite useful, so
> > I'd rather stick with the DMA interface.
>
> For the KVM use-case we need to be able to specify the io virtual
> address for a given process virtual address. This is not possible with
> the dma-api interface. So if we want to have uio-dma without an hardware
> iommu we need two distinct interfaces for userspace to cover all
> use-cases. I don't think its worth it to have two interfaces.
>
> 	Joerg

I started to add that capability but then realized that the IOMMU API also 
doesn't allow it. The map function allows a range of physically contiguous 
pages, not virtual.

My preferred approach would be to add a DMA_ATTR that would request allocation 
of DMA at a specific device/iommu address.
