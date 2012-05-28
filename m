Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab2E1SBv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 14:01:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46628 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727Ab2E1SBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 14:01:50 -0400
Date: Mon, 28 May 2012 19:01:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Roland Stigge <stigge@antcom.de>
Cc: alan@linux.intel.com, gregkh@linuxfoundation.org,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        kevin.wells@nxp.com, srinivas.bakki@nxp.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH] serial/of-serial: Add 16654 chip to compatible string
	list
Message-ID: <20120528180139.GC28290@n2100.arm.linux.org.uk>
References: <1338199134-23885-1-git-send-email-stigge@antcom.de> <20120528100338.GI24149@n2100.arm.linux.org.uk> <4FC35F97.2030400@antcom.de> <20120528150311.GA28290@n2100.arm.linux.org.uk> <4FC3A768.3060208@antcom.de> <20120528163151.GB28290@n2100.arm.linux.org.uk> <4FC3BA89.4060804@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC3BA89.4060804@antcom.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 28, 2012 at 07:48:57PM +0200, Roland Stigge wrote:
> On 28/05/12 18:31, Russell King - ARM Linux wrote:
> >>>> So maybe 16750 is the better choice for me, anyway. Already supported in
> >>>> of-serial. Works for now, but need more testing. Another hint is that
> >>>> 16750 is advertised as "IP core for Soc" which matches the case of LPC32xx.
> >>>
> >>> 16750 also has automatic hardware flow control support, selectable through
> >>> bit 5 in the MCR register.  If your UART has that, then it's probably a
> >>> 16750 derivative rather than a 16550 or 16650 derivative.
> >>>
> >>> 16650s have an EFR register at offset 2, selectable by writing 0xBF into
> >>> the LCR register, which the 16750 doesn't have.  16650 also has automatic
> >>> hardware flow control, bit this is selected through a couple of bits in
> >>> the EFR.
> >>
> >> The 4 LPC32xx's "Standard" UARTs have neither of those.
> >>
> >> Is it ok to use "ns16650", i.e. PORT_16650, or do I need to introduce a
> >> FIFO depth configuration?
> > 
> > I think you need a new type, because as I said above, 16650s have that
> > additional EFR, and we will attempt to access that register which
> > isn't present in yours.
> 
> I actually meant 16750 instead of 16650, sorry, but this basically means
> the same - I would refer to extensions that are actually not there...
> 
> Now, introducing a new type, can I add to 8250.c's uart_config[] by
> introducing a new type (no. 22) after PORT_XR17D15X? Unfortunately,
> there are the "ARM specific type numbers" after current PORT_MAX_8250
> (21), but those are not listed in 8250.c's uart_config[]. Or how am I
> supposed to add a new type?

If it's 8250, stick it in with the group, otherwise the array will
become stupidly large.  That's why there's a separation of the two.
