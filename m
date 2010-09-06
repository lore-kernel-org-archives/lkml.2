Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768Ab0IFV24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 17:28:56 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:59525 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755099Ab0IFV2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 17:28:52 -0400
X-Authenticated: #344999
X-Provags-ID: V01U2FsdGVkX1/0Np005HD0ojLg3PHaSkOIlaUjJutqCtP1Bu9J6R
	7YGM8AoddElyZP
From: Jan Kandziora <jjj@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: PROBLEM: additional serial ports on MS9830 board do not work (IRQ problems)
Date: Mon, 6 Sep 2010 23:28:47 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <201009052009.09743.jjj@gmx.de> <20100905233504.5000a308@lxorguk.ukuu.org.uk>
In-Reply-To: <20100905233504.5000a308@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201009062328.47475.jjj@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 6. September 2010 schrieb Alan Cox:
>
> I suspect you need a BIOS which has correct tables for IRQ routing.
>
> > Can you give me any useful pointers what to try next? Kernel
> > configuration is attached.
>
> Vendor for BIOS update would be the obvious starting point.
>
Ok, done. Now I have V3.2 instead of V3.0 and things have changed some way: if 
I enable only the first of the internal ports as 0x3f8/4, no tty shows up at 
all. If I enable the DB9 port as 0x2f8/3 and the first internal port as 
0x3f8/4, only the DB9 port shows up as ttyS1. Other permutations bring other 
oddities with some enabled ttys showing up, some not. (And the BIOS update 
broke LVDS. Hardware vendors make me sick...)


Aside from that, I noticed no difference. I filed a bug report at the 
manufacturer of that POS PC the board is inside but I doubt there will be any 
reaction, at least not in time.

Is there some tweaking I can try from within Linux? Some things I tried are:
==================
If I enable the DB9-Port as 0x3f8/4 and the first of the internal ports as 
0x3e8/11, I get the following:

<6>serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
<6>00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>00:08: ttyS2 at I/O 0x3e8 (irq = 11) is a 16550A

No other tty messages. I can receive is some data from ttyS2, but it is 
broken. At the same time ttyS0, the DB9 port, works without problems. That's 
the same as before the BIOS update.

==================
If I enable the DB9-Port as 0x3f8/4 and the first of the internal ports as 
0x3e8/4, I get the following:

<6>serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>serial8250: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A
<6>00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>00:08: ttyS2 at I/O 0x3e8 (irq = 4) is a 16550A

and later, when /dev/ttyS2 is accessed, again:

<3>irq 4: nobody cared (try booting with the "irqpoll" option)
<4>Pid: 3798, comm: X Not tainted 2.6.35.4 #1
<4>Call Trace:
<4> [<c103a950>] __report_bad_irq+0x2e/0x6f
<4> [<c103aa81>] note_interrupt+0xf0/0x147
<4> [<c103b042>] handle_level_irq+0x6d/0x99
<4> [<c1003b32>] handle_irq+0x1a/0x20
<4> [<c1003883>] do_IRQ+0x33/0x75
<4> [<c1002b69>] common_interrupt+0x29/0x30
<4> [<c101d8c8>] ? __do_softirq+0x34/0xca
<4> [<c101d983>] do_softirq+0x25/0x2a
<4> [<c101da43>] irq_exit+0x28/0x57
<4> [<c10038b0>] do_IRQ+0x60/0x75
<4> [<c1002b69>] common_interrupt+0x29/0x30
<4> [<c103007b>] ? timecompare_offset+0x9c/0x2c6
<4> [<c103a3ec>] ? __setup_irq+0x1d8/0x259
<4> [<c103a510>] request_threaded_irq+0xa3/0xd0
<4> [<c119f173>] ? serial8250_interrupt+0x0/0xb2
<4> [<c119ec07>] serial8250_startup+0x3f5/0x53d
<4> [<c119bfa9>] uart_startup+0x6e/0x101
<4> [<c119ca89>] uart_open+0xff/0x2ac
<4> [<c114fee7>] ? tty_init_dev+0xb7/0xf0
<4> [<c11501ab>] tty_open+0x28b/0x354
<4> [<c106336e>] chrdev_open+0xc0/0xd7
<4> [<c1060141>] __dentry_open+0xd1/0x1a7
<4> [<c10602ad>] nameidata_to_filp+0x29/0x3d
<4> [<c10632ae>] ? chrdev_open+0x0/0xd7
<4> [<c1068a92>] do_last+0x3d1/0x4d1
<4> [<c106a34f>] do_filp_open+0x38c/0x41e
<4> [<c10124c0>] ? do_page_fault+0x2a1/0x2cf
<4> [<c105ff43>] do_sys_open+0x48/0x116
<4> [<c1060053>] sys_open+0x1e/0x26
<4> [<c1002650>] sysenter_do_call+0x12/0x26
<4> [<c1300000>] ? dump_stack+0x40/0x60
<3>handlers:
<3>[<c119f173>] (serial8250_interrupt+0x0/0xb2)
<0>Disabling IRQ #4

==================
If I enable the DB9-Port as 0x3f8/4 and the second of the internal ports as 
0x2f8/3, I get the following:

<6>serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
<6>00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
<6>00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A

and later, when /dev/ttyS1 is accessed, and I touch the screen:

<4>ttyS1: 1 input overrun(s)

and no data at all.


Kind regards

	Jan
