Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab1KUXfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:35:43 -0500
Received: from sous-sol.org ([216.99.217.87]:45066 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752242Ab1KUXfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:35:41 -0500
Date: Mon, 21 Nov 2011 15:35:05 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] iommu: Include MSI susceptibility to DMA in creating
 iommu groups
Message-ID: <20111121233505.GG3344@sequoia.sous-sol.org>
References: <20111117170800.3125.84150.stgit@bling.home>
 <20111118104651.GJ5627@amd.com>
 <1321628190.26410.63.camel@bling.home>
 <20111118152710.GA5098@amd.com>
 <1321633956.26410.126.camel@bling.home>
 <20111120120043.GB20535@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111120120043.GB20535@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joerg Roedel (joro@8bytes.org) wrote:
> >From device standpoint a MSI transaction is always a DMA memory write
> to a given address range. The IOMMU-API should export a feature flag
> whether it supports filtering on those transaction or not. We have that
> today with the IOMMU_CAP_INTR_REMAP. I agree that the interface to get
> this information is ugly because a domain is needed. But the interface
> can be fixed. While doing this I suggest to rename that feature
> IOMMU_CAP_INTR_ISOLATION or something like that.
> VFIO can then check for this flag on module-load and refuse to load if
> it is not available.

I can see that the native grouping (the typical pci bridge type) is
really more a property of the topology.

The isolation properties of a group (arguably the whole point of the
group) is subtly different.

Leaves the questions:

What is the value of a group w/out complete isolation?
Is there a practical problem w/ conflating the subtleties above?

thanks,
-chris
