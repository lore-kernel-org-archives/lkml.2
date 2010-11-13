Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755844Ab0KMXun (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 18:50:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42668 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab0KMXum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 18:50:42 -0500
Date: Sat, 13 Nov 2010 15:49:16 -0800
From: Greg KH <gregkh@suse.de>
To: Lawrence Rust <lawrence@softsystem.co.uk>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/19] 8250: Fix tcsetattr to avoid ioctl(TIOCMIWAIT)
	hang
Message-ID: <20101113234916.GA1253@suse.de>
References: <20101112213215.GB9294@kroah.com> <1289598066-10112-11-git-send-email-gregkh@suse.de> <AANLkTi=OrD-icAD7Nv5oDrVBekEFMGRSoApWytWgnDbT@mail.gmail.com> <20101113144954.GA29977@suse.de> <1289676127.2641.3.camel@gagarin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289676127.2641.3.camel@gagarin>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 13, 2010 at 08:22:07PM +0100, Lawrence Rust wrote:
> On Sat, 2010-11-13 at 06:49 -0800, Greg KH wrote:
> > On Sat, Nov 13, 2010 at 07:18:30AM +0300, Alexey Zaytsev wrote:
> > > Hi.
> > > 
> > > This one kills the serial console for me. Luckily, in qemu:
> > > 
> > > (gdb) bt
> > > #0  __const_udelay (xloops=4295000) at arch/x86/lib/delay.c:117
> > > #1  0xc137ab7c in panic (fmt=0xc147f8e1 "Attempted to kill the idle task!")
> > >     at kernel/panic.c:151
> > > #2  0xc1020731 in do_exit (code=9) at kernel/exit.c:915
> > > #3  0xc100476a in oops_end (flags=70, regs=<value optimized out>, signr=9)
> > >     at arch/x86/kernel/dumpstack.c:265
> > > #4  0xc1014317 in no_context (regs=0xc14ebe68, error_code=<value
> > > optimized out>,
> > >     address=192) at arch/x86/mm/fault.c:673
> > > #5  0xc1014411 in __bad_area_nosemaphore (regs=0xc14ebe68,
> > >     error_code=<value optimized out>, address=192, si_code=196609)
> > >     at arch/x86/mm/fault.c:739
> > > #6  0xc1014426 in bad_area_nosemaphore (regs=0x418958, error_code=81,
> > >     address=3238124885) at arch/x86/mm/fault.c:746
> > > #7  0xc101475a in do_page_fault (regs=0xc14ebe68, error_code=0)
> > >     at arch/x86/mm/fault.c:1070
> > > #8  0xc137ced9 in ?? () at arch/x86/kernel/entry_32.S:1265
> > > #9  0xc11db236 in list_empty (head=0xc0) at include/linux/list.h:182
> > > #10 0xc11db374 in waitqueue_active (q=0x98) at include/linux/wait.h:115
> > > #11 0xc11dea4e in serial8250_do_set_termios (port=0xc1c31320,
> > > termios=0xc14ebf2c,
> > >     old=0xc1c31240) at drivers/serial/8250.c:2349
> > > #12 0xc11decb6 in serial8250_set_termios (port=0xc1c31320, termios=0xc14ebf2c,
> > >     old=0xc1c31240) at drivers/serial/8250.c:2424
> > > #13 0xc11da10b in uart_set_options (port=0xc1c31320, co=0xc164f0a0, baud=9600,
> > >     parity=110, bits=8, flow=110) at drivers/serial/serial_core.c:1935
> > > #14 0xc1684d30 in serial8250_console_setup (co=0xc164f0a0, options=0x0)
> > >     at drivers/serial/8250.c:2864
> > > #15 0xc101e46f in register_console (newcon=0xc164f0a0) at kernel/printk.c:1300
> > > #16 0xc1684d5e in serial8250_console_init () at drivers/serial/8250.c:2889
> > > #17 0xc1683da0 in console_init () at drivers/tty/tty_io.c:3208
> > > #18 0xc166b7ba in start_kernel () at init/main.c:635
> > > #19 0xc166b0b7 in i386_start_kernel () at arch/x86/kernel/head32.c:75
> > > #20 0x00000000 in ?? ()
> > > (gdb) p up->port.state
> > > $13 = (struct uart_state *) 0x0
> > > 
> > 
> > Ick.
> > 
> > Lawrence, any ideas?  If not, I'm going to have to revert this patch
> > from the tree.
> 
> Maybe best to pull the patch for now and have a re-think.  Shame, it
> seemed so easy and the fix works for me with a simple modem input.  I'll
> re-submit later..

Linus has now reverted it in his tree.

thanks,

greg k-h
