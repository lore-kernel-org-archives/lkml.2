Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab0EUWbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 18:31:22 -0400
Received: from kroah.org ([198.145.64.141]:53029 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758737Ab0EUWbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 18:31:19 -0400
Date: Fri, 21 May 2010 15:30:06 -0700
From: Greg KH <greg@kroah.com>
To: raj uprade <rajuprade@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: rearding USB-to-serial device driver
Message-ID: <20100521223006.GD12517@kroah.com>
References: <AANLkTimFy8sDVPAnuxLnhLIflMOCkwQntJmLRXClgWf0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimFy8sDVPAnuxLnhLIflMOCkwQntJmLRXClgWf0@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 10:18:45AM +0530, raj uprade wrote:
> Dear Sir,
>               I need your help...I have written a  device driver  named
> mcmdriver.But now I want to use USB port as a serial port.When I plug the
> USB-to-Serial device, I get the ttyUSB0 device file, but I am unable to get
> the details reagarding port address and IRQ associated with ttyUSB0 device
> file.

There is no such thing when it comes to USB devices, especially usb to
serial devices.

> I am clueless how I should proceed.kindly guide me is it possible to
> interface pl2303.c with my mcmdriver.c
> I have also ataached the mcmdriver.c file ....
> 
> *Details regarding mcmdriver.c*
> 
> The mcmdriver module implements a RS-485 multi-drop communication with MCMs
> at 9.6 kbps.
> The mcmdriver module associates a /dev/mcmdriver file to a PC serial port,
> and provides the open, close, read and write functions on it. During the
> module loading, the root can choose which serial port is to be used (serial
> port 1 at 0x3f8, or serial port 2 at 0x2f8).
> This driver is using an interrupt handler that stores incoming data as soon
> as they arrived, unless an overrun or a framing error occurs. The IRQ number
> used is the one usually reserved for the first PC serial port (IRQ 4).
> The reading call is implemented as a “blocking read with time-out”. When
> data arrive on the port, the driver decodes the 2 first bytes to know the
> size of the incoming packet. If a full packet has been received, the 'read'
> returns, otherwise it waits during a maximum period of 2 secs (200 jiffies).
> Bytes are not stored whenever an overrun or a framing error occurs. If the
> Check Sum is right, 'read' copies the packet into the buffer passed in
> argument and returns its size, otherwise it only returns -1.
> A writing call automatically outputs bytes on the serial port as defined in
> the multi-drop RS-485 protocol. All the RTS line and 9-bit operations are
> transparent to the user, who must just be sure that the first byte of the
> sent packet is the MCM address. The 'write' call waits until all the bytes
> are sent, and sends 1 after completion.

Shouldn't this all be done as a line discipline instead of trying to
replace the default serial driver?  Your module will only look to work
with the "standard" serial port on a system, which are getting more and
more rare these days.

thanks,

greg k-h
