Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965018Ab2B1K1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 05:27:19 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46777 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab2B1K1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 05:27:17 -0500
Date: Tue, 28 Feb 2012 10:23:37 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Chanho Min <chanho0207@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
Message-ID: <20120228102337.GF18045@n2100.arm.linux.org.uk>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com> <20120227104858.GR22562@n2100.arm.linux.org.uk> <20120227110204.GA30199@n2100.arm.linux.org.uk> <CAOAMb1BjC2bF=rpJAhRUrB_U2mp8HGWxfcp+=TZ1etWzjUEwig@mail.gmail.com> <20120228083545.GA18045@n2100.arm.linux.org.uk> <CAOAMb1CJ=G45G3JsxwP23GSdEOnDmY5xVoQmWLXaKJJv2cLOLg@mail.gmail.com> <20120228092140.GD18045@n2100.arm.linux.org.uk> <CAOAMb1Cqfrk-b-yd1CMt2Hac7_j3i6WL8D8yQJDWjg_S18dAsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOAMb1Cqfrk-b-yd1CMt2Hac7_j3i6WL8D8yQJDWjg_S18dAsw@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 06:46:12PM +0900, Chanho Min wrote:
> > Because the flags are manipulated to give the illusion of a one byte
> > FIFO, as stated in the TRM.
> Yes. It is the problem that rx interrupt is pended with this status as
> I mentioned.

Which is why my patch explicitly clears the receive interrupt status
before requesting the interrupt.  Have you read my patch?
 
> > And we don't set the mask register to 1 until later.
> In the last part of startup, set to 1. Interrupt can be occurred just
> after it.
> 
> uap->im = UART011_RTIM;
> if (!pl011_dma_rx_running(uap))
>  uap->im |= UART011_RXIM;
>  writew(uap->im, uap->port.membase + UART011_IMSC);
> 
> > But we want to do the transmit interrupt provocation with the FIFO disabled.
> I know. It's test only.

Wrong, it's fundamental to the UARTs operation.
