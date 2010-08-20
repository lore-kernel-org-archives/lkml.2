Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab0HTNQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 09:16:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:37308 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab0HTNQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 09:16:34 -0400
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
From: Peter Zijlstra <peterz@infradead.org>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-mm@kvack.org, Daniel Walker <dwalker@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jonathan Corbet <corbet@lwn.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <cover.1282286941.git.m.nazarewicz@samsung.com>
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 20 Aug 2010 15:15:10 +0200
Message-ID: <1282310110.2605.976.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 11:50 +0200, Michal Nazarewicz wrote:
> Hello everyone,
> 
> The following patchset implements a Contiguous Memory Allocator.  For
> those who have not yet stumbled across CMA an excerpt from
> documentation:
> 
>    The Contiguous Memory Allocator (CMA) is a framework, which allows
>    setting up a machine-specific configuration for physically-contiguous
>    memory management. Memory for devices is then allocated according
>    to that configuration.
> 
>    The main role of the framework is not to allocate memory, but to
>    parse and manage memory configurations, as well as to act as an
>    in-between between device drivers and pluggable allocators. It is
>    thus not tied to any memory allocation method or strategy.
> 
> For more information please refer to the second patch from the
> patchset which contains the documentation.

So the idea is to grab a large chunk of memory at boot time and then
later allow some device to use it?

I'd much rather we'd improve the regular page allocator to be smarter
about this. We recently added a lot of smarts to it like memory
compaction, which allows large gobs of contiguous memory to be freed for
things like huge pages.

If you want guarantees you can free stuff, why not add constraints to
the page allocation type and only allow MIGRATE_MOVABLE pages inside a
certain region, those pages are easily freed/moved aside to satisfy
large contiguous allocations.

Also, please remove --chain-reply-to from your git config. You're using
1.7 which should do the right thing (--no-chain-reply-to) by default.


