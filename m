Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932291Ab0FCRxN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 13:53:13 -0400
Received: from kroah.org ([198.145.64.141]:58941 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757122Ab0FCRxJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 13:53:09 -0400
Date: Thu, 3 Jun 2010 10:42:03 -0700
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-serial@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Graf Yang <graf.yang@analog.com>
Subject: Re: [PATCH 1/2] serial: bfin_5xx: IRDA is not affected by anomaly
 05000230
Message-ID: <20100603174203.GE9307@kroah.com>
References: <1275305372-20523-1-git-send-email-vapier@gentoo.org>
 <20100603174131.GD9307@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603174131.GD9307@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:41:31AM -0700, Greg KH wrote:
> On Mon, May 31, 2010 at 07:29:31AM -0400, Mike Frysinger wrote:
> > From: Graf Yang <graf.yang@analog.com>
> > 
> > Anomaly 05000230 (over sampling of the UART STOP bit) applies only when
> > the peripheral is operating in UART mode.  So drop the anomaly handling
> > when the UART is in IRDA mode.
> > 
> > Signed-off-by: Graf Yang <graf.yang@analog.com>
> > Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> > ---
> >  drivers/serial/bfin_5xx.c |    7 ++++++-
> >  1 files changed, 6 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/serial/bfin_5xx.c b/drivers/serial/bfin_5xx.c
> > index 96f7e74..a78652b 100644
> > --- a/drivers/serial/bfin_5xx.c
> > +++ b/drivers/serial/bfin_5xx.c
> > @@ -869,7 +869,12 @@ bfin_serial_set_termios(struct uart_port *port, struct ktermios *termios,
> >  	}
> >  
> >  	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16);
> > -	quot = uart_get_divisor(port, baud) - ANOMALY_05000230;
> > +	quot = uart_get_divisor(port, baud);
> > +
> > +	/* If discipline is not IRDA, apply ANOMALY_05000230 */
> > +	if (termios->c_line != N_IRDA)
> > +		quot -= ANOMALY_05000230;
> > +
> 
> This can't be applied to the current tree, did you make it backwards?

Crap, that's because I already had it in my tree, doh...
