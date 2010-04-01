Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056Ab0DAQ5d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:57:33 -0400
Received: from 8bytes.org ([88.198.83.132]:48566 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab0DAQ5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:57:25 -0400
Date: Thu, 1 Apr 2010 18:57:24 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Tom Lyon <pugs@lyon-about.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for
	non-privileged processes
Message-ID: <20100401165724.GI24846@8bytes.org>
References: <201003311708.38961.pugs@lyon-about.com> <20100401142504.GA6338@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100401142504.GA6338@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 01, 2010 at 05:25:04PM +0300, Michael S. Tsirkin wrote:
> On Wed, Mar 31, 2010 at 05:08:38PM -0700, Tom Lyon wrote:
> > uio_pci_generic has previously been discussed on the KVM list, but this patch 
> > has nothing to do with KVM, so it is also going to LKML.
> > 
> > The point of this patch is to beef up the uio_pci_generic driver so that a 
> > non-privileged user process can run a user level driver for most PCIe 
> > devices. This can only be safe if there is an IOMMU in the system with 
> > per-device domains.
> 
> Why? Per-guest domain should be safe enough.

Hardware IOMMUs don't have something like a per-guest domain ;-)
Anyway, if we want to emulate an IOMMU in the guest and make this
working for pass-through devices too we need more than one domain per
guest. Essentially we may need one domain per device.

> >  Privileged users (CAP_SYS_RAWIO) are allowed if there is 
> > no IOMMU.
> 
> qemu does not support it, I doubt this last option is worth having.

Agreed.

> For this reason, I think we should address the problem somwwhat
> differently:
> - Create a character device to represent the iommu
> - This device will handle memory locking etc
> - Allow binding this device to iommu
> - Allow other operations only after iommu is bound

Yes, something like this is needed. But I think we can implement this in
the generic uio-pci-driver. A seperate interface which basically passes
the iommu-api functions to userspace doesn't make sense because it would
also be device-centric like the uio-pci-driver.

	Joerg

