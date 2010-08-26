Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0HZB3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 21:29:17 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:48889 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab0HZB3O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 21:29:14 -0400
Date: Thu, 26 Aug 2010 03:28:41 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
In-reply-to: <1282310110.2605.976.camel@laptop>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>, Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Mel Gorman <mel@csn.ul.ie>, Pawel Osciak <p.osciak@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-media@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <op.vh0ud3rg7p4s8u@localhost>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
 <1282310110.2605.976.camel@laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Aug 2010 15:15:10 +0200, Peter Zijlstra <peterz@infradead.org> wrote:
> So the idea is to grab a large chunk of memory at boot time and then
> later allow some device to use it?
>
> I'd much rather we'd improve the regular page allocator to be smarter
> about this. We recently added a lot of smarts to it like memory
> compaction, which allows large gobs of contiguous memory to be freed for
> things like huge pages.
>
> If you want guarantees you can free stuff, why not add constraints to
> the page allocation type and only allow MIGRATE_MOVABLE pages inside a
> certain region, those pages are easily freed/moved aside to satisfy
> large contiguous allocations.

I'm aware that grabbing a large chunk at boot time is a bit of waste of
space and because of it I'm hoping to came up with a way of reusing the
space when it's not used by CMA-aware devices.  My current idea was to
use it for easily discardable data (page cache?).

> Also, please remove --chain-reply-to from your git config. You're using
> 1.7 which should do the right thing (--no-chain-reply-to) by default.

OK.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

