Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab2AYIll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 03:41:41 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35857 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046Ab2AYIlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 03:41:40 -0500
Date: Wed, 25 Jan 2012 09:41:08 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Subject: Re: [PATCH v4] serial/efm32: add new driver
Message-ID: <20120125084108.GF6305@pengutronix.de>
References: <20120124220522.GA10590@kroah.com>
 <1327478704-4233-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1327479959.21686.8.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1327479959.21686.8.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 12:25:59AM -0800, Joe Perches wrote:
> On Wed, 2012-01-25 at 09:05 +0100, Uwe Kleine-König wrote:
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> trivial comments below:
> 
> > diff --git a/drivers/tty/serial/efm32-uart.c b/drivers/tty/serial/efm32-uart.c
> []
> > @@ -0,0 +1,830 @@
> > +#if defined(CONFIG_SERIAL_EFM32_UART_CONSOLE) && defined(CONFIG_MAGIC_SYSRQ)
> > +#define SUPPORT_SYSRQ
> > +#endif
> 
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> 
> > +static void efm32_uart_rx_chars(struct efm32_uart_port *efm_port,
> > +		struct tty_struct *tty)
> > +{
> []
> > +		if ((rxdata & UARTn_RXDATAX_FERR) &&
> > +				!(rxdata & UARTn_RXDATAX_RXDATA__MASK)) {
> 
> Perhaps better as:
> 
> 		if ((rxdata & UARTn_RXDATAX_FERR) &&
> 		    !(rxdata & UARTn_RXDATAX_RXDATA__MASK)) {
This is how my editor does the indention. I'm sure this can be changed,
but I want the indention only to depend on the logical structure not on
where the opening parenthesis in the previous line is. This saves
context changes for future patches.
 
> and RXDATA__MASK with 2 underscores?  perhaps just one _?
Yeah, I like seperating the register bit field name from that fact that
the #define holds a mask.
 
> > +static int efm32_uart_console_setup(struct console *co, char *options)
> []
> > +		for (i = 0; i < ARRAY_SIZE(efm32_uart_ports); ++i) {
> > +			if (efm32_uart_ports[i]) {
> > +				pr_warn("efm32-console: fall back to console index %u (from %hhi)\n",
> > +						i, co->index);
> 
> 				pr_warn("fall back to ..."
> []
> > +	efm_port = efm32_uart_ports[co->index];
> > +	if (!efm_port) {
> > +		pr_warn("efm32-console: No port at %d\n", co->index);
> 
> 		pr_warn("No port at..."
I intentionally did that, as these two messages are related to the
console part of the serial driver while the rest of the messages are
about the serial/tty stuff. And I didn't like changing the definition of
pr_fmt in the middle of the file.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
