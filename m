Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162Ab0HZITY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 04:19:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44983 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab0HZITW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 04:19:22 -0400
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
From: Peter Zijlstra <peterz@infradead.org>
To: =?UTF-8?Q?Micha=C5=82?= Nazarewicz <m.nazarewicz@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Daniel Walker <dwalker@codeaurora.org>,
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
In-Reply-To: <op.vh0xp8ix7p4s8u@localhost>
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
	 <1282310110.2605.976.camel@laptop>
	 <20100825155814.25c783c7.akpm@linux-foundation.org>
	 <op.vh0xp8ix7p4s8u@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Aug 2010 10:18:57 +0200
Message-ID: <1282810737.1975.240.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 04:40 +0200, Michał Nazarewicz wrote:
> I think that the biggest problem is fragmentation here.  For instance,
> I think that a situation where there is enough free space but it's
> fragmented so no single contiguous chunk can be allocated is a serious
> problem.  However, I would argue that if there's simply no space left,
> a multimedia device could fail and even though it's not desirable, it
> would not be such a big issue in my eyes.
> 
> So, if only movable or discardable pages are allocated in CMA managed
> regions all should work well.  When a device needs memory discardable
> pages would get freed and movable moved unless there is no space left
> on the device in which case allocation would fail. 

If you'd actually looked at the page allocator you'd see its capable of
doing exactly that!

I has the notion of movable pages, it can defragment free space (called
compaction).

Use it!
