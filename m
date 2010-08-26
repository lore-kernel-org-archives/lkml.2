Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0HZCll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 22:41:41 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42024 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0HZClh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 22:41:37 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Thu, 26 Aug 2010 04:40:46 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
In-reply-to: <20100825155814.25c783c7.akpm@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Pawel Osciak <p.osciak@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <op.vh0xp8ix7p4s8u@localhost>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
 <1282310110.2605.976.camel@laptop>
 <20100825155814.25c783c7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

I think Pawel has replied to most of your comments, so I'll just add my own
0.02 KRW. ;)

> Peter Zijlstra <peterz@infradead.org> wrote:
>> So the idea is to grab a large chunk of memory at boot time and then
>> later allow some device to use it?
>>
>> I'd much rather we'd improve the regular page allocator to be smarter
>> about this. We recently added a lot of smarts to it like memory
>> compaction, which allows large gobs of contiguous memory to be freed for
>> things like huge pages.
>>
>> If you want guarantees you can free stuff, why not add constraints to
>> the page allocation type and only allow MIGRATE_MOVABLE pages inside a
>> certain region, those pages are easily freed/moved aside to satisfy
>> large contiguous allocations.

On Thu, 26 Aug 2010 00:58:14 +0200, Andrew Morton <akpm@linux-foundation.org> wrote:
> That would be good.  Although I expect that the allocation would need
> to be 100% rock-solid reliable, otherwise the end user has a
> non-functioning device.  Could generic core VM provide the required level
> of service?

I think that the biggest problem is fragmentation here.  For instance,
I think that a situation where there is enough free space but it's
fragmented so no single contiguous chunk can be allocated is a serious
problem.  However, I would argue that if there's simply no space left,
a multimedia device could fail and even though it's not desirable, it
would not be such a big issue in my eyes.

So, if only movable or discardable pages are allocated in CMA managed
regions all should work well.  When a device needs memory discardable
pages would get freed and movable moved unless there is no space left
on the device in which case allocation would fail.

Critical devices (just a hypothetical entities) could have separate
regions on which only discardable pages can be allocated so that memory
can always be allocated for them.

> I agree that having two "contiguous memory allocators" floating about
> on the list is distressing.  Are we really all 100% diligently certain
> that there is no commonality here with Zach's work?

As Pawel said, I think Zach's trying to solve a different problem.  No
matter, as I've said in response to Konrad's message, I have thought
about unifying Zach's IOMMU and CMA in such a way that devices could
work on both systems with and without IOMMU if only they would limit
the usage of the API to some subset which always works.

> Please cc me on future emails on this topic?

Not a problem.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

