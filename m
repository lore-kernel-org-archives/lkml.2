Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab1CAOKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 09:10:15 -0500
Received: from www.tglx.de ([62.245.132.106]:51331 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306Ab1CAOKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 09:10:12 -0500
Date: Tue, 1 Mar 2011 15:09:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Sascha Hauer <s.hauer@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>, Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 3/8] Add a mfd IPUv3 driver
In-Reply-To: <201103011243.33765.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1103011507220.2701@localhost6.localdomain6>
References: <1298887229-7987-1-git-send-email-s.hauer@pengutronix.de> <201103011127.51605.arnd@arndb.de> <20110301111220.GN29521@pengutronix.de> <201103011243.33765.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011, Arnd Bergmann wrote:

> On Tuesday 01 March 2011, Sascha Hauer wrote:
> > > Taking one step back from this, have you considered making this
> > > a regular interrupt controller? That would make the client drivers
> > > more standard -- you could define the interrupt numbers as resources
> > > of a platform device or in the device tree, for instance.
> > > The cost might be more complex code, e.g. when a device requires
> > > many interrupts, but I think it will be at least as efficient
> > > at run-time, and less surprising for readers and authors of
> > > client drivers.
> > 
> > I thought about this, but hesitated to increase NR_IRQS by 463. Do you
> > think we should do this instead?
> 
> I think there is a plan to virtualize the interrupt numbers on ARM,
> and in that case NR_IRQS becomes rather meaningless. I don't know
> exactly how far that effort has come.

Also sparse irqs allows us now to allocate beyond NR_IRQS. With sparse
irqs NR_IRQS is pretty meaningless and just gives us an indicator how
large the irq space might become, but we allow up to 8k dynamically
allocated irqs beyond NR_IRQS, so this should be sufficient for your
problem.

Thanks,

	tglx
