Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753756Ab2GJRkp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 13:40:45 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36953 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753136Ab2GJRkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 13:40:42 -0400
Date: Tue, 10 Jul 2012 13:32:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Shuah Khan <shuah.khan@hp.com>
Cc: fujita.tomonori@lab.ntt.co.jp, LKML <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        bhelgaas@google.com, amwang@redhat.com, shuahkhan@gmail.com
Subject: Re: [PATCH RFC] swiotlb: Remove SWIOTLB overflow buffer support
Message-ID: <20120710173211.GB6868@phenom.dumpdata.com>
References: <1341615972.3101.27.camel@lorien2>
 <20120709202505.GA9541@phenom.dumpdata.com>
 <1341939307.2502.34.camel@lorien2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341939307.2502.34.camel@lorien2>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 10:55:07AM -0600, Shuah Khan wrote:
> On Mon, 2012-07-09 at 16:25 -0400, Konrad Rzeszutek Wilk wrote:
> > On Fri, Jul 06, 2012 at 05:06:12PM -0600, Shuah Khan wrote:
> > > Remove SWIOTLB overflow buffer support and return DMA_ERROR_CODE
> > > (a value of zero) to make it consistent with iommu implementation
> > > on Intel, AMD, and swiotlb-xen.
> > 
> > While this is a good forward step and this needs to be done eventually,
> > you should first send out patches for the drivers that don't check
> > for the DMA_ERROR_CODE when doing mapping. In other words for the
> > drivers that map but don't call dma_mapping_error to check.
> > 
> > When that is fixed and *all the drivers that don't call dma_mapping_error
> > are fixed, then this patch makes sense.
> 
> The challenge will be catching all the drivers and have confidence that
> all of them are covered. I will start looking into this to get a feel
> for how many drivers needs fixing.

I don't know if all is needed. Some of them might be dead or not used
at all anymore - who knows? This treasure hunt would give a good idea
of which ones are not using the PCI/DMA API right at least.

If it is say, CONFIG_ISA enabled, well, we could #ifdef the overflow
buffer in the swiotlb with that option. And then work through fixing
up those drivers - except that finding folks with that driver to
see if it works .. yuck.. I do have some few ISA cards and some boxes
with ISA slots :-)

> 
> Also, isn't this problem today with other iommu implementations? All of
> the other iommu implementation don't have support for overflow buffers?

Right, but you are in high likehood not going to run the drivers that
don't check this with an IOMMU. Because the drivers are mostly the PCI
variants .. or PCMCIA. And the hardware that would use this did not have
IOMMU.
