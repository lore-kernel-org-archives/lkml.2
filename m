Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab0GVJfb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 05:35:31 -0400
Received: from sh.osrg.net ([192.16.179.4]:37273 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668Ab0GVJf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 05:35:29 -0400
Date: Thu, 22 Jul 2010 18:35:07 +0900
To: m.szyprowski@samsung.com
Cc: fujita.tomonori@lab.ntt.co.jp, corbet@lwn.net, m.nazarewicz@samsung.com,
        linux-mm@kvack.org, p.osciak@samsung.com, xiaolin.zhang@intel.com,
        hvaibhav@ti.com, robert.fekete@stericsson.com,
        marcus.xm.lorentzon@stericsson.com, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com
Subject: RE: [PATCH 2/4] mm: cma: Contiguous Memory Allocator added
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <000001cb296f$6eba8fa0$4c2faee0$%szyprowski@samsung.com>
References: <20100720181239.5a1fd090@bike.lwn.net>
	<20100722143652V.fujita.tomonori@lab.ntt.co.jp>
	<000001cb296f$6eba8fa0$4c2faee0$%szyprowski@samsung.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100722183432U.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 22 Jul 2010 18:35:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 09:28:02 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> > About the framework, it looks too complicated than we actually need
> > (the command line stuff looks insane).
> 
> Well, this command line stuff was designed to provide a way to configure
> memory allocation for devices with very sophisticated memory requirements.

You have the feature in the wrong place.

Your example: a camera driver and a video driver can share 20MB, then
they want 20MB exclusively.

You can reserve 20MB and make them share it. Then you can reserve 20MB
for both exclusively.

You know how the whole system works. Adjust drivers (probably, with
module parameters).


> > Why can't we have something simpler, like using memblock to reserve
> > contiguous memory at boot and using kinda mempool to share such memory
> > between devices?
> 
> There are a few problems with such simple approach:
> 
> 1. It does not provide all required functionality for our multimedia
> devices. The main problem is the fact that our multimedia devices
> require particular kind of buffers to be allocated in particular memory
> bank. Then add 2 more requirements: a proper alignment (for some of them
> it is even 128Kb) and particular range of addresses requirement (some
> buffers must be allocated at higher addresses than the firmware).
> This is very hard to achieve with such simple allocator.

When a video driver needs 20MB to work properly, what's the point of
releasing the 20MB for others then trying to get it again later?

Even with the above example (two devices never use the memory at the
same time), the driver needs memory regularly. What's the point of
split the 20MB to small chunks and allocate them to others?
