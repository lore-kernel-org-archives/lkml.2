Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab1LITNL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 14:13:11 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36288 "EHLO
	pyramind.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752153Ab1LITNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 14:13:10 -0500
Date: Fri, 9 Dec 2011 19:13:39 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>
Subject: Re: [PATCH RESEND 6/8] serial: 8250: update rs485 flags with
 polarity settings
Message-ID: <20111209191339.0d9c3dd5@pyramind.ukuu.org.uk>
In-Reply-To: <1323450440-414-7-git-send-email-w.sang@pengutronix.de>
References: <1323450440-414-1-git-send-email-w.sang@pengutronix.de>
	<1323450440-414-7-git-send-email-w.sang@pengutronix.de>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Dec 2011 18:07:18 +0100
Wolfram Sang <w.sang@pengutronix.de> wrote:

> Report the only mode we can support with the 16C850.
> 
> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> ---
>  drivers/tty/serial/8250.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
> index 28b3608..8cf6d76 100644
> --- a/drivers/tty/serial/8250.c
> +++ b/drivers/tty/serial/8250.c
> @@ -2750,6 +2750,9 @@ static int serial8250_ioctl_port(struct uart_port *port,
>  		serial_outp(up, UART_LCR, lcr);
>  		spin_unlock_irqrestore(&up->port.lock, flags);
>  
> +		/* only mode supported by the 16C850 */
> +		rs485ctrl.flags &= ~SER_RS485_RTS_ON_SEND;
> +		rs485ctrl.flags |= SER_RS485_RTS_AFTER_SEND;
>  		up->rs485_flags = rs485ctrl.flags;

Chip specific stuff all wants to be in a port method so while #3 sorts
out much of #2 this goes back to wanting port-> methods and flags to
avoid assumptions about chip types in the core bits.

#7 really makes the point why it is needed.

So pardon the confused series of review comments but I think the summary
is port->ops for RS485 stuff please.

