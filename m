Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab2KNAPA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 19:15:00 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:47381 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066Ab2KNAO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 19:14:59 -0500
MIME-Version: 1.0
In-Reply-To: <20121113190123.GA32271@kroah.com>
References: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
	<20121113190123.GA32271@kroah.com>
Date: Wed, 14 Nov 2012 02:14:58 +0200
X-Google-Sender-Auth: atf-CG3CCBp40u8Zb1svAHlFFXs
Message-ID: <CAE7jHC_bTi7bNwTyPh=wsstGUFegisDUtt2QvDeAwh94AMoUAQ@mail.gmail.com>
Subject: Re: [PATCH] LDT - Linux Driver Template
From: Constantine Shulyupin <const@makelinux.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, celinux-dev@lists.celinuxforum.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 9:01 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> +#define pr_debug_hex(h)      pr_debug("%s:%d %s %s = 0x%lX\n", \
>> +     __file__, __LINE__, __func__, #h, (long int)h)
>
> This is not needed at all, just use the proper printk() attribute.

Macro above allows tidy tracing code:

        pr_debug_hex(ioread8(port_ptr + UART_IER));
        pr_debug_hex(ioread8(port_ptr + UART_IIR));
        pr_debug_hex(ioread8(port_ptr + UART_FCR));
        pr_debug_hex(ioread8(port_ptr + UART_LCR));
        pr_debug_hex(ioread8(port_ptr + UART_MCR));
        pr_debug_hex(ioread8(port_ptr + UART_LSR));
        pr_debug_hex(ioread8(port_ptr + UART_MSR));

Without that macro, code above should be rewritten with pr_debug (or printk) as:

        pr_debug("UART_IER=0x%02X\n", ioread8(port_ptr + UART_IER));
        pr_debug("UART_IIR=0x%02X\n", ioread8(port_ptr + UART_IIR));
        pr_debug("UART_FCR=0x%02X\n", ioread8(port_ptr + UART_FCR));
        pr_debug("UART_LCR=0x%02X\n", ioread8(port_ptr + UART_LCR));
        pr_debug("UART_MCR=0x%02X\n", ioread8(port_ptr + UART_MCR));
        pr_debug("UART_LSR=0x%02X\n", ioread8(port_ptr + UART_LSR));
        pr_debug("UART_MSR=0x%02X\n", ioread8(port_ptr + UART_MSR));

That is less readable and less supportable.

I prefer the fist case.

Actually I use a lot shorter macro:
#define traceh(h)   printk("%s = 0x%lX\n", #h, (long int)h)

What is you opinion? Which method is better?
Thank you.
