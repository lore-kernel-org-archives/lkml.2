Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab2GIS6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:58:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38648 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751614Ab2GIS6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:58:21 -0400
Date: Mon, 9 Jul 2012 14:58:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Clemens Ladisch <clemens@ladisch.de>
cc: linux-usb@vger.kernel.org, Udo van den Heuvel <udovdh@xs4all.nl>,
        Simon Jones <sijones2010@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: 3.4.4: disabling irq
In-Reply-To: <4FFAE2A5.2070701@ladisch.de>
Message-ID: <Pine.LNX.4.44L0.1207091451490.1954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, Clemens Ladisch wrote:

> (forwarded to linux-usb)
> 
> Udo van den Heuvel wrote:
> > Hello,
> >
> > One moment the box is runing OK.
> > One moment the 3.4.4 kernel decides to disable an interrupt.
> > Why?

The kernel disables IRQs when too many interrupts arrive too quickly.  
In general that means some device is generating an interrupt request
and it isn't getting handled by any driver.

> > Jul  8 07:43:49 box3 ntpd[5067]: parse: convert_rawdcf: INCOMPLETE DATA - time code only has 1 bits
> > Jul  8 07:44:53 box3 kernel: irq 18: nobody cared (try booting with the "irqpoll" option)
> > Jul  8 07:44:53 box3 kernel: Pid: 1501, comm: irq/18-ohci_hcd Tainted: G        W    3.4.4 #1

> ... and, with apparently the same mainboard:
> 
> Simon Jones wrote:
> > Hi,
> >
> > Am not sure where to start with getting help on an issue.
> >
> > Since buying my motherboard i have found the usb ports are pretty
> > unstable, and some devices work on usb2 some on usb3, after a while i
> > managed to work out which will work where and it's reasonably stable
> > now.
> >
> > Am on kernel 3.2.16 and tonight i thought i would try 3.4.4, it's all
> > been compiled and seemed fine until i ran mythtv and couldn't get a
> > smooth picture, then the tuner stopped responding and when looking in
> > to the logs it appears IRQ18 assigned to the usb chipset gets disabled
> > from what i can tell, it also causes a crash.
> >
> > Motherboard is Gigabyte GA-990XA-UD3
> > CPU is AMD Bulldozer 6 Core version
> >
> > I'll attach the 2 dmesg logs, one from 3.2 and other from 3.4,
> > hopefully someone can see what's wrong, there is a suggestion to boot
> > with irqpoll, but really wanted someone's opinion on this.

Simon's log shows a large of number of devices all using the same IRQ.  
A good place to start would be to unload or unbind the drivers for some
or all of the devices -- if that can be done before the IRQ is
disabled.  Maybe it will turn out that an individual device is
responsible for the problem.

Another possibility is that some other device is using that IRQ line 
without the kernel's knowledge.  That's not an easy sort of thing to 
track down, though.

In general, how easy is it to reproduce these problems?  Does the IRQ 
line always get disabled after the system has been up for a few 
seconds?

If it does, and if the problem is caused by a software change, git 
bisection might be the easiest way to track it down.

Alan Stern

