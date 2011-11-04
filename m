Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab1KDS1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 14:27:06 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:40777 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1KDS1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 14:27:04 -0400
Date: Fri, 4 Nov 2011 14:31:10 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, thellstrom@vmware.com, thomas@shipmail.org,
        airlied@redhat.com, jglisse@redhat.com, bskeggs@redhat.com,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH] TTM DMA pool v2.2 or [GIT PULL]
 (stable/ttm.dma_pool.v2.3) for 3.3
Message-ID: <20111104183110.GC2015@homer.localdomain>
References: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320173252-2812-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 02:47:21PM -0400, Konrad Rzeszutek Wilk wrote:
> I am not sure what the right way to patches in Dave tree is for Linux 3.3, so I
> am posting the patches and also providing the means of doing a git pull.
> 
> The git tree is:
> 
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/ttm.dma_pool.v2.3
> 
> 
> Oh, and Thomas, should I add your Ack on the patches as well? I think it was an implied
> Ack, but I do not want to presume. If so, I can respin this with your Ack shortly.
> 
> and it has since v2.1: https://lwn.net/Articles/463815/
>  - Fixed bugs/mistakes pointed out by Jerome
>  - Added Review-by: Jereme Glisse
> Since v2.0: [not posted]
>  - Redid the registration/override to be tightly integrated with the
>    'struct ttm_backend_func' per Thomas's suggestion.
> Since v1.9: [not posted]
>  - Performance improvements - it was doing O(n^2) instead of O(n) on certain
>    workloads.
> Since v1.8: [lwn.net/Articles/458724/]
>  - Removed swiotlb_enabled and used swiotlb_nr_tbl.
>  - Added callback for changing cache types.
> Since v1.7: [https://lkml.org/lkml/2011/8/30/460]
>  - Fixed checking the DMA address in radeon/nouveau code.
> Since v1: [http://lwn.net/Articles/456246/]
>  - Ran it through the gauntlet of SubmitChecklist and fixed issues
>  - Made radeon/nouveau driver set coherent_dma (which is required for dmapool)
> 
> [.. and this is what I said in v1 post]:
> 
> Way back in January this patchset:
> http://lists.freedesktop.org/archives/dri-devel/2011-January/006905.html
> was merged in, but pieces of it had to be reverted b/c they did not
> work properly under PowerPC, ARM, and when swapping out pages to disk.
> 
> After a bit of discussion on the mailing list
> http://marc.info/?i=4D769726.2030307@shipmail.org I started working on it, but
> got waylaid by other things .. and finally I am able to post the RFC patches.
> 
> There was a lot of discussion about it and I am not sure if I captured
> everybody's thoughts - if I did not - that is _not_ intentional - it has just
> been quite some time..
> 
> Anyhow .. the patches explore what the "lib/dmapool.c" does - which is to have a
> DMA pool that the device has associated with. I kind of married that code
> along with drivers/gpu/drm/ttm/ttm_page_alloc.c to create a TTM DMA pool code.
> The end result is DMA pool with extra features: can do write-combine, uncached,
> writeback (and tracks them and sets back to WB when freed); tracks "cached"
> pages that don't really need to be returned to a pool; and hooks up to
> the shrinker code so that the pools can be shrunk.
> 
> If you guys think this set of patches make sense  - my future plans were
>  1) Get this in large crowd of testing .. and if it works for a kernel release
>  2) to move a bulk of this in the lib/dmapool.c (I spoke with Matthew Wilcox
>     about it and he is OK as long as I don't introduce performance regressions).
> 
> In regards to testing, I've been running them non-stop for the last two months.
> (and found some issues which I've fixed up) - and been quite happy with how
> they work.
> 
> Michel (thanks!) took a spin of the patches on his PowerPC and they did not
> cause any regressions (wheew).
> 
> The patches are also located in a git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/ttm.dma_pool.v2.3
> 

On what hw did you tested ? With and without xen ? Here radeon
that doesn't need dma32 doesn't work when forcing swiotlb which
kind of expected i guess. Should we expose if swiotlb is enabled
forced so we use dma pool in such case ?

Cheers,
Jerome
