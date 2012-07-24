Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2GXRBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 13:01:00 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:58760 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab2GXRA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 13:00:57 -0400
Message-ID: <500ED4B5.4010104@gmail.com>
Date: Wed, 25 Jul 2012 01:00:37 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Jiang Liu <jiang.liu@huawei.com>, WuJianguo <wujianguo@huawei.com>,
        Tony Luck <tony.luck@intel.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>,
        Keping Chen <chenkeping@huawei.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2] SLUB: enhance slub to handle memory nodes without
 normal memory
References: <alpine.DEB.2.00.1207181349370.22907@router.home> <1343123710-4972-1-git-send-email-jiang.liu@huawei.com> <alpine.DEB.2.00.1207240931560.29808@router.home>
In-Reply-To: <alpine.DEB.2.00.1207240931560.29808@router.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2012 10:45 PM, Christoph Lameter wrote:
> On Tue, 24 Jul 2012, Jiang Liu wrote:
> 
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index 8c691fa..3976745 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2803,6 +2803,17 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
>>
>>  static struct kmem_cache *kmem_cache_node;
>>
>> +static bool node_has_normal_memory(int node)
>> +{
>> +	int i;
>> +
>> +	for (i = ZONE_NORMAL; i >= 0; i--)
>> +		if (populated_zone(&NODE_DATA(node)->node_zones[i]))
>> +			return true;
>> +
>> +	return false;
>> +}
> 
> There is already a N_NORMAL_MEMORY node map that contains a list of node
> that have *normal* memory usable by slab allocators etc. I think the
> cleanest solution would be to clear the corresponding node bits for your
> special movable only zones. Then you wont be needing to modify other
> subsystems anymore.
> 
Hi Chris,
	Thanks for your comments! I have thought about the solution mentioned,
but seems it doesn't work. We have node masks for both N_NORMAL_MEMORY and
N_HIGH_MEMORY to distinguish between normal and highmem on platforms such as x86.
But we still don't have such a mechanism to distinguish between "normal" and "movable"
memory. So for memory nodes with only movable zones, we still set N_NORMAL_MEMORY for
them. One possible solution is to add a node mask for "N_NORMAL_OR_MOVABLE_MEMORY",
but haven't tried that yet. Will have a try for that.
	Thanks!
	Gerry
