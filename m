Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757939Ab1KKPbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 10:31:51 -0500
Received: from 8bytes.org ([88.198.83.132]:43771 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab1KKPbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 10:31:50 -0500
Date: Fri, 11 Nov 2011 16:31:48 +0100
From: Joerg Roedel <joro@8bytes.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86 amd_gart_64: Verify we can perform the
	remapping requested
Message-ID: <20111111153148.GC11779@8bytes.org>
References: <m1lisj48q1.fsf@fess.ebiederm.org> <m1fwir48og.fsf@fess.ebiederm.org> <20111024100735.GL1512@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111024100735.GL1512@8bytes.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 12:07:36PM +0200, Joerg Roedel wrote:
> On Mon, Oct 17, 2011 at 02:20:15PM -0700, Eric W. Biederman wrote:
> > 
> > Recently I had a driver try with a peculiar 2G dma memory limit.
> > The driver failed in weird and strange ways because the GART remapping
> > apperture had been allocated above 2G where the driver cound not reach,
> > and no error was reported when the mappings were setup.
> > 
> > Implement gart_dma_supported to test for this problem case and to return
> > and error if we can not support the remapping.
> 
> You do basically the same as for swiotlb, so it must be good :)

Okay, thinking more about this, I am not so sure anymore it is a really
good idea to fix it this way. It basically signals the driver that DMA
is not possible with the device if the aperture does not fit into
the dma_mask. But DMA within the ZONE_DMA might still work, no?

So I think the right way to fix it is to return a dma-mapping error if
and only if the address needs to be remapped by the aperture (of swiotlb or
gart).

This still allows the driver to use GFP_DMA allocations.


	Joerg

