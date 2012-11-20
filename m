Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab2KTKtB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 05:49:01 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:41797 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab2KTKtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 05:49:00 -0500
Message-id: <50AB600C.5010801@samsung.com>
Date: Tue, 20 Nov 2012 11:48:44 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026
 Thunderbird/16.0.2
MIME-version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Cooper <jason@lakedaemon.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, Arnd Bergmann <arnd@arndb.de>,
        Kyungmin Park <kyungmin.park@samsung.com>, Soren Moch <smoch@web.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
References: <1352356737-14413-1-git-send-email-m.szyprowski@samsung.com>
 <20121119001846.GB22106@titan.lakedaemon.net>
 <20121119144826.f59667b2.akpm@linux-foundation.org>
In-reply-to: <20121119144826.f59667b2.akpm@linux-foundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/19/2012 11:48 PM, Andrew Morton wrote:
> On Sun, 18 Nov 2012 19:18:46 -0500
> Jason Cooper <jason@lakedaemon.net> wrote:
>
> > I've added the maintainers for mm/*.  Hopefully they can let us know if
> > this is good for v3.8...
>
> As Marek has inexplicably put this patch into linux-next via his tree,
> we don't appear to be getting a say in the matter!

I've just put this patch to linux-next via my dma-mapping tree to give it
some testing asap to check if other changes to arm dma-mapping are required
or not.

> The patch looks good to me.  That open-coded wait loop predates the
> creation of bitkeeper tree(!) but doesn't appear to be needed.  There
> will perhaps be some behavioural changes observable for GFP_KERNEL
> callers as dma_pool_alloc() will no longer dip into page reserves but I
> see nothing special about dma_pool_alloc() which justifies doing that
> anyway.
>
> The patch makes pool->waitq and its manipulation obsolete, but it
> failed to remove all that stuff.

Right, I missed that part, I will update it asap.

> The changelog failed to describe the problem which Soren reported.
> That should be included, and as the problem sounds fairly serious we
> might decide to backport the fix into -stable kernels.

Ok, I will extend the changelog.

> dma_pool_alloc()'s use of a local "struct dma_page *page" is
> distressing - MM developers very much expect a local called "page" to
> have type "struct page *".  But that's a separate issue.

I will prepare a separate patch cleaning it. I was also a bit surprised
by such naming scheme, but it is probably related to the fact that this
come has not been touched much since a very ancient times.

> As this patch is already in -next and is stuck there for two more
> weeks I can't (or at least won't) merge this patch, so I can't help
> with any of the above.

I will fix both issues in the next version of the patch. Would like to
merge it to your tree or should I keep it in my dma-mapping tree?

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


