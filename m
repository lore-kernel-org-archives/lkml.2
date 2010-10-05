Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932919Ab0JELDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 07:03:37 -0400
Received: from dhruva1.ncra.tifr.res.in ([158.144.12.129]:56617 "EHLO
	dhruva1.ncra.tifr.res.in" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0JELDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 07:03:36 -0400
From: "Raju Rameshwar Uprade" <rajsingh@ncra.tifr.res.in>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: pl2303_ttyUSB0 userspace application not able to control RTS line
Date: Tue, 5 Oct 2010 16:33:16 +0530
Message-Id: <20101005104403.M28756@admin-gateway.ncra.tifr.res.in>
In-Reply-To: <20101004042924.M50398@admin-gateway.ncra.tifr.res.in>
References: <20100913154843.GA27496@suse.de> <20100914060649.M96376@admin-gateway.ncra.tifr.res.in> <20100914131925.GC375@suse.de> <20100922052107.M44650@admin-gateway.ncra.tifr.res.in> <20100922145607.GB26309@suse.de> <20100923100127.M64470@admin-gateway.ncra.tifr.res.in> <20100923140236.GB31394@suse.de> <20100928091520.M79654@admin-gateway.ncra.tifr.res.in> <20100928113036.GA15024@suse.de> <20100928115204.M46802@admin-gateway.ncra.tifr.res.in> <20100928120743.GA15807@suse.de> <20101004042924.M50398@admin-gateway.ncra.tifr.res.in>
X-Mailer: OpenWebMail 2.53 (08:Aug:2008)
X-OriginatingIP: 158.144.12.129
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=OPENWEBMAIL_ATT_0.638244222474412"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=OPENWEBMAIL_ATT_0.638244222474412
Content-Type: text/plain;
	charset=utf-8

Hi,
   I am using a prolific tech USB-to-serial converter on linux kernel version 2.6.35.
I wrote a userspace program to enable/disable RTS line which is working fine with
standard serial port like ttyS0 and ttyS1.

But when I used the USB-to-serial port (ttyUSB0) to enable/disable the RTS line,ttyUSB0
is not able to do that as well as some times gives

pl2303_ttyUSB0 : pl2303_open-failed submitting read urb -error 22.

Attached is the userspace application and kernel log is also given below,

/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_open -  port 0
/home/teleset/Desktop/USB-Serial/pl2303.c: 0x40:0x1:0x8:0x0  0
/home/teleset/Desktop/USB-Serial/pl2303.c: 0x40:0x1:0x9:0x0  0
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios -  port 0
/home/teleset/Desktop/USB-Serial/pl2303.c: 0xa1:0x21:0:0  7 - 80 25 0 0 0 0 8
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios - data bits = 8
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios - baud = 9600
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios - stop bits = 1
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios - parity = none
/home/teleset/Desktop/USB-Serial/pl2303.c: 0x21:0x20:0:0  7
/home/teleset/Desktop/USB-Serial/pl2303.c: 0xa1:0x21:0:0  7 - 80 25 0 0 0 0 8
/home/teleset/Desktop/USB-Serial/pl2303.c: 0x40:0x1:0x0:0x0  0
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_open - submitting read urb
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_open - submitting interrupt urb
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_ioctl not supported = 0x5401
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_ioctl (0) cmd = 0x540b
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_ioctl not supported = 0x540b
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5402
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_ioctl not supported = 0x5402
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios -  port 0
/home/teleset/Desktop/USB-Serial/pl2303.c: 0xa1:0x21:0:0  7 - 80 25 0 0 0 0 8
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios - data bits = 8
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios - baud = 9600
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios - stop bits = 1
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios - parity = none
/home/teleset/Desktop/USB-Serial/pl2303.c: 0x21:0x20:0:0  7
/home/teleset/Desktop/USB-Serial/pl2303.c: 0xa1:0x21:0:0  7 - 80 25 0 0 0 0 8
/home/teleset/Desktop/USB-Serial/pl2303.c: 0x40:0x1:0x0:0x61  0
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_ioctl not supported = 0x5401
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_tiocmget (0)
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_tiocmget - result = 6
/home/teleset/Desktop/USB-Serial/pl2303.c: set_control_lines - value = 3, retval = 0
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_tiocmget (0)
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_tiocmget - result = 6
/home/teleset/Desktop/USB-Serial/pl2303.c: set_control_lines - value = 1, retval = 0
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5402
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_ioctl not supported = 0x5402
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios -  port 0
/home/teleset/Desktop/USB-Serial/pl2303.c: 0xa1:0x21:0:0  7 - 80 25 0 0 0 0 8
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios - data bits = 8
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios - baud = 9600
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios - stop bits = 1
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_set_termios - parity = none
/home/teleset/Desktop/USB-Serial/pl2303.c: 0x21:0x20:0:0  7
/home/teleset/Desktop/USB-Serial/pl2303.c: set_control_lines - value = 3, retval = 0
/home/teleset/Desktop/USB-Serial/pl2303.c: 0xa1:0x21:0:0  7 - 80 25 0 0 0 0 8
/home/teleset/Desktop/USB-Serial/pl2303.c: 0x40:0x1:0x0:0x0  0
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_ioctl (0) cmd = 0x5401
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_ioctl not supported = 0x5401
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_close - port 0
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_close - shutting down urbs
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_read_bulk_callback - port 0
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_read_bulk_callback - urb status = -2
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_read_bulk_callback - port is closed,
exiting.
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_read_int_callback (0)
/home/teleset/Desktop/USB-Serial/pl2303.c: pl2303_read_int_callback - urb shutting do

Thanks-
Raj

------=OPENWEBMAIL_ATT_0.638244222474412
Content-Type: text/x-csrc;
	name="Test.c"
Content-Disposition: attachment; filename="Test.c"
Content-Transfer-Encoding: base64

I2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIuaD4KI2luY2x1ZGUgPHRlcm1pb3Mu
aD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3lzL2lvY3RsLmg+CiNpbmNsdWRlIDxz
eXMvdHlwZXMuaD4KI2luY2x1ZGUgPHN5cy9zdGF0Lmg+CiNpbmNsdWRlIDxmY250bC5oPgoKCnN0
YXRpYyBzdHJ1Y3QgdGVybWlvcyBvbGR0ZXJtaW5mbzsKCgp2b2lkIGNsb3Nlc2VyaWFsKGludCBm
ZCkKewogICAgdGNzZXRhdHRyKGZkLCBUQ1NBTk9XLCAmb2xkdGVybWluZm8pOwogICAgaWYgKGNs
b3NlKGZkKSA8IDApCiAgICAgICAgcGVycm9yKCJjbG9zZXNlcmlhbCgpIik7Cn0KCgppbnQgb3Bl
bnNlcmlhbChjaGFyICpkZXZpY2VuYW1lKQp7CiAgICBpbnQgZmQ7CiAgICBzdHJ1Y3QgdGVybWlv
cyBhdHRyOwoKICAgIGlmICgoZmQgPSBvcGVuKGRldmljZW5hbWUsIE9fUkRXUikpID09IC0xKSB7
CiAgICAgICAgcGVycm9yKCJvcGVuc2VyaWFsKCk6IG9wZW4oKSIpOwogICAgICAgIHJldHVybiAw
OwogICAgfQogICAgaWYgKHRjZ2V0YXR0cihmZCwgJm9sZHRlcm1pbmZvKSA9PSAtMSkgewogICAg
ICAgIHBlcnJvcigib3BlbnNlcmlhbCgpOiB0Y2dldGF0dHIoKSIpOwogICAgICAgIHJldHVybiAw
OwogICAgfQogICAgYXR0ciA9IG9sZHRlcm1pbmZvOwogICAgYXR0ci5jX2NmbGFnIHw9IENSVFND
VFMgfCBDTE9DQUw7CiAgICBhdHRyLmNfb2ZsYWcgPSAwOwogICAgaWYgKHRjZmx1c2goZmQsIFRD
SU9GTFVTSCkgPT0gLTEpIHsKICAgICAgICBwZXJyb3IoIm9wZW5zZXJpYWwoKTogdGNmbHVzaCgp
Iik7CiAgICAgICAgcmV0dXJuIDA7CiAgICB9CiAgICBpZiAodGNzZXRhdHRyKGZkLCBUQ1NBTk9X
LCAmYXR0cikgPT0gLTEpIHsKICAgICAgICBwZXJyb3IoImluaXRzZXJpYWwoKTogdGNzZXRhdHRy
KCkiKTsKICAgICAgICByZXR1cm4gMDsKICAgIH0KICAgIHJldHVybiBmZDsKfQoKCmludCBzZXRS
VFMoaW50IGZkLCBpbnQgbGV2ZWwpCnsKICAgIGludCBzdGF0dXM7CgogICAgaWYgKGlvY3RsKGZk
LCBUSU9DTUdFVCwgJnN0YXR1cykgPT0gLTEpIHsKICAgICAgICBwZXJyb3IoInNldFJUUygpOiBU
SU9DTUdFVCIpOwogICAgICAgIHJldHVybiAwOwogICAgfQogICAgaWYgKGxldmVsKQogICAgICAg
IHN0YXR1cyB8PSBUSU9DTV9SVFM7CiAgICBlbHNlCiAgICAgICAgc3RhdHVzICY9IH5USU9DTV9S
VFM7CiAgICBpZiAoaW9jdGwoZmQsIFRJT0NNU0VULCAmc3RhdHVzKSA9PSAtMSkgewogICAgICAg
IHBlcnJvcigic2V0UlRTKCk6IFRJT0NNU0VUIik7CiAgICAgICAgcmV0dXJuIDA7CiAgICB9CiAg
ICByZXR1cm4gMTsKfQoKCmludCBtYWluKCkKewogICAgaW50IGZkOwogICAgY2hhciAqc2VyaWFs
ZGV2ID0gIi9kZXYvdHR5VVNCMCI7CgogICAgZmQgPSBvcGVuc2VyaWFsKHNlcmlhbGRldik7CiAg
ICBpZiAoIWZkKSB7CiAgICAgICAgZnByaW50ZihzdGRlcnIsICJFcnJvciB3aGlsZSBpbml0aWFs
aXppbmcgJXMuXG4iLCBzZXJpYWxkZXYpOwogICAgICAgIHJldHVybiAxOwogICAgfQoKICAgIHNl
dFJUUyhmZCwxKTsKICAgIHVzbGVlcCgxMDAwMCk7ICAgICAgCiAgICBzZXRSVFMoZmQsIDApOwoK
ICAgIGNsb3Nlc2VyaWFsKGZkKTsKICAgIHJldHVybiAwOwp9

------=OPENWEBMAIL_ATT_0.638244222474412--
