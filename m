Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006Ab0EYReO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 13:34:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:46150 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1758624Ab0EYReM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 13:34:12 -0400
X-Authenticated: #20629184
X-Provags-ID: V01U2FsdGVkX1/kRkkxTjvk4h+FqTIdt0U9kiyefxDfq68R24kI7V
	X4HQjoBRK/nD86
Message-ID: <4BFC0A11.1030902@gmx.de>
Date: Tue, 25 May 2010 19:34:09 +0200
From: Johannes Bauer <dfnsonfsduifb@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.8.1.23) Gecko/20091110 Thunderbird/2.0.0.23 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: usbtmc makes Rigol DS1052E oscilloscope crash
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I'm experiencing trouble connecting to a Rigol DS1052E oscilloscope via
the usbtmc USB class driver. When requesting small amounts of data it
works quite nicely, but when requesting a large chunk (i.e. when
requesting the whole memory to be transferred), the read aborts, the
connection times out and ultimately this leads to the oscilloscope crashing.

The commands I'm executing in the example I have provided are:

Cmd: *IDN?
Rigol.Technologies,DS1052E,DS1ED120100155,00.02.04.00.00
Cmd: :WAVEFORM:POINTS:MODE?
MAXIMUM
Cmd: :RUN
Cmd: :FORC
Cmd: :CHAN1:MEMD?
1048576
Cmd: :WAV:DATA?

After the ":WAV:DATA?" command, the oscilloscope crashes, here's how it
looks before for those who are interested:
http://s1.directupload.net/file/d/2169/r3m4l97m_jpg.htm

And after:
http://s10.directupload.net/file/d/2169/egvgv7hq_jpg.htm

I've captured the USB traffic which is going on using usbmon, debugfs
and wireshark, it's a 5kB pcap file:
http://www.file-upload.net/download-2544840/usb_rigol.pcap.html

To further trace the problem, I've patched usbtmc.c to emit some more
debug output. Here's the patch:
http://pastebin.com/fMkA5xSJ

Here's what the extended dmesg output looks after I applied my patch
against 2.6.34 (I annotated it so that it is clear which output is
emitted after which read):
http://pastebin.com/CXRwxxe8

I really hope this can be resolved,
Kind regards,
Johannes
