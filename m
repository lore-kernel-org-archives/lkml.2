Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457Ab0JSFRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 01:17:11 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:58136 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab0JSFRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 01:17:10 -0400
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <greg@kroah.com>,
        Raju Rameshwar Uprade <rajsingh@ncra.tifr.res.in>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: pl2303 ttyUSB0: pl2303_write - failed submitting write urb, error -22
Date: Tue, 19 Oct 2010 10:46:51 +0530
Message-Id: <20101019050336.M39015@admin-gateway.ncra.tifr.res.in>
In-Reply-To: <20101019033522.GA32577@kroah.com>
References: <20101018102001.M46961@admin-gateway.ncra.tifr.res.in> <20101019033522.GA32577@kroah.com>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> What kernel version are you using?
> 

I am using kernel version 2.6.25.I cann't use current linux kernel version because it
uses the generic write function and for my application I need pl2303_write. 

I am writing a driver through which I can communicate to various MCM devices connected
in parallel using RS-485.

I am now able to separate Adddress byte and data bytes, driver is able to write the addr
byte properly as well as driver is able to copy the data bytes in
write_urb->transfer_buffer.

But when I tried to submit the write_urb->transfer_buffer with data bytes,
kernel log messages show the following error.

drivers/usb/serial/usb-serial.c: USB Serial support registered for pl2303_mcm
pl2303_mcm 7-1:1.0: pl2303_mcm converter detected
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: device type: 2
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: 0xc0:0x1:0x8484:0x0  1 - 2
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: 0x40:0x1:0x404:0x0  0
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: 0xc0:0x1:0x8484:0x0  1 - 2
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: 0xc0:0x1:0x8383:0x0  1 - 0
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: 0xc0:0x1:0x8484:0x0  1 - 2
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: 0x40:0x1:0x404:0x1  0
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: 0xc0:0x1:0x8484:0x0  1 - 2
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: 0xc0:0x1:0x8383:0x0  1 - 0
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: 0x40:0x1:0x0:0x1  0
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: 0x40:0x1:0x1:0x0  0
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: 0x40:0x1:0x2:0x44  0
usb 7-1: pl2303_mcm converter now attached to ttyUSB0
usbcore: registered new interface driver pl2303_mcm
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: Prolific PL2303 USB to serial adaptor
driver modified for MCM communication
[teleset@telab2 ~]$ dmesg | tail -100
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: pl2303_write_bulk_callback - port 0
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: set_control_lines - value = 0, retval = 0
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: pl2303_write_room - port 0
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: pl2303_write_room - returns 199
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: We got the length of USer buffer  8 
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: set_control_lines - value = 3, retval = 0
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: We successfully copied the user buffer
into Buf_Addr
 
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: We successfully copied the user buffer
into write_urb->transfer_buffer
 
pl2303_mcm ttyUSB0: pl2303_write - length = 1, data = 02 
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: We successfully submited the write_URB
 
 
 Data in The Data BUF 0 is -----> 08 
 
 Data in The Data BUF 1 is -----> 00 
 
 Data in The Data BUF 2 is -----> 00 
 
 Data in The Data BUF 3 is -----> 00 
 
 Data in The Data BUF 4 is -----> 00 
 
 Data in The Data BUF 5 is -----> 00 
 
 Data in The Data BUF 6 is -----> 00 
 
 Data in The Data BUF 7 is -----> f8 
 
 Data in The C BUF 0 is -----> 08 
 
 Data in The C BUF 1 is -----> 00 
 
 Data in The C BUF 2 is -----> 00 
 
 Data in The C BUF 3 is -----> 00 
 
 Data in The C BUF 4 is -----> 00 
 
 Data in The C BUF 5 is -----> 00 
 
 Data in The C BUF 6 is -----> 00 
 
 Data in The C BUF 7 is -----> f8 
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: We successfully copied the C buffer into
write_urb->transfer_buffer
 
pl2303_mcm ttyUSB0: pl2303_write - length = 8, data = 08 00 00 00 00 00 00 f8 
pl2303_mcm ttyUSB0: pl2303_write - failed submitting write urb, error -22
/home/teleset/Desktop/USB-Serial/pl2303_mcm.c: pl2303_write_bulk_callback - port 0


thanks-
Raj.


