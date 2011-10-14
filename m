Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1JNXT5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 19:19:57 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38114 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab1JNXTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 19:19:55 -0400
Date: Fri, 14 Oct 2011 16:19:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Paul McKenney <paul.mckenney@linaro.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shariq Hasnain <shariq.hasnain@linaro.org>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <jweiner@redhat.com>
Subject: Re: [PATCHv16 0/9] Contiguous Memory Allocator
Message-Id: <20111014161951.5b4bb327.akpm@linux-foundation.org>
In-Reply-To: <201110111552.04615.arnd@arndb.de>
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
	<201110071827.06366.arnd@arndb.de>
	<20111010155642.38df59af.akpm@linux-foundation.org>
	<201110111552.04615.arnd@arndb.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Oct 2011 15:52:04 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Tuesday 11 October 2011, Andrew Morton wrote:
> > Russell's going to hate me, but...
> > 
> > I do know that he had substantial objections to at least earlier
> > versions of this, and he is a guy who knows of what he speaks.
> > 
> > So I would want to get a nod from rmk on this work before proceeding. 
> > If that nod isn't available then let's please identify the issues and
> > see what we can do about them.
> 
> I'm pretty sure that Russell's concerns were almost entirely about the
> ARM specific parts, which were extremely hard to figure out. The
> most important technical concern back in July was that the patch
> series at the time did not address the problem of conflicting pte
> flags when we remap memory as uncached on ARMv6. He had a patch
> to address this problem that was supposed to get merged in 3.1
> and would have conflicted with the CMA patch set.
> 
> Things have changed a lot since then. Russell had to revert his
> own patch because he found regressions using it on older machines.
> However, the current CMA on ARM patch AFAICT reliably fixes this
> problem now and does not cause the same regression on older machines.
> The solution used now is the one we agreed on after sitting together
> for a few hours with Russell, Marek, Paul McKenney and myself.
> 
> If there are still concerns over the ARM specific portion of
> the patch series, I'm very confident that we can resolve these
> now (I was much less so before that meeting).
> 
> What I would really want to hear from you is your opinion on
> the architecture independent stuff. Obviously, ARM is the
> most important consumer of the patch set, but I think the
> code has its merit on other architectures as well and most of
> them (maybe not parisc) should be about as simple as the x86
> one that Marek posted now with v16.

Having an x86 implementation is good.  It would also be good to get
some x86 drivers using CMA asap, so the thing gets some runtime testing
from the masses.  Can we think of anything we can do here?

Regarding the core MM changes: Mel's the man for migration and
compaction.  I wouldn't want to proceed until he (and perferably
Johannes) have spent some quality time with the code.  I'm not seeing
their reviewed-by's of acked-by's and I don't have a good recollection
of their involvement?

