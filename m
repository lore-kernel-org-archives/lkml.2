Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753381Ab2B0KpX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 05:45:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42697 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753098Ab2B0KpN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 05:45:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.202.97 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
Date: Mon, 27 Feb 2012 11:45:12 +0100
Message-ID: <CACRpkdZe5caTr5LLWm7J5NfsWegoih4yQx+GV=H5brdPSUvEsQ@mail.gmail.com>
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Min <chanho0207@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 10:30 AM, Chanho Min <chanho0207@gmail.com> wrote:

> This is another workaroud of  'https://lkml.org/lkml/2012/1/17/104'
> with additional analysis.Bootloader can transfer control to kernel and
> there are some pending interrupts. In this case, RXFE of the flag
> register is set by clearing FEN(LCRH) even if rx data remains in the
> fifo. It seems that the fifo's status is initiailized. Interrupt
> handler can not get any data from data register because of the below
> break condtion.
>
> pl011_fifo_to_tty
>  while (max_count--) {
>   if (status & UART01x_FR_RXFE)
>        break;
>
> Then, Rx interrupt is never cleared. cpu is looping in ISR. System is
> hang. If we don't guarantee that no interrupt is pended until fifo is
> disabled by calling 'writew(0, uap->port.membase + uap->lcrh_rx)',
> this misbehave of the interrupt handelr can be occurred. So, All
> pending interrupts should be cleared just after fifo is disabled under
> the protection from interrupt. Also,'clear error interrupts' routine
> can be removed becuase all interrupts are cleared before.
>
> Signed-off-by: Chanho Min <chanho.min@lge.com>

Looks correct to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
