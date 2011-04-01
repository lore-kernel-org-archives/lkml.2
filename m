Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722Ab1DAXLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 19:11:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59581 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab1DAXLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 19:11:21 -0400
Message-ID: <4D965B7B.9070208@redhat.com>
Date: Fri, 01 Apr 2011 19:10:51 -0400
From: Satoru Moriya <smoriya@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Christoph Lameter <cl@linux.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 0/3] Unmapped page cache control (v5)
References: <20110331144145.0ECA.A69D9226@jp.fujitsu.com> <alpine.DEB.2.00.1103311451530.28364@router.home> <20110401221921.A890.A69D9226@jp.fujitsu.com>
In-Reply-To: <20110401221921.A890.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 09:17 AM, KOSAKI Motohiro wrote:
> Hi Christoph,
> 
> Thanks, long explanation.
> 
> 
>> On Thu, 31 Mar 2011, KOSAKI Motohiro wrote:
>>
>>> 1) zone reclaim doesn't work if the system has multiple node and the
>>>    workload is file cache oriented (eg file server, web server, mail server, et al).
>>>    because zone recliam make some much free pages than zone->pages_min and
>>>    then new page cache request consume nearest node memory and then it
>>>    bring next zone reclaim. Then, memory utilization is reduced and
>>>    unnecessary LRU discard is increased dramatically.
>>
>> That is only true if the webserver only allocates from a single node. If
>> the allocation load is balanced then it will be fine. It is useful to
>> reclaim pages from the node where we allocate memory since that keeps the
>> dataset node local.
> 
> Why?
> Scheduler load balancing only consider cpu load. Then, usually memory
> pressure is no complete symmetric. That's the reason why we got the
> bug report periodically.

Agreed. As Christoph said if the allocation load is balanced it will be fine.
But I think it's not always true that the allocation load is balanced.

>>> But, I agree that now we have to concern slightly large VM change parhaps
>>> (or parhaps not). Ok, it's good opportunity to fill out some thing.
>>> Historically, Linux MM has "free memory are waste memory" policy, and It
>>> worked completely fine. But now we have a few exceptions.
>>>
>>> 1) RT, embedded and finance systems. They really hope to avoid reclaim
>>>    latency (ie avoid foreground reclaim completely) and they can accept
>>>    to make slightly much free pages before memory shortage.
>>
>> In general we need a mechanism to ensure we can avoid reclaim during
>> critical sections of application. So some way to give some hints to the
>> machine to free up lots of memory (/proc/sys/vm/dropcaches is far too
>> drastic) may be useful.
> 
> Exactly.
> I've heard multiple times this request from finance people. And I've also 
> heared the same request from bullet train control software people recently.

I completely agree with you. I have both customers and they really need it
to make their critical section deterministic.

Thanks,
Satoru
