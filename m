Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab2CHSuD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:50:03 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38614 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754Ab2CHSt7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:49:59 -0500
Date: Thu, 8 Mar 2012 10:49:54 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Chanho Min <chanho0207@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
Message-ID: <20120308184954.GA1275@kroah.com>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 06:30:20PM +0900, Chanho Min wrote:
> This is another workaroud of  'https://lkml.org/lkml/2012/1/17/104'
> with additional analysis.Bootloader can transfer control to kernel and
> there are some pending interrupts. In this case, RXFE of the flag
> register is set by clearing FEN(LCRH) even if rx data remains in the
> fifo. It seems that the fifo's status is initiailized. Interrupt
> handler can not get any data from data register because of the below
> break condtion.
> 
> pl011_fifo_to_tty
>  while (max_count--) {
>    if (status & UART01x_FR_RXFE)
> 	break;

This patch never seemed to be agreed on, so I'm not taking it.

Can someone, if this is still needed, and everyone agrees on how to
solve it, please send me the needed fix?

thanks,

greg k-h
