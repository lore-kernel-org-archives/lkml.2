Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab1HNHwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 03:52:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:38093 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188Ab1HNHwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 03:52:31 -0400
Date: Sun, 14 Aug 2011 08:52:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, linaro-mm-sig@lists.linaro.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>
Subject: Re: [PATCH 7/9] ARM: DMA: steal memory for DMA coherent mappings
Message-ID: <20110814075205.GA4986@n2100.arm.linux.org.uk>
References: <1313146711-1767-1-git-send-email-m.szyprowski@samsung.com> <1313146711-1767-8-git-send-email-m.szyprowski@samsung.com> <201108121453.05898.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201108121453.05898.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 02:53:05PM +0200, Arnd Bergmann wrote:
> On Friday 12 August 2011, Marek Szyprowski wrote:
> > 
> > From: Russell King <rmk+kernel@arm.linux.org.uk>
> > 
> > Steal memory from the kernel to provide coherent DMA memory to drivers.
> > This avoids the problem with multiple mappings with differing attributes
> > on later CPUs.
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > [m.szyprowski: rebased onto 3.1-rc1]
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> 
> Hi Marek,
> 
> Is this the same patch that Russell had to revert because it didn't
> work on some of the older machines, in particular those using
> dmabounce?
> 
> I thought that our discussion ended with the plan to use this only
> for ARMv6+ (which has a problem with double mapping) but not on ARMv5
> and below (which don't have this problem but might need dmabounce).

I thought we'd decided to have a pool of available CMA memory on ARMv6K
to satisfy atomic allocations, which can grow and shrink in size, rather
than setting aside a fixed amount of contiguous system memory.

ARMv6 and ARMv7+ could use CMA directly, and <= ARMv5 can use the existing
allocation method.

Has something changed?
