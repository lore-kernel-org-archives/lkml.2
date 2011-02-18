Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932344Ab1BRRDq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 12:03:46 -0500
Received: from www.tglx.de ([62.245.132.106]:58063 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752100Ab1BRRDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 12:03:44 -0500
Date: Fri, 18 Feb 2011 18:03:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: linux-arm-kernel@lists.infradead.org,
        Pratheesh Gangadhar <pratheesh@ti.com>,
        davinci-linux-open-source@linux.davincidsp.com, gregkh@suse.de,
        amit.chatterjee@ti.com, "Hans J. Koch" <hjk@hansjkoch.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] PRUSS UIO driver support
In-Reply-To: <201102181731.05644.arnd@arndb.de>
Message-ID: <alpine.LFD.2.00.1102181802580.2701@localhost6.localdomain6>
References: <1298041530-26855-1-git-send-email-pratheesh@ti.com> <201102181644.17634.arnd@arndb.de> <alpine.LFD.2.00.1102181713480.2701@localhost6.localdomain6> <201102181731.05644.arnd@arndb.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Arnd Bergmann wrote:

> On Friday 18 February 2011, Thomas Gleixner wrote:
> > On Fri, 18 Feb 2011, Arnd Bergmann wrote:
> > > On Friday 18 February 2011, Pratheesh Gangadhar wrote:
> > > > Signed-off-by: Pratheesh Gangadhar <pratheesh@ti.com>
> > > > +static irqreturn_t pruss_handler(int irq, struct uio_info *dev_info)
> > > > +{
> > > > +   return IRQ_HANDLED;
> > > > +}
> > > 
> > > An empty interrupt handler is rather pointless. I guess you really
> > > notify user space when the interrupt handler gets called, as this
> > > is the main point of a UIO driver as far as I understand it.
> > 
> > The UIO core code does this for you when the driver handler returns
> > IRQ_HANDLED
> 
> Ah, right.
> 
> > but the empty handler raises a different questions:
> > 
> > Is the interrupt edge triggerd or how do you avoid an irq storm here?
> > Usually UIO drivers are requested to mask the interrupt in the device
> > itself.
> 
> If it's edge triggered, it should not advertise IRQF_SHARED, right?

Nope. And the handler needs a fat comment why this works.

Thanks,

	tglx
