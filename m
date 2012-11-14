Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab2KNAsS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:48:18 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57638 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756041Ab2KNAsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:48:15 -0500
Date: Tue, 13 Nov 2012 16:48:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Constantine Shulyupin <const@makelinux.com>
Cc: linux-kernel@vger.kernel.org, celinux-dev@lists.celinuxforum.org
Subject: Re: [PATCH] LDT - Linux Driver Template
Message-ID: <20121114004811.GA29220@kroah.com>
References: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
 <20121113190123.GA32271@kroah.com>
 <CAE7jHC_bTi7bNwTyPh=wsstGUFegisDUtt2QvDeAwh94AMoUAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE7jHC_bTi7bNwTyPh=wsstGUFegisDUtt2QvDeAwh94AMoUAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 02:14:58AM +0200, Constantine Shulyupin wrote:
> On Tue, Nov 13, 2012 at 9:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> +#define pr_debug_hex(h)      pr_debug("%s:%d %s %s = 0x%lX\n", \
> >> +     __file__, __LINE__, __func__, #h, (long int)h)
> >
> > This is not needed at all, just use the proper printk() attribute.
> 
> Macro above allows tidy tracing code:
> 
>         pr_debug_hex(ioread8(port_ptr + UART_IER));
>         pr_debug_hex(ioread8(port_ptr + UART_IIR));
>         pr_debug_hex(ioread8(port_ptr + UART_FCR));
>         pr_debug_hex(ioread8(port_ptr + UART_LCR));
>         pr_debug_hex(ioread8(port_ptr + UART_MCR));
>         pr_debug_hex(ioread8(port_ptr + UART_LSR));
>         pr_debug_hex(ioread8(port_ptr + UART_MSR));
> 
> Without that macro, code above should be rewritten with pr_debug (or printk) as:
> 
>         pr_debug("UART_IER=0x%02X\n", ioread8(port_ptr + UART_IER));
>         pr_debug("UART_IIR=0x%02X\n", ioread8(port_ptr + UART_IIR));
>         pr_debug("UART_FCR=0x%02X\n", ioread8(port_ptr + UART_FCR));
>         pr_debug("UART_LCR=0x%02X\n", ioread8(port_ptr + UART_LCR));
>         pr_debug("UART_MCR=0x%02X\n", ioread8(port_ptr + UART_MCR));
>         pr_debug("UART_LSR=0x%02X\n", ioread8(port_ptr + UART_LSR));
>         pr_debug("UART_MSR=0x%02X\n", ioread8(port_ptr + UART_MSR));
> 
> That is less readable and less supportable.

What better is to not do foolish stuff like this at all :)

If you need tracing, use the in-kernel tracing framework, don't roll
your own.

> I prefer the fist case.

I prefer the flower case :)

> Actually I use a lot shorter macro:
> #define traceh(h)   printk("%s = 0x%lX\n", #h, (long int)h)
> 
> What is you opinion? Which method is better?

Again, neither, don't clutter your code up with unneeded things like
this.

greg k-h
