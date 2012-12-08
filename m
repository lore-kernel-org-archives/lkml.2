Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab2LHRCM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 12:02:12 -0500
Received: from plane.gmane.org ([80.91.229.3]:50057 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964984Ab2LHRCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 12:02:10 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Woody Wu <narkewoody@gmail.com>
Subject: Re: 8250 UART doesn't work
Date: Sat, 8 Dec 2012 17:01:54 +0000 (UTC)
Message-ID: <slrnkc6si6.3do.narkewoody@zuhnb712.local.com>
References: <slrnkc0jqu.4ir.narkewoody@zuhnb712.local.com>
 <50C0E737.2000201@zytor.com> <slrnkc2o7b.2ck.narkewoody@zuhnb712.local.com>
 <20121207100438.136dd968@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: 119.142.52.50
User-Agent: slrn/0.9.9p1 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> The UART controller is EXAR ST16C554D.  It claims as a 16550
>> compatible controller. Each ST16C554D module contains 4 UART, each of
>> them can be selected via two chip select pad. I think the board
>> hardware, via a CPLD, make the chip selection transparent to the CPU, so
>> by a 5-bit address, CPU can addressing individual 8 16550 compatible
>> registers of each UART.
>
> The EXAR should work. Make sure you have all the addressing and setup
> right would be my first suggestion - then poke at the registers by hand
> and double check.
>
> Alan

Do you think my iotype (UPIO_MEM) and flags ((UPF_BOOT_AUTOCONF |
UPF_IOREMAP | UPF_SHARE_IRQ)) settings are normal in a ARM board?

In the same directory with the 8250.c driver source, I foudn a 16C554
ports definition file 8250_exar_st16c554.c, in which the UART
definitions are quite different with that in my case:

#define PORT(_base,_irq)				\
	{						\
		.iobase		= _base,		\
		.irq		= _irq,			\
		.uartclk	= 1843200,		\
		.iotype		= UPIO_PORT,		\
		.flags		= UPF_BOOT_AUTOCONF,	\
	}

static struct plat_serial8250_port exar_data[] = {
	PORT(0x100, 5),
	PORT(0x108, 5),
	PORT(0x110, 5),
	PORT(0x118, 5),
	{ },
};

You see this file use UPIO_PORT as iotype and provide not mapbase but
iobase.

Which kind of configuration is right for ARM?  I think the
8250_exar_st16c554.c is for ISA bus board and hence is not suit to me,
but I am not sure my understanding is right. Please give me some
backgroud information on this field.

Thanks.


-- 
woody
I can't go back to yesterday - because I was a different person then.

