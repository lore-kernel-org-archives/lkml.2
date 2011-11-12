Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1KLJCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 04:02:09 -0500
Received: from 8bytes.org ([88.198.83.132]:47602 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab1KLJCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 04:02:05 -0500
Date: Sat, 12 Nov 2011 10:02:03 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86 amd_gart_64: Verify we can perform the
	remapping requested
Message-ID: <20111112090203.GD11779@8bytes.org>
References: <m1lisj48q1.fsf@fess.ebiederm.org> <m1fwir48og.fsf@fess.ebiederm.org> <20111024100735.GL1512@8bytes.org> <20111111153148.GC11779@8bytes.org> <m11uteo57u.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m11uteo57u.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 10:59:33AM -0800, Eric W. Biederman wrote:
> Joerg Roedel <joro@8bytes.org> writes:
> > Okay, thinking more about this, I am not so sure anymore it is a really
> > good idea to fix it this way. It basically signals the driver that DMA
> > is not possible with the device if the aperture does not fit into
> > the dma_mask. But DMA within the ZONE_DMA might still work, no?
> >
> > So I think the right way to fix it is to return a dma-mapping error if
> > and only if the address needs to be remapped by the aperture (of swiotlb or
> > gart).
> 
> Perhaps I am mistaken but since the method is iommu type specific if we
> don't actually use the iommu we should not call the method so I think
> this is patch is already implementing what you want.

No it does not. With GART or SWIOTLB all DMA-mapping functions call
directly into the IOMMU driver. The driver then checks whether it needs
to remap or not (see dma_capable() in SWIOTLB or need_iommu() in GART).

I think the check you want to add needs to happen after these checks in
each of the IOMMU drivers.


	Joerg

