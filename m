Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab0EGOZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:25:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50023 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209Ab0EGOZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:25:33 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Subject: Re: Driver for a SmartCard interface on a SoC
Date: Fri, 7 May 2010 16:25:27 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jiri Slaby <jslaby@suse.cz>
References: <201005071518.50406.jbe@pengutronix.de> <20100507140248.7958da8f@linux.intel.com>
In-Reply-To: <20100507140248.7958da8f@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005071625.27872.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Alan Cox wrote:
> On Fri, 7 May 2010 15:18:50 +0200
> Juergen Beisert <jbe@pengutronix.de> wrote:
> > most SmartCard readers are external devices, connected via USB or
> > serial lines. So, they do not need special in-kernel drivers.
> >
> > My SmartCard interface is part of a SoC (i.MX25 CPU). So, I need an
> > in-kernel driver. Where would be the best place in the kernel tree,
> > to add a driver for this kind of device? Maybe "drivers/char"?
> > To exchange data with the plugged in SmartCard, only a couple of
> > IOCTLs are required (detecting if a card is plugged in, socket power
> > on/off, send reset to the card, configuring the communication
> > parameters). Data exchange with the SmartCard can be done with simple
> > read/write.
>
> I'd say drivers/char if its a generic char device, but if its MX25
> specific code entirely then drivers/platform or arch/.../platform.

This driver covers a SmartCard core built into this kind of CPU. Its not like 
an interrupt controller which is specific to the CPU. Its a component like 
the USB and LCD controller, also built into this CPU. Maybe other CPUs will 
follow that are also using this SmartCard core (I don't know, only the 
manufacture knows). 

> The other question is one of API - it's going to best if the API isn't
> MX25 specific but could reasonably be expected to work with other
> future devices. A fake tty interface is probably overkill for that but
> it would be good to get general review of any API.

"faky tty"?

Regards,
Juergen
