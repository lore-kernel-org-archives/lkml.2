Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292Ab1HVXpK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 19:45:10 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:52831 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753881Ab1HVXpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 19:45:07 -0400
Date: Mon, 22 Aug 2011 17:45:06 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
cc: Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        torvalds@linux-foundation.org, mporter@ti.com
Subject: Re: [PATCH] irq: always set IRQF_ONESHOT if no primary handler is
 specified
In-Reply-To: <20110818213418.GA20509@legolas.emea.dhcp.ti.com>
Message-ID: <alpine.DEB.2.00.1108221742130.10315@utopia.booyaka.com>
References: <1310070737-18514-1-git-send-email-bigeasy@linutronix.de> <C5991460-2092-4E65-99EE-091F8DAA0AC3@gmail.com> <4E4D4A5F.202@linutronix.de> <20110818213418.GA20509@legolas.emea.dhcp.ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011, Felipe Balbi wrote:

> On Thu, Aug 18, 2011 at 07:22:39PM +0200, Sebastian Andrzej Siewior wrote:
> > Pantelis Antoniou wrote:
> > 
> > >Let me report that with this change Beagle board fails to boot,
> > >hangs right on rootfs mount.
> > 
> > Can you provide some more information about the kind of the failure and
> > used drivers?
> > 
> > >Users of BB should revert this until the offending driver(s) are fixed.
> > Which is the offending driver?
> 
> I would guess it's the lack of threaded IRQ conversion on the
> twl4030 driver. I have converted it but noone actually picked the series
> [1].
> 
> http://marc.info/?i=1309427470-605-1-git-send-email-balbi@ti.com

Just a data point: applying this series doesn't seem to fix the hang.

Sebastian, Thomas, does commit f3637a5f2e2eb391ff5757bc83fb5de8f9726464 
("irq: Always set IRQF_ONESHOT if no primary handler is specified") fix 
anything, aside from a driver in staging?


- Paul
