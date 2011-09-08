Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932461Ab1IHI6p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:58:45 -0400
Received: from 8bytes.org ([88.198.83.132]:45248 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402Ab1IHI6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:58:44 -0400
Date: Thu, 8 Sep 2011 10:58:42 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Don Dutile <ddutile@redhat.com>
Cc: Greg KH <gregkh@suse.de>, Ohad Ben-Cohen <ohad@wizery.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 02/10] Driver core: Add iommu_ops to bus_type
Message-ID: <20110908085842.GD31674@8bytes.org>
References: <1315410113-26608-1-git-send-email-joerg.roedel@amd.com> <1315410113-26608-3-git-send-email-joerg.roedel@amd.com> <20110907184750.GA920@suse.de> <20110907191919.GA31674@8bytes.org> <20110907194445.GA2526@suse.de> <4E67D5F7.6070103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E67D5F7.6070103@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 04:37:11PM -0400, Don Dutile wrote:
> On 09/07/2011 03:44 PM, Greg KH wrote:

>> Why are you pushing this down into the driver core?  What other busses
>> becides PCI use/need this?
>>
>> If you can have a different IOMMU driver on the same bus, then wouldn't
>> this be a per-device thing instead of a per-bus thing?
>>
> And given the dma api takes a struct device *, it'd be more efficient
> to be tied into the device structure.

More efficient in what way? Currently no dma-api implementation uses the
iommu-api directly. It is planned to change that, of course. But the
dma-api implementation will use the iommu_map/iommu_unmap functions which
get an iommu_domain parameter and no device structure. Thats why the
domain structure keeps an iommu_ops pointer too.

> Device structure would get iommu ops set by parent(bus);
> if a bus (segment) doesn't provide a unique/different/layered IOMMU
> then the parent bus, it inherits the parent's iommu-ops.
> setting the iommu-ops in the root bus struct, seeds the iommu-ops
> for the (PCI) tree.
>
> For intel & amd IOMMUs, in early pci (bios,root?) init, you would
> seed the pci root busses with appropriate IOMMU support (based on
> dmar/drhd & ivrs/ivhd data structures, respectively), and
> then modify the PCI code to do the inheritence (PPB code inherits
> unless specific device driver for a given PPB vid-did loads a
> different iommu-ops for that segment/branch).
>
> This would enable different types of IOMMUs for different devices
> (or PCI segments, or branches of PCI trees) that are designed for
> different tasks -- simple IOMMUs for legacy devices; complicated, io-page-faulting
> IOMMUs for plug-in, high-end devices on virtualizing servers for PCI (SRIOV) endpoints.

This only works for pci, but the iommu-api is not pci-only.

> and as Greg indicates, is only relevant to PCI.

We already have non-pci iommu drivers implementing the iommu-api. So
this is certainly relevant outside pci too.

	Joerg

