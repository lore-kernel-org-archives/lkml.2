Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab0FBTqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 15:46:33 -0400
Received: from 8bytes.org ([88.198.83.132]:36808 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755013Ab0FBTqb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 15:46:31 -0400
Date: Wed, 2 Jun 2010 21:46:30 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Tom Lyon <pugs@lyon-about.com>
Cc: Chris Wright <chrisw@sous-sol.org>, "Michael S. Tsirkin" <mst@redhat.com>,
       Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de,
       aafabbri@cisco.com, scofeldm@cisco.com
Subject: Re: [PATCH] VFIO driver: Non-privileged user level PCI drivers
Message-ID: <20100602194630.GF11162@8bytes.org>
References: <20100601095532.GA9178@redhat.com> <20100602121927.GA11162@8bytes.org> <20100602174615.GV8301@sequoia.sous-sol.org> <201006021109.17838.pugs@lyon-about.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006021109.17838.pugs@lyon-about.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 02, 2010 at 11:09:17AM -0700, Tom Lyon wrote:
> On Wednesday 02 June 2010 10:46:15 am Chris Wright wrote:

> > This is not any hot path, so saving an ioctl shouldn't be a consideration.
> > Only important consideration is a good API.  I may have lost context here,
> > but the SHARE API is limited to the vfio fd.  The BIND API expects a new
> > iommu object.  Are there other uses for this object?  Tom's current vfio
> > driver exposes a dma mapping interface, would the iommu object expose
> > one as well?  Current interface is device specific DMA interface for
> > host device drivers typically mapping in-flight dma buffers, and IOMMU
> > specific interface for assigned devices typically mapping entire virtual
> > address space.
> 
> Actually, it a domain object - which may be usable among iommus (Joerg?).

Yes, this 'iommu' thing is would be a domain object. But sharing among
iommus is not necessary because the fact that there are multiple iommus
in the system is hidden by the iommu drivers. This fact is not even
exposed by the iommu-api. This makes protection domains system global.

> However, you can't really do the dma mapping with just the domain because
> every device supports a different size address space as a master, i.e.,
> the dma_mask.

The dma_mask has to be handled by the device driver. With the
iommu-mapping interface the driver can specify the target io-address and
has to consider the dma_mask for that too.

> And I don't know how kvm would deal with devices with varying dma mask support,
> or why they'd be in the same domain.

KVM does not care about these masks. This is the business of the guest
device drivers.

	Joerg

