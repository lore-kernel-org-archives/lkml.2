Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030320Ab2GFLzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:55:31 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:33480 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030294Ab2GFLz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:55:27 -0400
Date: Fri, 6 Jul 2012 13:55:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/8 v3] i2c: i801: enable irq for i801 smbus
 transactions
Message-ID: <20120706135500.44b17c42@endymion.delvare>
In-Reply-To: <CAGS+omAgVLumYvOssHfdjELXixMdfRSxSj003xPzQ5v4h_D-mA@mail.gmail.com>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-8-git-send-email-djkurtz@chromium.org>
	<20120704221600.416d4475@endymion.delvare>
	<CAGS+omAwkwd17MVe3uWoPNCL3y0BvKDvbFGWwjhJ5CpTqncsXA@mail.gmail.com>
	<20120705101015.1e3a3afc@endymion.delvare>
	<CAGS+omAgVLumYvOssHfdjELXixMdfRSxSj003xPzQ5v4h_D-mA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Fri, 6 Jul 2012 18:28:28 +0800, Daniel Kurtz wrote:
> On Thu, Jul 5, 2012 at 4:10 PM, Jean Delvare <khali@linux-fr.org> wrote:
> > On Thu, 5 Jul 2012 12:31:11 +0800, Daniel Kurtz wrote:
> >> The logic for clearing the STATUS_FLAGS was simply that they all
> >> indicate the end of a transaction, so there won't be any further
> >> interrupts.  Thus, it is safe to clear it in the irq, since the irq
> >> will be followed by exactly one wait_event, which can read and process
> >> saved status.
> >
> > It is safe if and only if someone is actually listening to the event.
> > This was not the case for me yesterday. Even if we don't mix interrupts
> > and polling, i801_isr() might still get called when we aren't
> > listening. Not only because the IRQ may be shared, but also for events
> > we don't yet handle, such as an SMBus Alert. Not sure about slave
> > mode.
> 
> The real reason for clearing the flag in the hard irq is that
> otherwise, we end up with an infinite irq loop.  The interrupt is
> apparently level triggered, and must be cleared before exiting the
> ISR.

Oh, OK. If we have to do it that way, then we do.

> Unfortunately, I only had time today to discover this, but not time to fix it.
> Next week I will be away, so I won't have a chance to provide more
> patches for the next 10 days.
> 
> I think the 6 patches you have already make a complete set, however,
> and shouldn't be waiting for the interrupt patch(es) which can follow
> at some future date.

Agreed, that's why they are already in linux-next waiting for the next
merge window to open.

That being said, I would hate to miss that merge window for interrupt
support patches, as this is really a great performance improvement. So,
if you have no objection, I propose to fix your patches myself today of
tomorrow, test them, and if I find no problem, post them and push them
to linux-next. You can review and test them when you return.

-- 
Jean Delvare
