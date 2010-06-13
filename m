Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0FMW1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 18:27:32 -0400
Received: from aeryn.fluff.org.uk ([87.194.8.8]:28367 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753848Ab0FMW1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 18:27:31 -0400
Date: Sun, 13 Jun 2010 23:27:15 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Lothar Wa?mann <LW@KARO-electronics.de>
Cc: Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
       Jeremy Kerr <jeremy.kerr@canonical.com>,
       linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100613222715.GF31045@fluff.org.uk>
References: <1275636608.606606.450179637764.0.gpush@pororo>
 <201006111557.12249.jeremy.kerr@canonical.com>
 <19473.61547.684572.647641@ipc1.ka-ro>
 <201006111718.47426.jeremy.kerr@canonical.com>
 <19474.172.742782.972629@ipc1.ka-ro>
 <20100611095839.GC10894@pengutronix.de>
 <19474.2817.333749.485028@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19474.2817.333749.485028@ipc1.ka-ro>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 12:08:01PM +0200, Lothar Wa?mann wrote:
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

Hmm, then again the VPU driver may just be a bit wrong here.

We could protect each clock with a spinlock, but that would end up
with a problem of spinning where we have clocks that takes 100s of
usec or so to init. See all PLLs on S3C devices, where it can take
100-300uS to get a stable clock out of the device.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
