Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab2CIQeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 11:34:07 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47995 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757946Ab2CIQeD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 11:34:03 -0500
MIME-Version: 1.0
In-Reply-To: <20120308184954.GA1275@kroah.com>
References: <CAOAMb1ASB0zznSSOAU9HgPNW2e=Do+8hSJ6JZ00DxtAxqsXyXQ@mail.gmail.com>
	<20120308184954.GA1275@kroah.com>
Date: Fri, 9 Mar 2012 17:34:03 +0100
Message-ID: <CACRpkdY3A_k_ywWgnFYG_3Jp+EssfULO0R59=GWUG2a0VS3--g@mail.gmail.com>
Subject: Re: [PATCH] Clear previous interrupts after fifo is disabled
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Chanho Min <chanho0207@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Alan Cox <alan@linux.intel.com>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        "Kim, Jong-Sung" <neidhard.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 7:49 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Feb 27, 2012 at 06:30:20PM +0900, Chanho Min wrote:
>> This is another workaroud of  'https://lkml.org/lkml/2012/1/17/104'
>> with additional analysis.Bootloader can transfer control to kernel and
>> there are some pending interrupts. In this case, RXFE of the flag
>> register is set by clearing FEN(LCRH) even if rx data remains in the
>> fifo. It seems that the fifo's status is initiailized. Interrupt
>> handler can not get any data from data register because of the below
>> break condtion.
>>
>> pl011_fifo_to_tty
>>  while (max_count--) {
>>    if (status & UART01x_FR_RXFE)
>>       break;
>
> This patch never seemed to be agreed on, so I'm not taking it.
>
> Can someone, if this is still needed, and everyone agrees on how to
> solve it, please send me the needed fix?

To me it seems Russell's patch solves part of the problem,
and Jong-Sung Kim's patch on top of that solves the entire
problem, but Chanho need to come back and tell whether
this is the case in practice.

Yours,
Linus Walleij
