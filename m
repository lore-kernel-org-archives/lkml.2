Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0ELHim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 03:38:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52587 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0ELHil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 03:38:41 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Subject: Re: Driver for a SmartCard interface on a SoC
Date: Wed, 12 May 2010 09:38:34 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jiri Slaby <jslaby@suse.cz>
References: <201005071518.50406.jbe@pengutronix.de> <201005071625.27872.jbe@pengutronix.de> <20100511223337.05945e68@linux.intel.com>
In-Reply-To: <20100511223337.05945e68@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005120938.34634.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: jbe@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

Alan Cox wrote:
> > > I'd say drivers/char if its a generic char device, but if its MX25
> > > specific code entirely then drivers/platform or arch/.../platform.
> >
> > This driver covers a SmartCard core built into this kind of CPU. Its
> > not like an interrupt controller which is specific to the CPU. Its a
> > component like the USB and LCD controller, also built into this CPU.
> > Maybe other CPUs will follow that are also using this SmartCard core
> > (I don't know, only the manufacture knows).
>
> The question is really about the interface as seen from userspace - is
> that generic or could it be generic so you could write other card
> drivers for different hardware to the same user space interface ?

Yes, the interface can be generic. As the main feature of these cards is the 
communication itself, there are only a few additional requirements to make it 
work. But these additional requirements are shared by all SmartCards. Where 
would be the best place/mail list to discuss this API?

> > > The other question is one of API - it's going to best if the API
> > > isn't MX25 specific but could reasonably be expected to work with
> > > other future devices. A fake tty interface is probably overkill for
> > > that but it would be good to get general review of any API.
> >
> > "faky tty"?
>
> Some systems have before now implemented onchip smart card interfaces
> with drivers that pretend to be a serial port talking a serial link to
> the smartcard.

Do you mean to emulate an external serial device in the kernel driver?
To make it understand the same data sequences these kind of external device 
understand? Would be possible, but its more complex than to run the 
communication via read()/write() and a few additional IOCTLs for the special 
SmartCard handling.

Regards,
Juergen
