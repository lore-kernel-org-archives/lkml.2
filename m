Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1A1PEv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 10:04:51 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62165 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1A1PEu (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 28 Jan 2011 10:04:50 -0500
Date: Fri, 28 Jan 2011 10:03:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: dri-devel@lists.freedesktop.org, thomas@shipmail.org, airlied@linux.ie,
        linux-kernel@vger.kernel.org, Alex Deucher <alexdeucher@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>, konrad@darnok.org
Subject: Re: [PATCH 4/5] radeon/ttm/PCIe: Use dma_addr if TTM has set it.
Message-ID: <20110128150310.GA29440@dumpdata.com>
References: <1294420304-24811-1-git-send-email-konrad.wilk@oracle.com>
 <1294420304-24811-5-git-send-email-konrad.wilk@oracle.com>
 <20110127212001.GC4542@dumpdata.com>
 <AANLkTimKgfKwtWpXBvTGmJbW-2uGhV+7nMahsScUM0pr@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimKgfKwtWpXBvTGmJbW-2uGhV+7nMahsScUM0pr@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 09:42:48AM -0500, Jerome Glisse wrote:
> On Thu, Jan 27, 2011 at 4:20 PM, Konrad Rzeszutek Wilk
> <konrad.wilk@oracle.com> wrote:
> > On Fri, Jan 07, 2011 at 12:11:43PM -0500, Konrad Rzeszutek Wilk wrote:
> >> If the TTM layer has used the DMA API to setup pages that are
> >> TTM_PAGE_FLAG_DMA32 (look at patch titled: "ttm: Utilize the dma_addr_t
> >> array for pages that are to in DMA32 pool."), lets use it
> >> when programming the GART in the PCIe type cards.
> >>
> >> This patch skips doing the pci_map_page (and pci_unmap_page) if
> >> there is a DMA addresses passed in for that page. If the dma_address
> >> is zero (or DMA_ERROR_CODE), then we continue on with our old
> >> behaviour.
> >
> > Hey Jerome,
> >
> > I should have CC-ed you earlier but missed that and instead just
> > CC-ed the mailing list. I was wondering what your thoughts are
> > about this patchset? Thomas took a look at the patchset and he is OK
> > but more eyes never hurt.
> >
> > FYI, for clarity I hadn't made the old calls that got moved due
> > to adding of "{" checkpatch.pl compliant. It complains about it being
> > past 80 characters. I can naturally fix that up, but thought
> > that it might detract from the nature of the patch.
> 
> What happen when we don't ask dma32 alloc to ttm ? Will this still
> work in virtualized environnement ?

You mean if we don't pass in the TTM_PAGE_FLAG_DMA32? It will go back
to using the old mechanism - which is to allocate page using
alloc_page(GFP_HIGHUSER). Which should be OK in baremetal or
virtualized environment - and as long as the driver uses the page
for non-DMA type things, or the graphic card is 64-bit capable at which
point it has no trouble reaching it.

> 
> Code looks good but GART stuff can be picky, i will try to do a full
> scale testing in next couple week.

Thank you! Much appreciated. Would it be OK if I pinged you in two weeks
time just in case?
