Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762172Ab0J2Xyk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 19:54:40 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50568 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab0J2Xyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 19:54:38 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Writing a console/tty driver -- how to use tty_port?
Date: Sat, 30 Oct 2010 01:55:13 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Timur Tabi <timur@freescale.com>, gregkh <gregkh@suse.de>,
        lkml <linux-kernel@vger.kernel.org>
References: <4CC893CD.7020701@freescale.com> <201010282257.33898.arnd@arndb.de> <20101028231129.55b29420@pyx>
In-Reply-To: <20101028231129.55b29420@pyx>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010300155.13185.arnd@arndb.de>
X-Provags-ID: V02:K0:OeMUtrVBGyV8IPjW+/IIUm6SJfV67FbwpLZTXsqk+wF
 74DQ5d8pHEWE0p+rPrgfjtnulPMQLuuJplbNrg4HPG6NGG01kL
 5kDDTDFot6hU2hbe0ud6PItKJTircVyr7CxCUX2Djx1BC/PN8h
 fc8JWlMXDt4Fm7enhZHL5ctJUZ2kvTDK+SfKjLqvmJiOZkSnzd
 8WHIflK5CPhVji8NrUzPg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 October 2010, Alan Cox wrote:
> On Thu, 28 Oct 2010 22:57:33 +0200
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Wednesday 27 October 2010 23:04:13 Timur Tabi wrote:
> > > Do you have an updated version of Tiny TTY that uses tty_port structures?  I'm
> > > trying to write a new TTY driver for a device that is not a UART, and I'm having
> > > a hard time finding a good example.  I suspect I need to understand the tty_port
> > > structure, but I can't find any documentation for it.
> > 
> > If the device is not a UART, the best option may be to make the driver
> > a backend to the hvc driver, like e.g. drivers/char/hvc_tile.c.
> > 
> > This works for all devices with or without interrupts that don't need
> > to set up the communication parameters but simply provide a read/write
> > character interface.
> 
> I really don't understand the love of hvc when the hvc drivers seem to be
> bigger than native tty_port code and haul a whole blob of extra midlayer
> glue into the system.
> 

Two reasons for me:

* It does all the timers for the tty device to poll reads and retry writes.
If someone writes similar code from scratch, they most likely get it wrong.

* It's about the simplest interface you can imagine for a new backend driver,
only register a data structure with two function pointers!

	Arnd

