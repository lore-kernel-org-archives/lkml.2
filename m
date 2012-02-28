Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2B1JqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:46:17 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33952 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665Ab2B1JqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:46:13 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of chanho0207@gmail.com designates 10.50.188.167 as permitted sender) smtp.mail=chanho0207@gmail.com; dkim=pass header.i=chanho0207@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120228092140.GD18045@n2100.arm.linux.org.uk>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
	<20120227104858.GR22562@n2100.arm.linux.org.uk>
	<20120227110204.GA30199@n2100.arm.linux.org.uk>
	<CAOAMb1BjC2bF=rpJAhRUrB_U2mp8HGWxfcp+=TZ1etWzjUEwig@mail.gmail.com>
	<20120228083545.GA18045@n2100.arm.linux.org.uk>
	<CAOAMb1CJ=G45G3JsxwP23GSdEOnDmY5xVoQmWLXaKJJv2cLOLg@mail.gmail.com>
	<20120228092140.GD18045@n2100.arm.linux.org.uk>
Date: Tue, 28 Feb 2012 18:46:12 +0900
Message-ID: <CAOAMb1Cqfrk-b-yd1CMt2Hac7_j3i6WL8D8yQJDWjg_S18dAsw@mail.gmail.com>
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
From: Chanho Min <chanho0207@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Because the flags are manipulated to give the illusion of a one byte
> FIFO, as stated in the TRM.
Yes. It is the problem that rx interrupt is pended with this status as
I mentioned.

> And we don't set the mask register to 1 until later.
In the last part of startup, set to 1. Interrupt can be occurred just after it.

uap->im = UART011_RTIM;
if (!pl011_dma_rx_running(uap))
 uap->im |= UART011_RXIM;
 writew(uap->im, uap->port.membase + UART011_IMSC);

> But we want to do the transmit interrupt provocation with the FIFO disabled.
I know. It's test only.
