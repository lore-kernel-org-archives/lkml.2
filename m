Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab0EKWOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 18:14:00 -0400
Received: from mga07.intel.com ([143.182.124.22]:63578 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752618Ab0EKWN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 18:13:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,210,1272870000"; 
   d="scan'208";a="275976111"
Date: Tue, 11 May 2010 22:33:37 +0100
From: Alan Cox <alan@linux.intel.com>
To: Juergen Beisert <jbe@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Driver for a SmartCard interface on a SoC
Message-ID: <20100511223337.05945e68@linux.intel.com>
In-Reply-To: <201005071625.27872.jbe@pengutronix.de>
References: <201005071518.50406.jbe@pengutronix.de>
	<20100507140248.7958da8f@linux.intel.com>
	<201005071625.27872.jbe@pengutronix.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I'd say drivers/char if its a generic char device, but if its MX25
> > specific code entirely then drivers/platform or arch/.../platform.
> 
> This driver covers a SmartCard core built into this kind of CPU. Its
> not like an interrupt controller which is specific to the CPU. Its a
> component like the USB and LCD controller, also built into this CPU.
> Maybe other CPUs will follow that are also using this SmartCard core
> (I don't know, only the manufacture knows). 

The question is really about the interface as seen from userspace - is
that generic or could it be generic so you could write other card
drivers for different hardware to the same user space interface ?

> > The other question is one of API - it's going to best if the API
> > isn't MX25 specific but could reasonably be expected to work with
> > other future devices. A fake tty interface is probably overkill for
> > that but it would be good to get general review of any API.
> 
> "faky tty"?

Some systems have before now implemented onchip smart card interfaces
with drivers that pretend to be a serial port talking a serial link to
the smartcard.

Alan
