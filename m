Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab0HZKGf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 06:06:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50171 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab0HZKGe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 06:06:34 -0400
Subject: Re: [PATCH/RFCv4 0/6] The Contiguous Memory Allocator framework
From: Peter Zijlstra <peterz@infradead.org>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Nazarewicz <m.nazarewicz@samsung.com>, linux-mm@kvack.org,
        Daniel Walker <dwalker@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <AANLkTin7EBZw0-WY=NGOmYzZT5Cfy7oWVFBaT2cjK+vZ@mail.gmail.com>
References: <cover.1282286941.git.m.nazarewicz@samsung.com>
	 <1282310110.2605.976.camel@laptop>
	 <20100825155814.25c783c7.akpm@linux-foundation.org>
	 <20100825173125.0855a6b0@bike.lwn.net>
	 <AANLkTinPaq+0MbdW81uoc5_OZ=1Gy_mVYEBnwv8zgOBd@mail.gmail.com>
	 <1282810811.1975.246.camel@laptop>
	 <AANLkTin7EBZw0-WY=NGOmYzZT5Cfy7oWVFBaT2cjK+vZ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Aug 2010 12:06:00 +0200
Message-ID: <1282817160.1975.476.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-26 at 18:29 +0900, Minchan Kim wrote:
> As I said following mail, I said about free space problem.
> Of course, compaction could move anon pages into somewhere.
> What's is somewhere? At last, it's same zone.
> It can prevent fragment problem but not size of free space.
> So I mean it would be better to move it into another zone(ex, HIGHMEM)
> rather than OOM kill. 

Real machines don't have highmem, highmem sucks!! /me runs

Does cross zone movement really matter, I though these crappy devices
were mostly used on crappy hardware with very limited memory, so pretty
much everything would be in zone_normal.. no?

But sure, if there's really a need we can look at maybe doing cross zone
movement.
