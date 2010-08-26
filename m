Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab0HZEDE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 00:03:04 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:56822 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab0HZEDC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 00:03:02 -0400
Date: Thu, 26 Aug 2010 06:01:56 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
In-reply-to: <20100826124434.6089630d.kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawel Osciak <p.osciak@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        Hans Verkuil <hverkuil@xs4all.nl>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Message-id: <op.vh01hi2m7p4s8u@localhost>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.61 (Linux)
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
 <1282310110.2605.976.camel@laptop>
 <20100825155814.25c783c7.akpm@linux-foundation.org>
 <20100826095857.5b821d7f.kamezawa.hiroyu@jp.fujitsu.com>
 <op.vh0wektv7p4s8u@localhost>
 <20100826115017.04f6f707.kamezawa.hiroyu@jp.fujitsu.com>
 <20100826124434.6089630d.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 128MB...too big ? But it's depend on config.

On embedded systems it may be like half of the RAM.  Or a quarter.  So bigger
granularity could be desired on some platforms.

> IBM's ppc guys used 16MB section, and recently, a new interface to shrink
> the number of /sys files are added, maybe usable.
>
> Something good with this approach will be you can create "cma" memory
> before installing driver.

That's how CMA works at the moment.  But if I understand you correctly, what
you are proposing would allow to reserve memory *at* *runtime* long after system
has booted.  This would be a nice feature as well though.

> But yes, complicated and need some works.

> Ah, I need to clarify what I want to say.
>
> With compaction, it's helpful, but you can't get contiguous memory larger
> than MAX_ORDER, I think. To get memory larger than MAX_ORDER on demand,
> memory hot-plug code has almost all necessary things.

I'll try to look at it then.

> BTW, just curious...the memory for cma need not to be saved at
> hibernation ? Or drivers has to write its own hibernation ops by driver suspend
> udev or some ?

Hibernation was not considered as of yet but I think it's device driver's
responsibility more then CMA's especially since it may make little sense to save
some of the buffers -- ie. no need to keep a frame from camera since it'll be
overwritten just after system wakes up from hibernation.  It may also be better
to stop playback and resume it later on rather than trying to save decoder's
state.  Again though, I haven't thought about hibernation as of yet.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--

