Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab1BHOzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 09:55:10 -0500
Received: from www.tglx.de ([62.245.132.106]:34003 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab1BHOzJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 09:55:09 -0500
Date: Tue, 8 Feb 2011 15:55:00 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
cc: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
In-Reply-To: <1297173811.9388.95.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>
References: <20110205200108.921707839@linutronix.de>  <4D50641B.2090006@goop.org>  <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>  <4D506AE6.6080900@goop.org> <1297173811.9388.95.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Feb 2011, Ian Campbell wrote:
> On Mon, 2011-02-07 at 13:57 -0800, Jeremy Fitzhardinge wrote:
> > On 02/07/2011 01:33 PM, Thomas Gleixner wrote:
> > > Ok. The irq_chip conversion is mostly mechanical, but I'm really
> > > concerned about that IRQ_SUSPENDED hackery. It'd be nice if you
> > > resp. Ian could give that a test ride. That would allow me to cleanup
> > > stuff in the core code.
> > 
> > Ian notes: "tglx's 4 patch interrupt cleanup series on LKML causes some
> > oddities on PV migration. Will dig further tomorrow..."
> > 
> > So it looks like there's still something amiss.
> 
> The patches missed an indirect use of IRQF_NO_SUSPEND pulled in via
> IRQF_TIMER. The following fixed things for me (probably belongs in your
> patch 4/4).
> 
> With this fixlet PV guest migration works just fine. I also booted the
> entire series as a dom0 kernel and it appeared fine.
> 
> I also tested alongside the cleanup patches Jeremy mentioned before and
> as expected there is no interaction.
> 
> So, with the fixes to 2/4 (irq_move_irq think from yesterday) and 4/4
> (below), the entire series is:
> Acked-by: Ian Campbell <ian.campbell@citrix.com>

Cool. So what's the best way to proceed ? That code is not yet in
linus tree, right ?

So I guess the best way is that I add the core changes to a rc-4 based
branch and you can pull it in and apply the whole xen stuff to your
own tree.

I base my pending patches on top of that so it wont be any problem
when merging the stuff together in next or linus later.

Thanks,

	tglx
