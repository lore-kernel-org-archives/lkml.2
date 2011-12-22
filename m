Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1LVI5N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 03:57:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48531 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753736Ab1LVI5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 03:57:12 -0500
Date: Thu, 22 Dec 2011 09:57:06 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH] serial/efm32: add new driver
Message-ID: <20111222085706.GD24496@pengutronix.de>
References: <1324479959-7343-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20111221202847.4ffeba10@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111221202847.4ffeba10@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Dec 21, 2011 at 08:28:47PM +0000, Alan Cox wrote:
> On Wed, 21 Dec 2011 16:05:59 +0100
> Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > ---
> > Hello,
> > 
> > note that ARCH_EFM32 isn't in mainline yet, so to be actually usable
> > some arch patches are needed.
> 
> Start by running it through the CodingStyle scripts as I see a //
> comment in there 8)
oops

> > +static void efm32_usart_rx_chars(struct efm32_usart_port *efm_port)
> > +{
> > +	struct uart_port *port = &efm_port->port;
> > +	struct tty_struct *tty = port->state->port.tty;
> 
> Needs to be using krefs and checking the tty is not NULL
> (tty_port_tty_get)
ah, I copied from mxs-auart. Will try to find a better example. 
 
> > +static void efm32_usart_set_termios(struct uart_port *port,
> > +		struct ktermios *new, struct ktermios *old)
> > +{
> > +	struct efm32_usart_port *efm_port = to_efm_port(port);
> > +	unsigned long flags;
> > +	unsigned baud;
> > +	u32 clkdiv;
> > +
> > +	/* no modem control lines */
> > +	new->c_cflag &= ~(HUPCL | CRTSCTS | CMSPAR);
> 
> Minor item - HUPCL shouldn't get cleared - its a request for hangup
> behaviour not a port feature.
ah, I copied that from imx (in an if(0) though).
 
> > +	/* currently only some features are implemented */
> > +	new->c_cflag &= ~CSIZE;
> > +	new->c_cflag |= CS8;
> > +	new->c_cflag |= CSTOPB;
> > +	new->c_cflag &= ~PARENB;
> 
> If you can do CS8 without parity you can do CS7 with parity.
I sticked to the things I use and tested. According to the manual the
hardware can do 4 up to 16 data bits with and without parity :-)
 
> > +	new->c_iflag = 0;
> 
> This seems broken. Lots of the iflgs are user requests and stack
> properties not port features. For example you can do xon/xoff as its
> pure software. As far as I can see you should leave c_iflag alone.
ok.

I will send an update and fix the drivers I copied from.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
