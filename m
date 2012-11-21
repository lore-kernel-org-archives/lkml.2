Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab2KUIgv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 03:36:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44593 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab2KUIgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 03:36:50 -0500
Date: Wed, 21 Nov 2012 00:36:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Soren Moch <smoch@web.de>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] mm: dmapool: use provided gfp flags for all
 dma_alloc_coherent() calls
Message-Id: <20121121003643.97febbdb.akpm@linux-foundation.org>
In-Reply-To: <50AC8C14.5050204@samsung.com>
References: <20121119144826.f59667b2.akpm@linux-foundation.org>
	<1353421905-3112-1-git-send-email-m.szyprowski@samsung.com>
	<20121120113325.dde266ed.akpm@linux-foundation.org>
	<50AC8C14.5050204@samsung.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012 09:08:52 +0100 Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> Hello,
> 
> On 11/20/2012 8:33 PM, Andrew Morton wrote:
> > On Tue, 20 Nov 2012 15:31:45 +0100
> > Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> >
> > > dmapool always calls dma_alloc_coherent() with GFP_ATOMIC flag,
> > > regardless the flags provided by the caller. This causes excessive
> > > pruning of emergency memory pools without any good reason. Additionaly,
> > > on ARM architecture any driver which is using dmapools will sooner or
> > > later  trigger the following error:
> > > "ERROR: 256 KiB atomic DMA coherent pool is too small!
> > > Please increase it with coherent_pool= kernel parameter!".
> > > Increasing the coherent pool size usually doesn't help much and only
> > > delays such error, because all GFP_ATOMIC DMA allocations are always
> > > served from the special, very limited memory pool.
> > >
> >
> > Is this problem serious enough to justify merging the patch into 3.7?
> > And into -stable kernels?
> 
> I wonder if it is a good idea to merge such change at the end of current
> -rc period.

I'm not sure what you mean by this.

But what we do sometimes if we think a patch needs a bit more
real-world testing before backporting is to merge it into -rc1 in the
normal merge window, and tag it for -stable backporting.  That way it
gets a few weeks(?) testing in mainline before getting backported.

