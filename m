Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0HZCzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 22:55:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59666 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0HZCz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 22:55:29 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 26 Aug 2010 11:50:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: =?UTF-8?B?TWljaGHFgg==?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Corbet <corbet@lwn.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Pawel Osciak <p.osciak@samsung.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mel Gorman <mel@csn.ul.ie>, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
Message-Id: <20100826115017.04f6f707.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <op.vh0wektv7p4s8u@localhost>
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
	<1282310110.2605.976.camel@laptop>
	<20100825155814.25c783c7.akpm@linux-foundation.org>
	<20100826095857.5b821d7f.kamezawa.hiroyu@jp.fujitsu.com>
	<op.vh0wektv7p4s8u@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010 04:12:10 +0200
Michał Nazarewicz <m.nazarewicz@samsung.com> wrote:

> On Thu, 26 Aug 2010 02:58:57 +0200, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Hmm, you may not like this..but how about following kind of interface ?
> >
> > Now, memoyr hotplug supports following operation to free and _isolate_
> > memory region.
> > 	# echo offline > /sys/devices/system/memory/memoryX/state
> >
> > Then, a region of memory will be isolated. (This succeeds if there are free
> > memory.)
> >
> > Add a new interface.
> >
> > 	% echo offline > /sys/devices/system/memory/memoryX/state
> > 	# extract memory from System RAM and make them invisible from buddy allocator.
> >
> > 	% echo cma > /sys/devices/system/memory/memoryX/state
> > 	# move invisible memory to cma.
> 
> At this point I need to say that I have no experience with hotplug memory but
> I think that for this to make sense the regions of memory would have to be
> smaller.  Unless I'm misunderstanding something, the above would convert
> a region of sizes in order of GiBs to use for CMA.
> 

Now, x86's section size is 
==
#ifdef CONFIG_X86_32
# ifdef CONFIG_X86_PAE
#  define SECTION_SIZE_BITS     29
#  define MAX_PHYSADDR_BITS     36
#  define MAX_PHYSMEM_BITS      36
# else
#  define SECTION_SIZE_BITS     26
#  define MAX_PHYSADDR_BITS     32
#  define MAX_PHYSMEM_BITS      32
# endif
#else /* CONFIG_X86_32 */
# define SECTION_SIZE_BITS      27 /* matt - 128 is convenient right now */
# define MAX_PHYSADDR_BITS      44
# define MAX_PHYSMEM_BITS       46
#endif
==

128MB...too big ? But it's depend on config.

IBM's ppc guys used 16MB section, and recently, a new interface to shrink
the number of /sys files are added, maybe usable.

Something good with this approach will be you can create "cma" memory
before installing driver.

But yes, complicated and need some works.

Bye,
-Kame

