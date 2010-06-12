Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab0FLFOY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 01:14:24 -0400
Received: from gate.crashing.org ([63.228.1.57]:35787 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642Ab0FLFOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 01:14:23 -0400
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Lothar =?ISO-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Jeremy Kerr <jeremy.kerr@canonical.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
In-Reply-To: <19474.2817.333749.485028@ipc1.ka-ro>
References: <1275636608.606606.450179637764.0.gpush@pororo>
	 <201006111557.12249.jeremy.kerr@canonical.com>
	 <19473.61547.684572.647641@ipc1.ka-ro>
	 <201006111718.47426.jeremy.kerr@canonical.com>
	 <19474.172.742782.972629@ipc1.ka-ro>
	 <20100611095839.GC10894@pengutronix.de>
	 <19474.2817.333749.485028@ipc1.ka-ro>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Jun 2010 15:14:03 +1000
Message-ID: <1276319643.1962.181.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-11 at 12:08 +0200, Lothar Waßmann wrote:
> Hi,
> 
> > > > > Using a mutex in clk_enable()/clk_disable() is a bad idea, since that
> > > > > makes it impossible to call those functions in interrupt context.
> > IMHO if a device generates an irq its clock should already be on.  This
> > way you don't need to enable or disable a clock in irq context.
> >  
> You may want to disable a clock in the IRQ handler. The VPU driver in
> the Freescale BSP for i.MX51 does exactly this.
> Anyway I don't see any reason for using a mutex here instead of
> spin_lock_irq_save() as all other implementations do.

Because you suddenly make it impossible to sleep inside enable/disable
unless I'm mistaken about the implementation details. Some PLLs can need
milliseconds to stabilize (especially if they need to be powered up
first). Doing that with a lock held is a BAD IDEA.

Cheers,
Ben.


