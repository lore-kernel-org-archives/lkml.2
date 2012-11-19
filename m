Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab2KSWs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 17:48:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52509 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753130Ab2KSWs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 17:48:28 -0500
Date: Mon, 19 Nov 2012 14:48:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
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
Message-Id: <20121119144826.f59667b2.akpm@linux-foundation.org>
In-Reply-To: <20121119001846.GB22106@titan.lakedaemon.net>
References: <1352356737-14413-1-git-send-email-m.szyprowski@samsung.com>
	<20121119001846.GB22106@titan.lakedaemon.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Nov 2012 19:18:46 -0500
Jason Cooper <jason@lakedaemon.net> wrote:

> I've added the maintainers for mm/*.  Hopefully they can let us know if
> this is good for v3.8...

As Marek has inexplicably put this patch into linux-next via his tree,
we don't appear to be getting a say in the matter!

The patch looks good to me.  That open-coded wait loop predates the
creation of bitkeeper tree(!) but doesn't appear to be needed.  There
will perhaps be some behavioural changes observable for GFP_KERNEL
callers as dma_pool_alloc() will no longer dip into page reserves but I
see nothing special about dma_pool_alloc() which justifies doing that
anyway.

The patch makes pool->waitq and its manipulation obsolete, but it
failed to remove all that stuff.

The changelog failed to describe the problem which Soren reported. 
That should be included, and as the problem sounds fairly serious we
might decide to backport the fix into -stable kernels.

dma_pool_alloc()'s use of a local "struct dma_page *page" is
distressing - MM developers very much expect a local called "page" to
have type "struct page *".  But that's a separate issue.

As this patch is already in -next and is stuck there for two more
weeks I can't (or at least won't) merge this patch, so I can't help
with any of the above.

