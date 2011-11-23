Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1KWUMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 15:12:38 -0500
Received: from sous-sol.org ([216.99.217.87]:52580 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751616Ab1KWUMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 15:12:36 -0500
Date: Wed, 23 Nov 2011 12:12:15 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Chris Wright <chrisw@sous-sol.org>, linux-pci@vger.kernel.org,
        dwmw2@infradead.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu: Include MSI susceptibility to DMA in creating
 iommu groups
Message-ID: <20111123201215.GL3344@sequoia.sous-sol.org>
References: <20111117170800.3125.84150.stgit@bling.home>
 <20111118104651.GJ5627@amd.com>
 <1321628190.26410.63.camel@bling.home>
 <20111118152710.GA5098@amd.com>
 <1321633956.26410.126.camel@bling.home>
 <20111120120043.GB20535@8bytes.org>
 <20111121233505.GG3344@sequoia.sous-sol.org>
 <20111123105612.GD11876@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123105612.GD11876@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joerg Roedel (joerg.roedel@amd.com) wrote:
> On Mon, Nov 21, 2011 at 03:35:05PM -0800, Chris Wright wrote:
> 
> > What is the value of a group w/out complete isolation?
> 
> There is still isolation for DMA. This may be sufficient for non-KVM
> use-cases like a device driver partially implemented in userspace. There
> is no no guest then that can attack the host with wrong interrupts.

There is a userspace process that could though.  I think I'm missing
the distinction.  In either case there is unprivileged code that could
program the hw to generate PCI write transactions that negatively effect
the system.

> > Is there a practical problem w/ conflating the subtleties above?
> 
> Same argument as above. It ties the the iommu_group interface to the KVM
> use case.

I don't agree that it's the KVM use case.  It's the unprivileged code
owning a device use case.  The promise of SR-IOV + IOMMU + PASID shows
hw is trying to go there.

> Another more pratical impact of this patch is that a reboot is
> required to re-enable iommu-groups. When the check happens in VFIO it is
> a simple module-reload.

I suppose, however iommu itself is managed via kernel cmdline and
reboot...

I guess we agree that we need to be able to give the user some way of
managing the risk they're willing to take, and just not on where the
flag should go?

thanks,
-chris
