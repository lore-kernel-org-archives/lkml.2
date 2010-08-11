Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841Ab0HKPeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 11:34:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:30423 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab0HKPet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 11:34:49 -0400
Date: Wed, 11 Aug 2010 08:32:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: Wolfram Sang <w.sang@pengutronix.de>, Philippe De Muyter <phdm@macqel.be>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, hskinnemoen@atmel.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Rick Bronson <rick@efn.org>, John Nicholls <john@thinlinx.com>,
        Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
        Ryan Mallon <ryan@bluewatersys.com>, rmk@arm.linux.org.uk,
        Bernhard Roth <br@pwrnet.de>, Konrad Mattheis <mattheis@ukma.de>,
        Elektrolot <elektrolot@wp.pl>,
        Prchal =?UTF-8?Q?Ji=C5=99=C3=AD?= <jiri.prchal@aksignal.cz>,
        gregkh@suse.de, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Documentation about RS485 serial communications
Message-Id: <20100811083214.21d2919e.randy.dunlap@oracle.com>
In-Reply-To: <4C626CBF.9020609@evidence.eu.com>
References: <4BB053C4.7050700@evidence.eu.com>
	<4BB10304.6090006@bluewatersys.com>
	<4BB1BF49.2000609@evidence.eu.com>
	<4BB252E3.3030703@bluewatersys.com>
	<4BBD8C9D.3070401@evidence.eu.com>
	<20100408111310.524f7354@lxorguk.ukuu.org.uk>
	<4BBDD71D.1010700@evidence.eu.com>
	<4BFD1FB6.8050405@atmel.com>
	<4BFE2F38.8050200@evidence.eu.com>
	<4BFE41FD.2080804@atmel.com>
	<20100527102917.GB31253@pengutronix.de>
	<4C626CBF.9020609@evidence.eu.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 11:26:23 +0200 Claudio Scordino wrote:

> Hi all,
> 
> 	some time ago I've been asked (by both Wolfram and Philippe) to
> provide some minimal documentation about the usage of the RS485
> interface.
> 
> Here is the document (updated with the very last changes in the
> interface).
> 
> Best regards,
> 
> 	Claudio
> 
> 
> Documentation about RS485 serial communications.
> 
> Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
> ---
>  Documentation/serial/00-INDEX         |    2 +
>  Documentation/serial/serial-rs485.txt |  123 +++++++++++++++++++++++++++++++++
>  2 files changed, 125 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/serial/serial-rs485.txt


> diff --git a/Documentation/serial/serial-rs485.txt b/Documentation/serial/serial-rs485.txt
> new file mode 100644
> index 0000000..f594831
> --- /dev/null
> +++ b/Documentation/serial/serial-rs485.txt
> @@ -0,0 +1,123 @@
> +                        RS485 SERIAL COMMUNICATIONS
> +
...
> +
> +2. HARDWARE-RELATED CONSIDERATIONS
> +
> +   Some CPUs (e.g., Atmel AT91) contain a transceiver capable of working both
> +   as RS232 and RS485. For these microcontrollers, the Linux driver should be
> +   able of working in both modes, and proper ioctls (see later) should be made

      should be able to work in both modes
or
      should be made capable of working in both modes

> +   available at user-level to allow switching from one mode to the other, and
> +   viceversa.

      vice versa.

> +
> +   On some other CPUs (e.g., Freescale imx25) the RS485 transceiver is not
> +   integrated inside the microcontroller itself. Therefore, manufacturers who
> +   use these microcontrollers to produce embedded boards need to connect an
> +   external transceiver to some pin of the CPU.
> +   On these architectures, therefore, no assumptions can be done at the
> +   CPU-level about the presence of a RS485 transceiver, because the connection
> +   (if any) is done outside the microcontroller. Moreover, even in case of
> +   RS485 transceiver, the manufacturer is free to choose the CPU pin used for
> +   the connection.
> +
> +
> +3. DATA STRUCTURES ALREADY AVAILABLE IN THE KERNEL
> +
> +   The Linux kernel provides the serial_rs485 structure (see [2]) to handle
> +   RS485 communications. This data structure is used to set and configure RS485
> +   parameters in the platform data and in ioctls.
> +
> +   Any driver for devices capable of working both as RS232 and RS485 should
> +   provide at least the following ioctls:
> +
> +    - TIOCSRS485 (typically associated with number 0x542F). This ioctl is used
> +      to enable/disable RS485 mode from user-space
> +
> +    - TIOCGRS485 (typically associated with number 0x542E). This ioctl is used
> +      to get RS485 mode from kernel-space (i.e., driver) to user-space.

TIOC[SG]RS485 are #defined in <asm-generic/ioctls.h>, so
#include <asm-generic/ioctls.h>
here and/or below (in userspace program).

> +   In other words, the serial driver should contain a code similar to the next

                                               contain code similar to this:

> +   one:
> +
> +	static struct uart_ops atmel_pops = {
> +		/* ... */
> +		.ioctl		= handle_ioctl,
> +	};
> +
> +	static int handle_ioctl(struct uart_port *port,
> +		unsigned int cmd,
> +		unsigned long arg)
> +	{
> +		struct serial_rs485 rs485conf;
> +
> +		switch (cmd) {
> +			case TIOCSRS485:

Coding style: we put switch and case at the same indent level.

> +				if (copy_from_user(&rs485conf,
> +					(struct serial_rs485 *) arg,
> +					sizeof(rs485conf)))
> +						return -EFAULT;
> +
> +				/* ... */
> +				break;
> +
> +			case TIOCGRS485:
> +				if (copy_to_user((struct serial_rs485 *) arg,
> +					...,
> +					sizeof(rs485conf)))
> +						return -EFAULT;
> +				/* ... */
> +				break;
> +
> +			/* ... */
> +		}
> +	}
> +
> +
> +4. USAGE FROM USER-LEVEL
> +
> +   From user-level, RS485 configuration can be get/set using the previous
> +   ioctls. For instance, to set RS485 you can use the following code:
> +
> +	#include <linux/serial.h>
> +
> +	/* Driver-specific ioctls: */
> +	#define TIOCGRS485      0x542E
> +	#define TIOCSRS485      0x542F
> +
...
> +
> +5. REFERENCES
> +
> + [1]	http://en.wikipedia.org/wiki/Rs485
> + [2]	include/linux/serial.h


Thanks for the addition.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
