Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259Ab1GELeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 07:34:08 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46615 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932176Ab1GELeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 07:34:06 -0400
Date: Tue, 5 Jul 2011 12:33:45 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Daniel Walker <dwalker@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        Mel Gorman <mel@csn.ul.ie>, Chunsang Jeong <chunsang.jeong@linaro.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Jesse Barker <jesse.barker@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 6/8] drivers: add Contiguous Memory Allocator
Message-ID: <20110705113345.GA8286@n2100.arm.linux.org.uk>
References: <1309851710-3828-1-git-send-email-m.szyprowski@samsung.com> <1309851710-3828-7-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309851710-3828-7-git-send-email-m.szyprowski@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 05, 2011 at 09:41:48AM +0200, Marek Szyprowski wrote:
> The Contiguous Memory Allocator is a set of helper functions for DMA
> mapping framework that improves allocations of contiguous memory chunks.
> 
> CMA grabs memory on system boot, marks it with CMA_MIGRATE_TYPE and
> gives back to the system. Kernel is allowed to allocate movable pages
> within CMA's managed memory so that it can be used for example for page
> cache when DMA mapping do not use it. On dma_alloc_from_contiguous()
> request such pages are migrated out of CMA area to free required
> contiguous block and fulfill the request. This allows to allocate large
> contiguous chunks of memory at any time assuming that there is enough
> free memory available in the system.
> 
> This code is heavily based on earlier works by Michal Nazarewicz.

And how are you addressing the technical concerns about aliasing of
cache attributes which I keep bringing up with this and you keep
ignoring and telling me that I'm standing in your way.
