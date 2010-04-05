Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755349Ab0DEQSh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 12:18:37 -0400
Received: from web94902.mail.in2.yahoo.com ([203.104.17.140]:44832 "HELO
	web94902.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754978Ab0DEQSc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 12:18:32 -0400
Message-ID: <570950.67367.qm@web94902.mail.in2.yahoo.com>
X-YMail-OSG: lUViyaMVM1kuubydZleeUfrqmAW3cvMGiz2GSBiVzPCtXcC
 GDiWMvLUx
X-RocketYMMF: pavan_savoy
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Mon, 5 Apr 2010 21:48:27 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: Re: [PATCH] drivers:staging: sources for ST core
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@suse.de>, Marcel Holtmann <marcel@holtmann.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100402002731.1b8fd3b0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Fri, 2/4/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Subject: Re: [PATCH] drivers:staging: sources for ST core
> To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Cc: "Greg KH" <gregkh@suse.de>, "Marcel Holtmann" <marcel@holtmann.org>, linux-kernel@vger.kernel.org
> Date: Friday, 2 April, 2010, 4:57 AM
> Sorry but I can't make head or tail
> of this and the code flow you are
> trying to achieve.
> 
> The usual way you do stuff is to put per device stuff in a
> per device
> struct, driver wide stuff in a driver struct (or static
> variables) and
> then run everything from the device end.
> 
> I'd expect a low level driver to do something like
> 
> 
>     probe()
>         create device entry
>         initialise device (eg
> download firmware)
>         register itself with
> anything higher level
> 

What I am trying to achieve is something like this,

HCI-core	V4L2-radio	Char-device=/dev/tigps for fops
 ^		^		^
 |		|		|
 |		|		|
BT		FM		GPS [these register themselves to ST]
\		 |		 /
 \		 |		/
  \		 |		/
    Shared Transport Ldisc driver
  		|
  	TTY Layer	<-- UART driver has already registered.

So, when a BT device try and registers itself to ST (shared transport) driver, I need to toggle chip enable line and 'download_firmware', and in case another _register from FM or GPS happens at  the same time, I need to signal it pending, and call a callback upon completion of firmware download.

Now which are to be identified as per-device or bus or driver ?
Because when an st_register is called, I need to do some tty_* operations from the ldisc driver itself - i.e I cannot embed tty into any of BT, FM or GPS per-device structures.

I also expose a st_write function, where in any of BT, FM and GPS driver upon being ready (fw download completed) sends across an SKB, which I queue up and write.

All of what I wanted to do, could not be done when I tried ST ldisc as a bus and each of BT, FM and GPS as per-device structs registering with type ST as bus.
So again, Now which are to be identified as per-device or bus or driver ?



      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
