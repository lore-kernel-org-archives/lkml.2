Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1BHQbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:31:08 -0500
Received: from smtp.citrix.com ([66.165.176.89]:35011 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662Ab1BHQbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 11:31:07 -0500
X-IronPort-AV: E=Sophos;i="4.60,442,1291611600"; 
   d="scan'208";a="12433593"
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20110208162045.GB4606@dumpdata.com>
References: <20110205200108.921707839@linutronix.de>
	 <4D50641B.2090006@goop.org>
	 <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>
	 <4D506AE6.6080900@goop.org>
	 <1297173811.9388.95.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>
	 <1297177506.9388.135.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1102081619410.31804@localhost6.localdomain6>
	 <20110208162045.GB4606@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 8 Feb 2011 16:31:03 +0000
Message-ID: <1297182663.9388.200.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 16:20 +0000, Konrad Rzeszutek Wilk wrote:
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

I think Thomas was referring to the "unmask because the core didn't do
it for us" hack I added a while back which he is replacing with
IRQF_FORCE_RESUME.

Ian.

> 
> This is what I've in the stable/irq.rework and also in the linux-next
> branch. Please tell me if I messed up.
> 
> Ian Campbell (7):
>       xen: handled remapped IRQs when enabling a pcifront PCI device.
>       xen:events: move find_unbound_irq inside CONFIG_PCI_MSI
>       xen: events: add xen_allocate_irq_{dynamic, gsi} and xen_free_irq
>       xen: events: allocate GSIs and dynamic IRQs from separate IRQ ranges.
>       xen: events: do not free legacy IRQs
>       xen: Fix compile error introduced by "switch to new irq_chip functions"
>       xen/timer: Missing IRQF_NO_SUSPEND in timer code broke suspend.
> 
> Konrad Rzeszutek Wilk (2):
>       xen/irq: Cleanup the find_unbound_irq
>       xen/irq: Don't fall over when nr_irqs_gsi > nr_irqs.
> 
> Thomas Gleixner (3):
>       xen: Remove stale irq_chip.end
>       xen: Switch to new irq_chip functions
>       genirq: Add IRQF_FORCE_RESUME
> 
> > 
> > Core change is in 
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/for-xen
> 
> <nods> Pulled that in my branch.
> > 
> > Thanks,
> > 
> > 	tglx
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/


