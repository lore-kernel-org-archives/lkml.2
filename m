Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113Ab0FNGly (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 02:41:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37180 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752Ab0FNGlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 02:41:53 -0400
Date: Mon, 14 Jun 2010 08:40:28 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Kerr <jeremy.kerr@canonical.com>,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100614064028.GA12159@pengutronix.de>
References: <1275636608.606606.450179637764.0.gpush@pororo> <201006111557.12249.jeremy.kerr@canonical.com> <19473.61547.684572.647641@ipc1.ka-ro> <201006111718.47426.jeremy.kerr@canonical.com> <19474.172.742782.972629@ipc1.ka-ro> <20100611095839.GC10894@pengutronix.de> <19474.2817.333749.485028@ipc1.ka-ro> <1276319643.1962.181.camel@pasglop> <19477.52889.982995.407051@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19477.52889.982995.407051@ipc1.ka-ro>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lothar,

On Mon, Jun 14, 2010 at 08:39:21AM +0200, Lothar Waßmann wrote:
> Hi,
> 
> Benjamin Herrenschmidt writes:
> > On Fri, 2010-06-11 at 12:08 +0200, Lothar Waßmann wrote:
> > > Hi,
> > > 
> > > > > > > Using a mutex in clk_enable()/clk_disable() is a bad idea, since that
> > > > > > > makes it impossible to call those functions in interrupt context.
> > > > IMHO if a device generates an irq its clock should already be on.  This
> > > > way you don't need to enable or disable a clock in irq context.
> > > >  
> > > You may want to disable a clock in the IRQ handler. The VPU driver in
> > > the Freescale BSP for i.MX51 does exactly this.
> > > Anyway I don't see any reason for using a mutex here instead of
> > > spin_lock_irq_save() as all other implementations do.
> > 
> > Because you suddenly make it impossible to sleep inside enable/disable
>               ^^^^^^^^^^^^^^^^^^^^^^^^^^^
> ???
> All implementations so far use spin_lock_irq_save()!
> 
> How would you be able to sleep with a mutex held?
> If you hold a lock you must not sleep, no matter what sort of lock it
> is.
That's wrong.  With a mutex hold you may sleep.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
