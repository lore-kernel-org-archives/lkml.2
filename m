Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850Ab0DAUJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:09:14 -0400
Received: from 8bytes.org ([88.198.83.132]:52442 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758829Ab0DAUJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:09:12 -0400
Date: Thu, 1 Apr 2010 22:09:10 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tom Lyon <pugs@lyon-about.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for
	non-privileged processes
Message-ID: <20100401200910.GJ24846@8bytes.org>
References: <201003311708.38961.pugs@lyon-about.com> <201004010840.34574.pugs@lyon-about.com> <20100401160746.GH24846@8bytes.org> <201004011218.28002.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004011218.28002.pugs@lyon-about.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 12:18:27PM -0700, Tom Lyon wrote:
> On Thursday 01 April 2010 09:07:47 am Joerg Roedel wrote:
> > For the KVM use-case we need to be able to specify the io virtual
> > address for a given process virtual address. This is not possible with
> > the dma-api interface. So if we want to have uio-dma without an hardware
> > iommu we need two distinct interfaces for userspace to cover all
> > use-cases. I don't think its worth it to have two interfaces.
> 
> I started to add that capability but then realized that the IOMMU API also 
> doesn't allow it. The map function allows a range of physically contiguous 
> pages, not virtual.

The IOMMU-API allows that. You have to convert the user-virtual
addresses into physical addresses first. The current KVM code
already does this and uses the IOMMU-API later. You can have a look at
the gfn_to_pfn() function for a way to implement this.

> My preferred approach would be to add a DMA_ATTR that would request
> allocation of DMA at a specific device/iommu address.

No, that would be feature duplication between both APIs. Not to mention
the implementation hell this additional dma-api feature would cause for
the iommu driver developers.

	Joerg

