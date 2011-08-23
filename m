Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1HWJ7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 05:59:15 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:8163 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab1HWJ7N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 05:59:13 -0400
Message-ID: <4E5379DA.8060109@openvz.org>
Date: Tue, 23 Aug 2011 13:58:50 +0400
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110702 Iceape/2.0.14
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 08/13] list: add a new LRU list type
References: <1314089786-20535-1-git-send-email-david@fromorbit.com> <1314089786-20535-9-git-send-email-david@fromorbit.com> <20110823092056.GE21492@infradead.org> <20110823093205.GZ3162@dastard>
In-Reply-To: <20110823093205.GZ3162@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner wrote:
> On Tue, Aug 23, 2011 at 05:20:56AM -0400, Christoph Hellwig wrote:
>> On Tue, Aug 23, 2011 at 06:56:21PM +1000, Dave Chinner wrote:
>>> From: Dave Chinner<dchinner@redhat.com>
>>>
>>> Several subsystems use the same construct for LRU lists - a list
>>> head, a spin lock and and item count. They also use exactly the same
>>> code for adding and removing items from the LRU. Create a generic
>>> type for these LRU lists.
>>>
>>> This is the beginning of generic, node aware LRUs for shrinkers to
>>> work with.
>>
>> Why list_lru vs the more natural sounding lru_list?
>
> because the mmzone.h claimed that namespace:
>
> enum lru_list {
>          LRU_INACTIVE_ANON = LRU_BASE,
>          LRU_ACTIVE_ANON = LRU_BASE + LRU_ACTIVE,
>          LRU_INACTIVE_FILE = LRU_BASE + LRU_FILE,
>          LRU_ACTIVE_FILE = LRU_BASE + LRU_FILE + LRU_ACTIVE,
>          LRU_UNEVICTABLE,
>          NR_LRU_LISTS
> };
>
> and it is widely spewed through the mm code. I didn't really feel
> like having to clean that mess up first....

not so widely:

$ git grep -wc 'enum lru_list'
include/linux/memcontrol.h:5
include/linux/mm_inline.h:7
include/linux/mmzone.h:4
include/linux/pagevec.h:1
include/linux/swap.h:2
mm/memcontrol.c:10
mm/page_alloc.c:1
mm/swap.c:6
mm/vmscan.c:6

maybe is better to rename it to enum page_lru_list
