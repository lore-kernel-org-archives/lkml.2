Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0FNGjj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 02:39:39 -0400
Received: from mail.karo-electronics.de ([81.173.242.67]:57229 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab0FNGji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 02:39:38 -0400
Message-ID: <19477.52889.982995.407051@ipc1.ka-ro>
Date: Mon, 14 Jun 2010 08:39:21 +0200
From: =?iso-8859-15?Q?Lothar_Wa=DFmann?= <LW@KARO-electronics.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Jeremy Kerr <jeremy.kerr@canonical.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
In-Reply-To: <1276319643.1962.181.camel@pasglop>
References: <1275636608.606606.450179637764.0.gpush@pororo>
	<201006111557.12249.jeremy.kerr@canonical.com>
	<19473.61547.684572.647641@ipc1.ka-ro>
	<201006111718.47426.jeremy.kerr@canonical.com>
	<19474.172.742782.972629@ipc1.ka-ro>
	<20100611095839.GC10894@pengutronix.de>
	<19474.2817.333749.485028@ipc1.ka-ro>
	<1276319643.1962.181.camel@pasglop>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Benjamin Herrenschmidt writes:
> On Fri, 2010-06-11 at 12:08 +0200, Lothar Waßmann wrote:
> > Hi,
> > 
> > > > > > Using a mutex in clk_enable()/clk_disable() is a bad idea, since that
> > > > > > makes it impossible to call those functions in interrupt context.
> > > IMHO if a device generates an irq its clock should already be on.  This
> > > way you don't need to enable or disable a clock in irq context.
> > >  
> > You may want to disable a clock in the IRQ handler. The VPU driver in
> > the Freescale BSP for i.MX51 does exactly this.
> > Anyway I don't see any reason for using a mutex here instead of
> > spin_lock_irq_save() as all other implementations do.
> 
> Because you suddenly make it impossible to sleep inside enable/disable
              ^^^^^^^^^^^^^^^^^^^^^^^^^^^
???
All implementations so far use spin_lock_irq_save()!

How would you be able to sleep with a mutex held?
If you hold a lock you must not sleep, no matter what sort of lock it
is.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
