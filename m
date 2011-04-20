Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1DTJYC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 05:24:02 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37041 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752507Ab1DTJYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 05:24:00 -0400
Date: Wed, 20 Apr 2011 10:25:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: John Linn <John.Linn@xilinx.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Subject: Re: [PATCH] tty/serial: add support for Xilinx PS UART
Message-ID: <20110420102501.1e395f14@lxorguk.ukuu.org.uk>
In-Reply-To: <551928f1-72b8-432e-879e-8721b5c87414@VA3EHSMHS017.ehs.local>
References: <e35578a9-909d-4594-bbe4-41d89b5f9b3e@VA3EHSMHS014.ehs.local>
	<20110419221530.7370d013@lxorguk.ukuu.org.uk>
	<551928f1-72b8-432e-879e-8721b5c87414@VA3EHSMHS017.ehs.local>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > +	/* Min baud rate = 6bps and Max Baud Rate is 10Mbps for 100Mhz
> > clk */
> > > +	baud = uart_get_baud_rate(port, termios, old, 0, 460800);
> > > +	xuartps_set_baud_rate(port, baud);
> > 
> > So why pass 460800 ?
> 
> Seems like 115200 is better number.

Well if it can do 10Mbit why not pass 10Mbit as the upper limit ?

> > And set the baud rate (see 8250.c for an example). Note that the
> helper
> > functions know about mapping slight errors so if you are asked for
> 9600
> > and the hardware does 9575 it will report B9600 as you'd expect not do
> > something crazy.
> > 
> 
> Sorry I didn't follow what you meant above. The h/w is a bit different
> with it's
> baud rate settings due to 2 different dividers.

After you've worked out what baud rate you actually set do

	       /* Don't rewrite B0 */
        if (tty_termios_baud_rate(termios))
                tty_termios_encode_baud_rate(termios, baud, baud);


which will ensure that the termios reflects the actual rate.

Alan
