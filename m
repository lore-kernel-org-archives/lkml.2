Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab1KRO4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:56:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797Ab1KRO4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:56:37 -0500
Message-ID: <1321628190.26410.63.camel@bling.home>
Subject: Re: [PATCH] iommu: Include MSI susceptibility to DMA in creating
 iommu groups
From: Alex Williamson <alex.williamson@redhat.com>
To: Joerg Roedel <Joerg.Roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, dwmw2@infradead.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 18 Nov 2011 07:56:30 -0700
In-Reply-To: <20111118104651.GJ5627@amd.com>
References: <20111117170800.3125.84150.stgit@bling.home>
	 <20111118104651.GJ5627@amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-11-18 at 11:46 +0100, Joerg Roedel wrote:
> On Thu, Nov 17, 2011 at 10:09:26AM -0700, Alex Williamson wrote:
> > IOMMU drivers should account for the platform's susceptibility to
> > DMA triggered MSI interrupts in creating IOMMU groups.  Skip
> > devices when the IOMMU can't isolate MSI from DMA, but allow
> > an iommu=group_unsafe_msi option for opt-in.  This removes the
> > leap in logic for users that IOMMU_CAP_INTR_REMAP is required for
> > interrupt security when they may be running on a non-x86 platform
> > that does not have this dependency.
> 
> I actually don't see the point in this. The iommu-group thing is to tell
> user-space what devices the IOMMU can safely distinguish between. The
> absence of interrupt-remapping changes nothing to that grouping. So why
> remove it when interrupt remapping is not enabled?

As you say, the interface is to tell userspace what devices the IOMMU
can safely distinguish between.  On x86, the IOMMU cannot distinguish
DMA to the interrupt region between devices without interrupt remapping.
Therefore, to only expose devices we can safely distinguish between, we
shouldn't expose any devices by default if we don't provide this
isolation.  The interrupt remapping capability of the IOMMU isn't
exposed to userspace, nor should userspace need to make the leap in
understanding how MSIs are generated on a specific platform and whether
interrupt remapping is required to provide isolation.  Thanks,

Alex

