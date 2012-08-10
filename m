Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758083Ab2HJOMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 10:12:55 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:45590 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757618Ab2HJOMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 10:12:49 -0400
Date: Fri, 10 Aug 2012 09:12:25 -0500 (CDT)
From: "Christoph Lameter (Open Source)" <cl@linux.com>
X-X-Sender: cl@greybox.home
To: Hanjun Guo <guohanjun@huawei.com>
cc: Wu Jianguo <wujianguo@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tony Luck <tony.luck@intel.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC PATCH] mm: introduce N_LRU_MEMORY to distinguish between
 normal and movable memory
In-Reply-To: <5024CADC.1010202@huawei.com>
Message-ID: <alpine.DEB.2.02.1208100909410.3903@greybox.home>
References: <1344482788-4984-1-git-send-email-guohanjun@huawei.com> <50233EF5.3050605@huawei.com> <alpine.DEB.2.02.1208090900450.15909@greybox.home> <5024CADC.1010202@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2012, Hanjun Guo wrote:

> On 2012/8/9 22:06, Christoph Lameter (Open Source) wrote:
> > On Thu, 9 Aug 2012, Hanjun Guo wrote:
> >
> >> Now, We have node masks for both N_NORMAL_MEMORY and
> >> N_HIGH_MEMORY to distinguish between normal and highmem on platforms such as x86.
> >> But we still don't have such a mechanism to distinguish between "normal" and "movable"
> >> memory.
> >
> > What is the exact difference that you want to establish?
>
> Hi Christoph,
>     Thanks for your comments very much!
>
> We want to identify the node only has ZONE_MOVABLE memory.
> for example:
> 	node 0: ZONE_DMA, ZONE_DMA32, ZONE_NORMAL--> N_LRU_MEMORY, N_NORMAL_MEMORY
> 	node 1: ZONE_MOVABLE			 --> N_LRU_MEMORY
> thus, in SLUB allocator, will not allocate memory control structures for node1.

So this would change the N_NORMAL_MEMORY definition so that N_NORMAL
means !LRU allocs possible? So far N_NORMAL_MEMORY has a wider scope of
meaning. We need an accurate definition of the meaning of all these
attributes.

> > For the slab case that you want to solve here you will need to know if the
> > node has *only* movable memory and will never have any ZONE_NORMAL memory.
> > If so then memory control structures for allocators that do not allow
> > movable memory will not need to be allocated for these node. The node can
> > be excluded from handling.
>
> I think this is what we are trying to do in this patch.
> did I miss something?

THe meaning of ZONE_NORMAL seems to change which causes confusion. Please
describe in detail what each of these attributes mean.
