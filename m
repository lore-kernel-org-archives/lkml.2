Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755452Ab1HWPkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 11:40:18 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:36073 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754917Ab1HWPkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 11:40:06 -0400
X-Sasl-enc: RdgASn6/321oyCtfZpgSyKWR7hmXdjZDK6rL9xA73x2R 1314114005
Date: Tue, 23 Aug 2011 08:39:32 -0700
From: Greg KH <greg@kroah.com>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Bernhard Roth <br@pwrnet.de>, nicolas.ferre@atmel.com,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] atmel_serial: RS485: receiving enabled when sending data
Message-ID: <20110823153932.GA26081@kroah.com>
References: <4E492CFF.7040905@pwrnet.de>
 <20110822211832.GA8023@kroah.com>
 <4E536536.3030004@evidence.eu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E536536.3030004@evidence.eu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 10:30:46AM +0200, Claudio Scordino wrote:
> Il 22/08/2011 23:18, Greg KH ha scritto:
> > On Mon, Aug 15, 2011 at 04:28:15PM +0200, Bernhard Roth wrote:
> >> Hello!
> >>
> >> By default the atmel_serial driver in RS485 mode disables receiving
> >> data until all data in the send buffer has been sent. This flag
> >> allows to receive data even whilst sending data. This is very useful
> >> to
> >>
> >> - check if the data has been sent correctly over the RS485 bus
> >> - assure that no collision happened
> >> - check for short circuits/termination issues on the RS485 bus
> >>
> >> Usually this functionality is realized by hardware, wether
> >> controlling the RX-Enable pin of the RS485 transceiver with RTS
> >> (driver control signal) or pulling it LOW permanently. The present
> >> atmel_serial driver makes this impossible, thus requiring following
> >> patch.
> >>
> >> Usage example:
> >>
> >>      struct serial_rs485     rs485;
> >>
> >>      memset(&rs485, 0, sizeof(rs485));
> >>      rs485.flags = SER_RS485_ENABLED | SER_RS485_RX_DURING_TX;
> >>      ioctl(fd, TIOCSRS485,&rs485);
> >>
> >>
> >>
> >>
> >> atmel_serial: RS485: receiving enabled when sending data
> >>
> >> By default the atmel_serial driver in RS485 mode disables receiving
> >> data until
> >> all data in the send buffer has been sent. This flag allows to receive data
> >> even whilst sending data.
> >>
> >> Signed-off-by: Bernhard Roth<br@pwrnet.de>
> >> Signed-off-by: Claudio Scordino<claudio@evidence.eu.com>
> >> ---
> >>   drivers/tty/serial/atmel_serial.c |   17 ++++++++++-------
> >>   include/linux/serial.h            |    1 +
> >>   2 files changed, 11 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/tty/serial/atmel_serial.c
> >> b/drivers/tty/serial/atmel_serial.c
> >> index af9b781..5f6c745 100644
> >> --- a/drivers/tty/serial/atmel_serial.c
> >> +++ b/drivers/tty/serial/atmel_serial.c
> >> @@ -339,8 +339,9 @@ static void atmel_stop_tx(struct uart_port *port)
> >>       /* Disable interrupts */
> >>       UART_PUT_IDR(port, atmel_port->tx_done_mask);
> >>
> >> -    if (atmel_port->rs485.flags&  SER_RS485_ENABLED)
> >> -        atmel_start_rx(port);
> >> +    if ((atmel_port->rs485.flags&  SER_RS485_ENABLED)&&
> >> +        !(atmel_port->rs485.flags&  SER_RS485_RX_DURING_TX))
> >> +            atmel_start_rx(port);
> > 
> > Can you fix your email client to not strip patches of tabs and resend
> > this so that I can apply it?
> > 
> > thanks,
> > 
> > greg k-h
> 
> Hi Greg,
> 
>     please find below the patch with the right tabs.
> 
> Remind however that the main author of the patch is Bernhard, not me.

Then properly send the patch so that this is shown.  Please just add a:

From: foo <foo@foo.org>

as the first line of the patch changelog portion and git will fix things
up correctly.  Documentation/SubmittingPatches describes this in detail.

Care to resend your updated version, with this corrected author
information, so I get it right?

thanks,

greg k-h
