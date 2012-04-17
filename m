Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab2DQSSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:18:12 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:33156 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2DQSSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:18:10 -0400
Message-ID: <4F8DB3DC.7000602@gmail.com>
Date: Tue, 17 Apr 2012 14:18:04 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Johannes Weiner <hannes@cmpxchg.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>, Subash Patel <subashrp@gmail.com>,
        kosaki.motohiro@gmail.com
Subject: Re: [PATCH 4/4] ARM: remove consistent dma region and use common
 vmalloc range for dma allocations
References: <1334325950-7881-1-git-send-email-m.szyprowski@samsung.com> <1334325950-7881-5-git-send-email-m.szyprowski@samsung.com> <20120413183813.GO24211@n2100.arm.linux.org.uk> <4F8B76B9.1060505@kernel.org>
In-Reply-To: <4F8B76B9.1060505@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(4/15/12 9:32 PM), Minchan Kim wrote:
> On 04/14/2012 03:38 AM, Russell King - ARM Linux wrote:
>> On Fri, Apr 13, 2012 at 04:05:50PM +0200, Marek Szyprowski wrote:
>>> This patch changes dma-mapping subsystem to use generic vmalloc areas
>>> for all consistent dma allocations. This increases the total size limit
>>> of the consistent allocations and removes platform hacks and a lot of
>>> duplicated code.
>>
>> NAK. I don't think you appreciate the contexts from which the dma coherent
>> code can be called from, and the reason why we pre-allocate the page
>> tables (so that IRQ-based allocations work.)
>>
>> The vmalloc region doesn't allow that because page tables are allocated
>> using GFP_KERNEL not GFP_ATOMIC.
>>
>> Sorry.
>>
>
> Off-topic.
>
> I don't know why vmalloc functions have gfp_t argument.
> As Russel pointed out, we allocates page tables with GFP_KERNEL regardless of gfp_t passed.
> It means gfp_t passed is useless.
> I see there are many cases calling __vmalloc with GFP_NOFS, even GFP_ATOMIC. Then, it could end up deadlocking in reclaim context or schedule bug.
> I'm not sure why we can't see such bugs until now.
> If I didn't miss something, Shouldn't we fix it?

I believe it should be fixed. of course. :)


