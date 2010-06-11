Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760068Ab0FKJ6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 05:58:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60447 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942Ab0FKJ6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 05:58:49 -0400
Date: Fri, 11 Jun 2010 11:58:39 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: Jeremy Kerr <jeremy.kerr@canonical.com>,
       linux-arm-kernel@lists.infradead.org,
       Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>
Subject: Re: [RFC,PATCH 1/2] Add a common struct clk
Message-ID: <20100611095839.GC10894@pengutronix.de>
References: <1275636608.606606.450179637764.0.gpush@pororo> <201006111557.12249.jeremy.kerr@canonical.com> <19473.61547.684572.647641@ipc1.ka-ro> <201006111718.47426.jeremy.kerr@canonical.com> <19474.172.742782.972629@ipc1.ka-ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19474.172.742782.972629@ipc1.ka-ro>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 11, 2010 at 11:23:56AM +0200, Lothar Waßmann wrote:
> Hi,
> 
> > > Using a mutex in clk_enable()/clk_disable() is a bad idea, since that
> > > makes it impossible to call those functions in interrupt context.
IMHO if a device generates an irq its clock should already be on.  This
way you don't need to enable or disable a clock in irq context.
 
> > Do we do this at the moment? I know at least one implementation of clk_enable 
> > uses a mutex for locking.
> > 
> You are probably talking about the Freescale i.MX51 kernel, that won't
> even boot, if you enable CONFIG_DEBUG_KERNEL, CONFIG_DEBUG_SPINLOCK,
> CONFIG_DEBUG_LOCKDEP and CONFIG_DEBUG_SPINLOCK_SLEEP.
> The mutex in the clock implementation is one of the reasons.
I will have a look into this later today.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
