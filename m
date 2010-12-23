Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab0LWNwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 08:52:08 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46453 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752323Ab0LWNwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 08:52:06 -0500
Date: Thu, 23 Dec 2010 13:51:20 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Kyungmin Park <kmpark@infradead.org>, linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Ankita Garg <ankita@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv8 00/12] Contiguous Memory Allocator
Message-ID: <20101223135120.GL3636@n2100.arm.linux.org.uk>
References: <cover.1292443200.git.m.nazarewicz@samsung.com> <AANLkTim8_=0+-zM5z4j0gBaw3PF3zgpXQNetEn-CfUGb@mail.gmail.com> <20101223100642.GD3636@n2100.arm.linux.org.uk> <87k4j0ehdl.fsf@erwin.mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k4j0ehdl.fsf@erwin.mina86.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 23, 2010 at 02:41:26PM +0100, Michal Nazarewicz wrote:
> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
> > Has anyone addressed my issue with it that this is wide-open for
> > abuse by allocating large chunks of memory, and then remapping
> > them in some way with different attributes, thereby violating the
> > ARM architecture specification?
> >
> > In other words, do we _actually_ have a use for this which doesn't
> > involve doing something like allocating 32MB of memory from it,
> > remapping it so that it's DMA coherent, and then performing DMA
> > on the resulting buffer?
> 
> Huge pages.
> 
> Also, don't treat it as coherent memory and just flush/clear/invalidate
> cache before and after each DMA transaction.  I never understood what's
> wrong with that approach.

If you've ever used an ARM system with a VIVT cache, you'll know what's
wrong with this approach.

ARM systems with VIVT caches have extremely poor task switching
performance because they flush the entire data cache at every task switch
- to the extent that it makes system performance drop dramatically when
they become loaded.

Doing that for every DMA operation will kill the advantage we've gained
from having VIPT caches and ASIDs stone dead.
