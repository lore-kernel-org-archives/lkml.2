Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403Ab0DAQHy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:07:54 -0400
Received: from 8bytes.org ([88.198.83.132]:58224 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601Ab0DAQHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:07:48 -0400
Date: Thu, 1 Apr 2010 18:07:47 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tom Lyon <pugs@lyon-about.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for
	non-privileged processes
Message-ID: <20100401160746.GH24846@8bytes.org>
References: <201003311708.38961.pugs@lyon-about.com> <20100401125218.GE24846@8bytes.org> <201004010840.34574.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004010840.34574.pugs@lyon-about.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 08:40:34AM -0700, Tom Lyon wrote:
> On Thursday 01 April 2010 05:52:18 am Joerg Roedel wrote:

> > > The point of this patch is to beef up the uio_pci_generic driver so that
> > > a non-privileged user process can run a user level driver for most PCIe
> > > devices. This can only be safe if there is an IOMMU in the system with
> > > per-device domains.  Privileged users (CAP_SYS_RAWIO) are allowed if
> > > there is no IOMMU.
> >
> > If you rely on an IOMMU you can use the IOMMU-API instead of the DMA-API
> > for dma mappings. This change makes this driver suitable for KVM use
> > too. If the interface is designed clever enough we can even use it for
> > IOMMU emulation for pass-through devices.

> The use with privileged processes and no IOMMUs is still quite useful, so I'd 
> rather stick with the DMA interface.

For the KVM use-case we need to be able to specify the io virtual
address for a given process virtual address. This is not possible with
the dma-api interface. So if we want to have uio-dma without an hardware
iommu we need two distinct interfaces for userspace to cover all
use-cases. I don't think its worth it to have two interfaces.

	Joerg

