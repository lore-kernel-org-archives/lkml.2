Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030308Ab2HIOOe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:14:34 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:33051 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab2HIOOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:14:32 -0400
Date: Thu, 9 Aug 2012 09:06:08 -0500 (CDT)
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
In-Reply-To: <50233EF5.3050605@huawei.com>
Message-ID: <alpine.DEB.2.02.1208090900450.15909@greybox.home>
References: <1344482788-4984-1-git-send-email-guohanjun@huawei.com> <50233EF5.3050605@huawei.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012, Hanjun Guo wrote:

> Now, We have node masks for both N_NORMAL_MEMORY and
> N_HIGH_MEMORY to distinguish between normal and highmem on platforms such as x86.
> But we still don't have such a mechanism to distinguish between "normal" and "movable"
> memory.

What is the exact difference that you want to establish?

> As suggested by Christoph Lameter in threads
> http://marc.info/?l=linux-mm&m=134323057602484&w=2, we introduce N_LRU_MEMORY to
> distinguish between "normal" and "movable" memory.

Well seems that I am having second thoughts about this. While is it true
that current page migration can only move pages on the LRU there are
already various mechanisms proposed and implemented that can move pages
not on the LRU (like page table pages). Not sure if this is still a useful
distinction to make. There is also the issue that segments from
"N_LRU_MEMORY" may be allocated and then become not movable anymore.

For the slab case that you want to solve here you will need to know if the
node has *only* movable memory and will never have any ZONE_NORMAL memory.
If so then memory control structures for allocators that do not allow
movable memory will not need to be allocated for these node. The node can
be excluded from handling.
