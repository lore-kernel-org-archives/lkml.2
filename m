Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab2GJXG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 19:06:59 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:17756 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170Ab2GJXG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 19:06:58 -0400
Message-ID: <1341961616.2502.52.camel@lorien2>
Subject: Re: [PATCH RFC] swiotlb: Remove SWIOTLB overflow buffer support
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: fujita.tomonori@lab.ntt.co.jp, LKML <linux-kernel@vger.kernel.org>,
        akpm@linux-foundation.org, paul.gortmaker@windriver.com,
        bhelgaas@google.com, amwang@redhat.com
Date: Tue, 10 Jul 2012 17:06:56 -0600
In-Reply-To: <20120710173211.GB6868@phenom.dumpdata.com>
References: <1341615972.3101.27.camel@lorien2>
	 <20120709202505.GA9541@phenom.dumpdata.com>
	 <1341939307.2502.34.camel@lorien2>
	 <20120710173211.GB6868@phenom.dumpdata.com>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 13:32 -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Jul 10, 2012 at 10:55:07AM -0600, Shuah Khan wrote:
> > On Mon, 2012-07-09 at 16:25 -0400, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Jul 06, 2012 at 05:06:12PM -0600, Shuah Khan wrote:
> > > > Remove SWIOTLB overflow buffer support and return DMA_ERROR_CODE
> > > > (a value of zero) to make it consistent with iommu implementation
> > > > on Intel, AMD, and swiotlb-xen.
> > > 
> > > While this is a good forward step and this needs to be done eventually,
> > > you should first send out patches for the drivers that don't check
> > > for the DMA_ERROR_CODE when doing mapping. In other words for the
> > > drivers that map but don't call dma_mapping_error to check.
> > > 
> > > When that is fixed and *all the drivers that don't call dma_mapping_error
> > > are fixed, then this patch makes sense.
> > 
> > The challenge will be catching all the drivers and have confidence that
> > all of them are covered. I will start looking into this to get a feel
> > for how many drivers needs fixing.
> 
> I don't know if all is needed. Some of them might be dead or not used
> at all anymore - who knows? This treasure hunt would give a good idea
> of which ones are not using the PCI/DMA API right at least.
> 
> If it is say, CONFIG_ISA enabled, well, we could #ifdef the overflow
> buffer in the swiotlb with that option. And then work through fixing
> up those drivers - except that finding folks with that driver to
> see if it works .. yuck.. I do have some few ISA cards and some boxes
> with ISA slots :-)

Looking at the history CONFIG_ISA was disabled back in 2002 and
CONFIG_ISA_DMA_API was disabled in 2004. Sounds like it will be fun
finding drivers that could fail. 

Would it make sense to make io_tlb_overflow a tunable and disable by
default instead of ifdef? Currently it is always enabled, disabling it
by default is another way to find problems?

Good to know you have a few ISA cards. :)

-- Shuah


