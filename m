Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978Ab0JSMi3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 08:38:29 -0400
Received: from 199-38.141.95.serverdedicati.seflow.it ([95.141.38.199]:58385
	"EHLO borg.asidev.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S932393Ab0JSMi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 08:38:26 -0400
Message-ID: <4CBD8EE4.5040808@evidence.eu.com>
Date: Tue, 19 Oct 2010 14:28:20 +0200
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        gregkh@suse.de, Rick Bronson <rick@efn.org>,
        Konrad Mattheis <mattheis@ukma.de>, hskinnemoen@atmel.com,
        John Nicholls <john@thinlinx.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
        Ryan Mallon <ryan@bluewatersys.com>, Elektrolot <elektrolot@wp.pl>,
        Philippe De Muyter <phdm@macqel.be>,
        =?UTF-8?B?UHJjaGFsIEppxZnDrQ==?= <jiri.prchal@aksignal.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bernhard Roth <br@pwrnet.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] Documentation about RS485 serial communications
References: <20100408111310.524f7354@lxorguk.ukuu.org.uk>	<4BBDD71D.1010700@evidence.eu.com> <4BFD1FB6.8050405@atmel.com>	<4BFE2F38.8050200@evidence.eu.com> <4BFE41FD.2080804@atmel.com>	<20100527102917.GB31253@pengutronix.de>	<4C626CBF.9020609@evidence.eu.com>	<20100811083214.21d2919e.randy.dunlap@oracle.com>	<4C669120.8080707@evidence.eu.com> <4C686411.3060500@oracle.com> <20100815221906.GA24153@n2100.arm.linux.org.uk>
In-Reply-To: <20100815221906.GA24153@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux ha scritto:
> On Sun, Aug 15, 2010 at 03:02:57PM -0700, Randy Dunlap wrote:
>> On 08/14/10 05:50, Claudio Scordino wrote:
>>> diff --git a/Documentation/serial/serial-rs485.txt b/Documentation/serial/serial-rs485.txt
>>> new file mode 100644
>>> index 0000000..93b029e
>>> --- /dev/null
>>> +++ b/Documentation/serial/serial-rs485.txt
>>> @@ -0,0 +1,126 @@
>>> +                        RS485 SERIAL COMMUNICATIONS
>>> +
>>> +1. INTRODUCTION
>>> +
>>> +   EIA-485, also known as TIA/EIA-485 or RS-485, is a standard defining the
>>> +   electrical characteristics of drivers and receivers for use in balanced
>>> +   digital multipoint systems.
>>> +   This standard is widely used for communications in industrial automation
>>> +   because it can be used effectively over long distances and in electrically
>>> +   noisy environments.
>>> +   Even though the data is transmitted over a 2-wire twisted pair bus, all
>>> +   EIA-485 transceivers interpret the voltage levels of the differential
>>> +   signals with respect to a third common voltage. Without this common
>>> +   reference, a set of transceivers may interpret the differential signals
>>> +   incorrectly.
>>> +   See [1] for more information.
> 
> There are devices on the market which are fully isolating RS485
> transceivers which just take the A/B connections, measuring the
> differential voltage, and provide you with the TXD/RXD TTL signals
> for your UART.
> 
> Also note that [1] appears a little confused about the number of pins
> required for RS485 - it says two, and then lists three pins.  I don't
> think you can use this as being supportive of the requirement for three
> connections - and as there are these fully isolating transceivers...
> 
>>> +4. USAGE FROM USER-LEVEL
>>> +
>>> +   From user-level, RS485 configuration can be get/set using the previous
>>> +   ioctls. For instance, to set RS485 you can use the following code:
>>> +
>>> +	#include <linux/serial.h>
>>> +
>>> +	/* Driver-specific ioctls: */
>>> +	#define TIOCGRS485      0x542E
>>> +	#define TIOCSRS485      0x542F
>>> +
>>> +	/* Open your specific device (e.g., /dev/mydevice): */
>>> +	int fd = open ("/dev/mydevice", O_RDWR);
>>> +	struct serial_rs485 rs485conf;
>>> +
>>> +	/* Set RS485 mode: */
>>> +	rs485conf.flags |= SER_RS485_ENABLED;
>>> +
>>> +	/* Set rts delay before send, if needed: */
>>> +	rs485conf.flags |= SER_RS485_RTS_BEFORE_SEND;
>>> +	rs485conf.delay_rts_before_send = ...;
>>> +
>>> +	/* Set rts delay after send, if needed: */
>>> +	rs485conf.flags |= SER_RS485_RTS_AFTER_SEND;
>>> +	rs485conf.delay_rts_after_send = ...;
>>> +
>>> +	ioctl (fd, TIOCSRS485, &rs485conf);
> 
> Example code really should do things right, such as check for error
> conditions - otherwise people will copy'n'paste this and assume that
> the ioctl never fails.

Here is the new document containing the changed you've proposed.

If OK, somebody please provide for commit (the merge window is opening...).

Cheers,

	Claudio


Documentation about RS485 serial communications

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
---
 Documentation/serial/00-INDEX         |    2 +
 Documentation/serial/serial-rs485.txt |  126 +++++++++++++++++++++++++++++++++
 2 files changed, 128 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/serial/serial-rs485.txt

diff --git a/Documentation/serial/00-INDEX b/Documentation/serial/00-INDEX
index 07dcdb0..e09468a 100644
--- a/Documentation/serial/00-INDEX
+++ b/Documentation/serial/00-INDEX
@@ -14,6 +14,8 @@ riscom8.txt
 	- notes on using the RISCom/8 multi-port serial driver.
 rocket.txt
 	- info on the Comtrol RocketPort multiport serial driver.
+serial-rs485.txt
+	- info about RS485 structures and support in the kernel.
 specialix.txt
 	- info on hardware/driver for specialix IO8+ multiport serial card.
 stallion.txt
diff --git a/Documentation/serial/serial-rs485.txt b/Documentation/serial/serial-rs485.txt
new file mode 100644
index 0000000..82ebc86
--- /dev/null
+++ b/Documentation/serial/serial-rs485.txt
@@ -0,0 +1,126 @@
+                        RS485 SERIAL COMMUNICATIONS
+
+1. INTRODUCTION
+
+   EIA-485, also known as TIA/EIA-485 or RS-485, is a standard defining the
+   electrical characteristics of drivers and receivers for use in balanced
+   digital multipoint systems.
+   This standard is widely used for communications in industrial automation
+   because it can be used effectively over long distances and in electrically
+   noisy environments.
+
+2. HARDWARE-RELATED CONSIDERATIONS
+
+   Some CPUs (e.g., Atmel AT91) contain a transceiver capable of working both
+   as RS232 and RS485. For these microcontrollers, the Linux driver should be
+   made capable of working in both modes, and proper ioctls (see later) should
+   be made available at user-level to allow switching from one mode to the
+   other, and vice versa.
+
+   On some other CPUs (e.g., Freescale imx25) the RS485 transceiver is not
+   integrated inside the microcontroller itself. Therefore, manufacturers who
+   use these microcontrollers to produce embedded boards need to connect an
+   external transceiver to some pin of the CPU.
+   On these architectures, therefore, no assumptions can be done at the
+   CPU-level about the presence of a RS485 transceiver, because the connection
+   (if any) is done outside the microcontroller. Moreover, even in case of
+   RS485 transceiver, the manufacturer is free to choose the CPU pin used for
+   the connection.
+
+
+3. DATA STRUCTURES ALREADY AVAILABLE IN THE KERNEL
+
+   The Linux kernel provides the serial_rs485 structure (see [1]) to handle
+   RS485 communications. This data structure is used to set and configure RS485
+   parameters in the platform data and in ioctls.
+
+   Any driver for devices capable of working both as RS232 and RS485 should
+   provide at least the following ioctls:
+
+    - TIOCSRS485 (typically associated with number 0x542F). This ioctl is used
+      to enable/disable RS485 mode from user-space
+
+    - TIOCGRS485 (typically associated with number 0x542E). This ioctl is used
+      to get RS485 mode from kernel-space (i.e., driver) to user-space.
+
+   In other words, the serial driver should contain a code similar to the next
+   one:
+
+	static struct uart_ops atmel_pops = {
+		/* ... */
+		.ioctl		= handle_ioctl,
+	};
+
+	static int handle_ioctl(struct uart_port *port,
+		unsigned int cmd,
+		unsigned long arg)
+	{
+		struct serial_rs485 rs485conf;
+
+		switch (cmd) {
+		case TIOCSRS485:
+			if (copy_from_user(&rs485conf,
+				(struct serial_rs485 *) arg,
+				sizeof(rs485conf)))
+					return -EFAULT;
+
+			/* ... */
+			break;
+
+		case TIOCGRS485:
+			if (copy_to_user((struct serial_rs485 *) arg,
+				...,
+				sizeof(rs485conf)))
+					return -EFAULT;
+			/* ... */
+			break;
+
+		/* ... */
+		}
+	}
+
+
+4. USAGE FROM USER-LEVEL
+
+   From user-level, RS485 configuration can be get/set using the previous
+   ioctls. For instance, to set RS485 you can use the following code:
+
+	#include <linux/serial.h>
+
+	/* Driver-specific ioctls: */
+	#define TIOCGRS485      0x542E
+	#define TIOCSRS485      0x542F
+
+	/* Open your specific device (e.g., /dev/mydevice): */
+	int fd = open ("/dev/mydevice", O_RDWR);
+	if (fd < 0) {
+		/* Error handling. See errno. */
+	}
+
+	struct serial_rs485 rs485conf;
+
+	/* Set RS485 mode: */
+	rs485conf.flags |= SER_RS485_ENABLED;
+
+	/* Set rts delay before send, if needed: */
+	rs485conf.flags |= SER_RS485_RTS_BEFORE_SEND;
+	rs485conf.delay_rts_before_send = ...;
+
+	/* Set rts delay after send, if needed: */
+	rs485conf.flags |= SER_RS485_RTS_AFTER_SEND;
+	rs485conf.delay_rts_after_send = ...;
+
+	if (ioctl (fd, TIOCSRS485, &rs485conf) < 0) {
+		/* Error handling. See errno. */
+	}
+
+	/* Use read() and write() syscalls here... */
+
+	/* Close the device when finished: */
+	if (close (fd) < 0) {
+		/* Error handling. See errno. */
+	}
+
+5. REFERENCES
+
+ [1]	include/linux/serial.h
