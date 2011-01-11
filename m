Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755918Ab1AKMU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 07:20:26 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:50841 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800Ab1AKMUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 07:20:23 -0500
Date: Tue, 11 Jan 2011 21:18:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>
Subject: Re: Locking in the clk API
Message-ID: <20110111121816.GB774@linux-sh.org>
References: <201101111016.42819.jeremy.kerr@canonical.com> <201101111744.59712.jeremy.kerr@canonical.com> <20110111101314.GA774@linux-sh.org> <201101111830.18597.jeremy.kerr@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101111830.18597.jeremy.kerr@canonical.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 06:30:18PM +0800, Jeremy Kerr wrote:
> Hi Paul,
> 
> > No, the sleeping clock case is and always will be a corner case, and I
> > have no interest in pretending otherwise. On SH we have hundreds of
> > clocks that are all usable in the atomic context and perhaps less than a
> > dozen that aren't (and even in those cases much of the PLL negotiation is
> > handled in hardware so there's never any visibility for the lock-down
> > from the software side, other architectures also have similar behaviour).
> 
> I'm not too worried about the corner-cases on the *implementation* side, more 
> the corner-cases on the API side: are we seeing more users of the API that 
> require an atomic clock, or more that don't care?
> 
Again, you are approaching it from the angle that an atomic clock is a
special requirement rather than the default behaviour. Sleeping for
lookup, addition, and deletion are all quite acceptable, but
enable/disable pairs have always been intended to be usable from atomic
context. Anyone that doesn't count on that fact is either dealing with
special case clocks (PLLs, root clocks, etc.) or simply hasn't bothered
implementing any sort of fine grained runtime power management for their
platform.

It's unfortunate that you managed to pick one of the three or so
platforms with broken semantics to base your implementation off of, but
rest assured, everyone else did infact get it right, at least so far.
