Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1HPN3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 09:29:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60083 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1HPN3b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 09:29:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH 7/9] ARM: DMA: steal memory for DMA coherent mappings
Date: Tue, 16 Aug 2011 15:28:48 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
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
References: <1313146711-1767-1-git-send-email-m.szyprowski@samsung.com> <201108121453.05898.arnd@arndb.de> <20110814075205.GA4986@n2100.arm.linux.org.uk>
In-Reply-To: <20110814075205.GA4986@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108161528.48954.arnd@arndb.de>
X-Provags-ID: V02:K0:1/SgKmQbPrQ5DLWinBy1yBbzVBPKFeWRy8//T+Tr4N6
 eFDQ3xuY0677b51XCq3eVKcJz9u23MAY/OAZQch6CFha6hgtL0
 cc42gr9LpwT1OnxnCMGa2fxOy7ZBwOZSOFSNHNBmNwjWakA2Op
 NoKLEzr72k0uLkNkXR+sSSq9tTrXadB1y46G8T1uvGEnTy3ZDS
 SyUhY0dAGXQXbaEu3WOCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 August 2011, Russell King - ARM Linux wrote:
> On Fri, Aug 12, 2011 at 02:53:05PM +0200, Arnd Bergmann wrote:
> > 
> > I thought that our discussion ended with the plan to use this only
> > for ARMv6+ (which has a problem with double mapping) but not on ARMv5
> > and below (which don't have this problem but might need dmabounce).
> 
> I thought we'd decided to have a pool of available CMA memory on ARMv6K
> to satisfy atomic allocations, which can grow and shrink in size, rather
> than setting aside a fixed amount of contiguous system memory.

Hmm, I don't remember the point about dynamically sizing the pool for
ARMv6K, but that can well be an oversight on my part.  I do remember the
part about taking that memory pool from the CMA region as you say.

> ARMv6 and ARMv7+ could use CMA directly, and <= ARMv5 can use the existing
> allocation method.
> 
> Has something changed?

Nothing has changed regarding <=ARMv5. There was a small side discussion
about ARMv6 and ARMv7+ based on the idea that they can either use CMA
directly (doing TLB flushes for every allocation) or they could use the
same method as ARMv6K by setting aside a pool of pages for atomic
allocation. The first approach would consume less memory because it
requires no special pool, the second approach would be simpler because
it unifies the ARMv6K and ARMv6/ARMv7+ cases and also would be slightly
more efficient for atomic allocations because it avoids the expensive
TLB flush.

I didn't have a strong opinion either way, so IIRC Marek said he'd try
out both approaches and then send out the one that looked better, leaning
towards the second for simplicity of having fewer compile-time options.

	Arnd
