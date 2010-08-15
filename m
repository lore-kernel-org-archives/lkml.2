Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab0HOWVm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 18:21:42 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59971 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751169Ab0HOWVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 18:21:41 -0400
Date: Sun, 15 Aug 2010 23:19:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Claudio Scordino <claudio@evidence.eu.com>,
        Philippe De Muyter <phdm@macqel.be>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, hskinnemoen@atmel.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Rick Bronson <rick@efn.org>, John Nicholls <john@thinlinx.com>,
        Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
        Ryan Mallon <ryan@bluewatersys.com>, Bernhard Roth <br@pwrnet.de>,
        Konrad Mattheis <mattheis@ukma.de>, Elektrolot <elektrolot@wp.pl>,
        Prchal =?utf-8?B?SmnFmcOt?= <jiri.prchal@aksignal.cz>, gregkh@suse.de,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation about RS485 serial communications
Message-ID: <20100815221906.GA24153@n2100.arm.linux.org.uk>
References: <20100408111310.524f7354@lxorguk.ukuu.org.uk> <4BBDD71D.1010700@evidence.eu.com> <4BFD1FB6.8050405@atmel.com> <4BFE2F38.8050200@evidence.eu.com> <4BFE41FD.2080804@atmel.com> <20100527102917.GB31253@pengutronix.de> <4C626CBF.9020609@evidence.eu.com> <20100811083214.21d2919e.randy.dunlap@oracle.com> <4C669120.8080707@evidence.eu.com> <4C686411.3060500@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C686411.3060500@oracle.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 03:02:57PM -0700, Randy Dunlap wrote:
> On 08/14/10 05:50, Claudio Scordino wrote:
> > diff --git a/Documentation/serial/serial-rs485.txt b/Documentation/serial/serial-rs485.txt
> > new file mode 100644
> > index 0000000..93b029e
> > --- /dev/null
> > +++ b/Documentation/serial/serial-rs485.txt
> > @@ -0,0 +1,126 @@
> > +                        RS485 SERIAL COMMUNICATIONS
> > +
> > +1. INTRODUCTION
> > +
> > +   EIA-485, also known as TIA/EIA-485 or RS-485, is a standard defining the
> > +   electrical characteristics of drivers and receivers for use in balanced
> > +   digital multipoint systems.
> > +   This standard is widely used for communications in industrial automation
> > +   because it can be used effectively over long distances and in electrically
> > +   noisy environments.
> > +   Even though the data is transmitted over a 2-wire twisted pair bus, all
> > +   EIA-485 transceivers interpret the voltage levels of the differential
> > +   signals with respect to a third common voltage. Without this common
> > +   reference, a set of transceivers may interpret the differential signals
> > +   incorrectly.
> > +   See [1] for more information.

There are devices on the market which are fully isolating RS485
transceivers which just take the A/B connections, measuring the
differential voltage, and provide you with the TXD/RXD TTL signals
for your UART.

Also note that [1] appears a little confused about the number of pins
required for RS485 - it says two, and then lists three pins.  I don't
think you can use this as being supportive of the requirement for three
connections - and as there are these fully isolating transceivers...

> > +4. USAGE FROM USER-LEVEL
> > +
> > +   From user-level, RS485 configuration can be get/set using the previous
> > +   ioctls. For instance, to set RS485 you can use the following code:
> > +
> > +	#include <linux/serial.h>
> > +
> > +	/* Driver-specific ioctls: */
> > +	#define TIOCGRS485      0x542E
> > +	#define TIOCSRS485      0x542F
> > +
> > +	/* Open your specific device (e.g., /dev/mydevice): */
> > +	int fd = open ("/dev/mydevice", O_RDWR);
> > +	struct serial_rs485 rs485conf;
> > +
> > +	/* Set RS485 mode: */
> > +	rs485conf.flags |= SER_RS485_ENABLED;
> > +
> > +	/* Set rts delay before send, if needed: */
> > +	rs485conf.flags |= SER_RS485_RTS_BEFORE_SEND;
> > +	rs485conf.delay_rts_before_send = ...;
> > +
> > +	/* Set rts delay after send, if needed: */
> > +	rs485conf.flags |= SER_RS485_RTS_AFTER_SEND;
> > +	rs485conf.delay_rts_after_send = ...;
> > +
> > +	ioctl (fd, TIOCSRS485, &rs485conf);

Example code really should do things right, such as check for error
conditions - otherwise people will copy'n'paste this and assume that
the ioctl never fails.

> > +
> > +	/* Use read() and write() syscalls here... */
> > +
> > +	/* Close the device when finished: */
> > +	close (fd);
> > +
> > +5. REFERENCES
> > +
> > + [1]	http://en.wikipedia.org/wiki/Rs485
> > + [2]	include/linux/serial.h
