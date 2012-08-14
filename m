Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2HNL6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:58:25 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:63899 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604Ab2HNL6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:58:24 -0400
Message-ID: <502A3CD2.9000007@huawei.com>
Date: Tue, 14 Aug 2012 19:56:02 +0800
From: Hanjun Guo <guohanjun@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: "Christoph Lameter (Open Source)" <cl@linux.com>
CC: Wu Jianguo <wujianguo@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        Tony Luck <tony.luck@intel.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>
Subject: Re: [RFC PATCH] mm: introduce N_LRU_MEMORY to distinguish between
 normal and movable memory
References: <1344482788-4984-1-git-send-email-guohanjun@huawei.com> <50233EF5.3050605@huawei.com> <alpine.DEB.2.02.1208090900450.15909@greybox.home> <5024CADC.1010202@huawei.com> <alpine.DEB.2.02.1208100909410.3903@greybox.home>
In-Reply-To: <alpine.DEB.2.02.1208100909410.3903@greybox.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.69.25]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/8/10 22:12, Christoph Lameter (Open Source) wrote:
> On Fri, 10 Aug 2012, Hanjun Guo wrote:
> 
>> On 2012/8/9 22:06, Christoph Lameter (Open Source) wrote:
>>> On Thu, 9 Aug 2012, Hanjun Guo wrote:
>>>
>>>> Now, We have node masks for both N_NORMAL_MEMORY and
>>>> N_HIGH_MEMORY to distinguish between normal and highmem on platforms such as x86.
>>>> But we still don't have such a mechanism to distinguish between "normal" and "movable"
>>>> memory.
>>>
>>> What is the exact difference that you want to establish?
>>
>> Hi Christoph,
>>     Thanks for your comments very much!
>>
>> We want to identify the node only has ZONE_MOVABLE memory.
>> for example:
>> 	node 0: ZONE_DMA, ZONE_DMA32, ZONE_NORMAL--> N_LRU_MEMORY, N_NORMAL_MEMORY
>> 	node 1: ZONE_MOVABLE			 --> N_LRU_MEMORY
>> thus, in SLUB allocator, will not allocate memory control structures for node1.
> 
> So this would change the N_NORMAL_MEMORY definition so that N_NORMAL
> means !LRU allocs possible? So far N_NORMAL_MEMORY has a wider scope of
> meaning. We need an accurate definition of the meaning of all these
> attributes.

Hi Christoph,
Sorry for the late reply.

yes, N_LRU_MEMORY means LRU allocs possible,
N_NORMAL_MEMORY means !LRU allocs possible.
node with ZONE_DMA/ZONE_DMA32/ZONE_NORMAL is marked with N_LRU_MEMORY and N_NORMAL_MEMORY,
node with ZONE_MOVABLE is *only* marked with N_LRU_MEMORY.

> 
>>> For the slab case that you want to solve here you will need to know if the
>>> node has *only* movable memory and will never have any ZONE_NORMAL memory.
>>> If so then memory control structures for allocators that do not allow
>>> movable memory will not need to be allocated for these node. The node can
>>> be excluded from handling.
>>
>> I think this is what we are trying to do in this patch.
>> did I miss something?
> 
> THe meaning of ZONE_NORMAL seems to change which causes confusion. Please
> describe in detail what each of these attributes mean.
> 
> .
> 


