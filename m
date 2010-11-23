Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab0KWPoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 10:44:18 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:10556 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab0KWPoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 10:44:17 -0500
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Tue, 23 Nov 2010 16:44:11 +0100
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 0/4] big chunk memory allocator v4
In-reply-to: <F4DF93C7785E2549970341072BC32CD796018FCB@irsmsx503.ger.corp.intel.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Kleen, Andi" <andi.kleen@intel.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>,
        Bob Liu <lliubbo@gmail.com>,
        "fujita.tomonori@lab.ntt.co.jp" <fujita.tomonori@lab.ntt.co.jp>,
        "pawel@osciak.com" <pawel@osciak.com>,
        "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>
Message-id: <op.vmmrbxp57p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.63 (Linux)
References: <20101119171033.a8d9dc8f.kamezawa.hiroyu@jp.fujitsu.com>
 <20101119125653.16dd5452.akpm@linux-foundation.org>
 <F4DF93C7785E2549970341072BC32CD796018FCB@irsmsx503.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 09:59:57 +0100, Kleen, Andi <andi.kleen@intel.com> wrote:

>> >   But yes, because of fragmentation, this cannot guarantee 100%
>> alloc.
>> >   If alloc_contig_pages() is called in system boot up or movable_zone
>> is used,
>> >   this allocation succeeds at high rate.
>>
>> So this is an alternatve implementation for the functionality offered
>> by Michal's "The Contiguous Memory Allocator framework".
>
> I see them more as orthogonal: Michal's code relies on preallocation
> and manages the memory after that.

Yes and no.  The v6 version adds not-yet-finished support for sharing
the preallocated blocks with page allocator (so if CMA is not using the
memory, page allocator can allocate it, and when CMA finally wants to
use it the allocated pages are migrated).

In the v6 implementation I have added a new migration type (I cannot seem
to find who proposed such approach first).  When I'll end debugging the
code I'll try to work things out without adding additional entity (that
is new migration type).

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
