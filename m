Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab1BHRdd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:33:33 -0500
Received: from www.tglx.de ([62.245.132.106]:58013 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab1BHRdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:33:32 -0500
Date: Tue, 8 Feb 2011 18:33:14 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
In-Reply-To: <20110208162045.GB4606@dumpdata.com>
Message-ID: <alpine.LFD.2.00.1102081829330.31804@localhost6.localdomain6>
References: <20110205200108.921707839@linutronix.de> <4D50641B.2090006@goop.org> <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6> <4D506AE6.6080900@goop.org> <1297173811.9388.95.camel@zakaz.uk.xensource.com> <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>
 <1297177506.9388.135.camel@zakaz.uk.xensource.com> <alpine.LFD.2.00.1102081619410.31804@localhost6.localdomain6> <20110208162045.GB4606@dumpdata.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on Tue, 8 Feb 2011, Konrad Rzeszutek Wilk wrote:

> On Tue, Feb 08, 2011 at 04:39:58PM +0100, Thomas Gleixner wrote:
> > On Tue, 8 Feb 2011, Ian Campbell wrote:
> > > On Tue, 2011-02-08 at 14:55 +0000, Thomas Gleixner wrote:
> > > > > So, with the fixes to 2/4 (irq_move_irq think from yesterday) and 4/4
> > > > > (below), the entire series is:
> > > > > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> > > > 
> > > > Cool. So what's the best way to proceed ? That code is not yet in
> > > > linus tree, right ?
> > > 
> > > Correct.
> > > 
> > > > So I guess the best way is that I add the core changes to a rc-4 based
> > > > branch and you can pull it in and apply the whole xen stuff to your
> > > > own tree.
> > > 
> > > My existing cleanup patches are in Konrad's tree (which is in linux-next
> > > etc) so that probably makes most sense as a home for this series. So
> > > unless Konrad has any objections I think it makes sense to pull your
> > > core changes into that branch and then apply your Xen bits on top.
> 
> Ok. Pulled in these patches and stuck Ack-ed by Ian on them.
> > > 
> > > Konrad's branch with my stuff is:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/irq.rework
> > > 
> > > Konrad, this thread starts at <20110205200108.921707839@linutronix.de>
> > > == http://thread.gmane.org/gmane.linux.kernel/1096437
> > > 
> > > > I base my pending patches on top of that so it wont be any problem
> > > > when merging the stuff together in next or linus later.
> > > 
> > > I don't think there will be much trouble with overlap between these and
> > > any Xen events.c changes for the next merge window but what you suggest
> > > should remove the risk.
> > 
> > Yes, and please talk to me next time before you hack around in the
> > guts of the interrupt code. I noticed just because I was skimming
> > -next, and that really conflicts with major cleanups I'm doing. If
> > there is a shortcoming in the generic code, then let me know.
> 
> <scratches his head> The rework was in Xen code not in generic, and
> the only generic changes that are in there ..  are your code?

The point is:

If you play with generic irq code in Xen in some weird way then you
basically block me to cleanup something in the core code w/o breaking
Xen. I wanted to move IRQ_SUSPENDED to a different field and
accidentally noticed that Xen was fiddling with in -next.

So that's what I'm grumpy about. You hack away in Xen and claim it's
confined to your code, while in reality it is _NOT_.

Again, if there is a problem with the generic code then talk to me.

That's going to be impossible anyway when I'm done with the
encapsulation.

Thanks,

	tglx
