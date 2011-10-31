Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab1JaWBt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:01:49 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:33441 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753101Ab1JaWBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:01:48 -0400
Date: Mon, 31 Oct 2011 18:05:57 -0400
From: Jerome Glisse <j.glisse@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        thellstrom@vmware.com, thomas@shipmail.org, airlied@redhat.com,
        xen-devel@lists.xensource.com, j.glisse@redhat.com, bskeggs@redhat.com
Subject: Re: [PATCH] TTM DMA pool v2.1
Message-ID: <20111031220557.GD3036@homer.localdomain>
References: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319062772-2793-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 06:19:21PM -0400, Konrad Rzeszutek Wilk wrote:
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
> But before I do any of that a second set of eyes taking a look at these
> patches would be most welcome.
> 
> In regards to testing, I've been running them non-stop for the last month.
> (and found some issues which I've fixed up) - and been quite happy with how
> they work.
> 
> Michel (thanks!) took a spin of the patches on his PowerPC and they did not
> cause any regressions (wheew).
> 
> The patches are also located in a git tree:
> 

Reviewed the patch series, looks good, already sent comment on
one of the patch. I am on the same side of Thomas for dma stuff,
lately i have been working on GPU virtual memory address space
and i believe having driver allocating the ttm_tt and merging
more stuff in the backend make sense, after all the backend
has better knowledge on both cache preference and dma mask.

So far my idea is to merge ttm_tt & ttm_backend, simplify the
backend function to bind/unbind/destroy where bind is
responsible to allocate or not a ttm_tt and pages that goes
along with it. I will try to sketch up patches for all this
in next few days.

Reviewed-by: Jerome Glisse <jglisse@redhat.com>

Cheers,
Jerome Glisse
