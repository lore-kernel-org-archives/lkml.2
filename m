Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab0ERK6q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 06:58:46 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:53070 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab0ERK6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 06:58:44 -0400
Date: Tue, 18 May 2010 19:57:48 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org, magnus.damm@gmail.com,
       Russell King - ARM Linux <linux@arm.linux.org.uk>
Subject: Re: [GIT PULL] sh updates for 2.6.35-rc1
Message-ID: <20100518105748.GA3731@linux-sh.org>
References: <20100518092532.GA3050@linux-sh.org> <AANLkTim6t8oG-vdLKE918Sd2TFKJpSf5Bw2PTtSsD_Fh@mail.gmail.com> <20100518101500.GA3156@linux-sh.org> <AANLkTinIVjwrQ9gza2FIvZN5w4nm8ZjSUe836oRmWYG7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinIVjwrQ9gza2FIvZN5w4nm8ZjSUe836oRmWYG7@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 18, 2010 at 04:21:37PM +0530, Jaswinder Singh Rajput wrote:
> On Tue, May 18, 2010 at 3:45 PM, Paul Mundt <lethal@linux-sh.org> wrote:
> Hmm, so still it is between ARM and SH, so better option will be :
> 
Those were examples, we already have cases where blocks are shared across
more architectures than that.

> include/linux/sh_clk.h -> include/sh/clk.h
> include/linux/sh_dma.h -> include/sh/dma.h
> include/linux/sh_intc.h -> include/sh/intc.h
> 
> So when arm files will come then, then we can make it like this :
> 
The ARM use case is already there, today.

> include/arm/clk.h
> include/arm/dma.h
> include/arm/intc.h
> 
Did you even bother looking at the files and how they are used? We are
not going to duplicate identical files for each architecture.

> There are no doubts in future we will have asymmetrical processing,
> where we will use multiple architectures, so better make different
> directory for them instead of putting load on include/linux which
> already over-loaded.
> 
You seem to be ignoring the fact that we've had these use cases for years
already and that the current scheme has so far served us pretty well in
that regard. If we have headers for drivers that are used across multiple
architectures, then include/linux is ultimately the proper place for
them. We could shoe-horn them in to some sort of pseudo-architecture
thing in include/ but for what purpose?

Until you've actually read through the background mail on this and
actually looked at the code in question I see very little point in
continuing this thread. I'm of course open to suggestions on how to make
this sort of abstraction cleaner, but so far none of your suggestions are
relevant to the problem at hand.
