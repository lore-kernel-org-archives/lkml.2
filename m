Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1BHPFL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 10:05:11 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:24988 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab1BHPFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 10:05:09 -0500
X-IronPort-AV: E=Sophos;i="4.60,442,1291611600"; 
   d="scan'208";a="134837050"
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
In-Reply-To: <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>
References: <20110205200108.921707839@linutronix.de>
	 <4D50641B.2090006@goop.org>
	 <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>
	 <4D506AE6.6080900@goop.org>
	 <1297173811.9388.95.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 8 Feb 2011 15:05:06 +0000
Message-ID: <1297177506.9388.135.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 14:55 +0000, Thomas Gleixner wrote:
> On Tue, 8 Feb 2011, Ian Campbell wrote:
> > On Mon, 2011-02-07 at 13:57 -0800, Jeremy Fitzhardinge wrote:
> > > On 02/07/2011 01:33 PM, Thomas Gleixner wrote:
> > > > Ok. The irq_chip conversion is mostly mechanical, but I'm really
> > > > concerned about that IRQ_SUSPENDED hackery. It'd be nice if you
> > > > resp. Ian could give that a test ride. That would allow me to cleanup
> > > > stuff in the core code.
> > > 
> > > Ian notes: "tglx's 4 patch interrupt cleanup series on LKML causes some
> > > oddities on PV migration. Will dig further tomorrow..."
> > > 
> > > So it looks like there's still something amiss.
> > 
> > The patches missed an indirect use of IRQF_NO_SUSPEND pulled in via
> > IRQF_TIMER. The following fixed things for me (probably belongs in your
> > patch 4/4).
> > 
> > With this fixlet PV guest migration works just fine. I also booted the
> > entire series as a dom0 kernel and it appeared fine.
> > 
> > I also tested alongside the cleanup patches Jeremy mentioned before and
> > as expected there is no interaction.
> > 
> > So, with the fixes to 2/4 (irq_move_irq think from yesterday) and 4/4
> > (below), the entire series is:
> > Acked-by: Ian Campbell <ian.campbell@citrix.com>
> 
> Cool. So what's the best way to proceed ? That code is not yet in
> linus tree, right ?

Correct.

> So I guess the best way is that I add the core changes to a rc-4 based
> branch and you can pull it in and apply the whole xen stuff to your
> own tree.

My existing cleanup patches are in Konrad's tree (which is in linux-next
etc) so that probably makes most sense as a home for this series. So
unless Konrad has any objections I think it makes sense to pull your
core changes into that branch and then apply your Xen bits on top.

Konrad's branch with my stuff is:
  git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git stable/irq.rework

Konrad, this thread starts at <20110205200108.921707839@linutronix.de>
== http://thread.gmane.org/gmane.linux.kernel/1096437

> I base my pending patches on top of that so it wont be any problem
> when merging the stuff together in next or linus later.

I don't think there will be much trouble with overlap between these and
any Xen events.c changes for the next merge window but what you suggest
should remove the risk.

Ian.

