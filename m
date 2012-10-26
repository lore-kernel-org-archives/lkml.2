Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966638Ab2JZV5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 17:57:34 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:34360 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757109Ab2JZV5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 17:57:32 -0400
MIME-Version: 1.0
In-Reply-To: <20121026151902.0a382d16@pyramind.ukuu.org.uk>
References: <alpine.LFD.2.02.1210221633450.28146@nightowl>
	<20121023110133.62bed522@pyramind.ukuu.org.uk>
	<CAJ0e-Fofs48N9VnYr1_8Kch6+yHjGx9iCWBRtRsqpD-B_rWutQ@mail.gmail.com>
	<20121026151902.0a382d16@pyramind.ukuu.org.uk>
Date: Fri, 26 Oct 2012 14:57:31 -0700
Message-ID: <CAJ0e-Fqzq6s6H=9CMpqJKug2=oR89_qw_52Yz-ihJd-8Bc-_+Q@mail.gmail.com>
Subject: Re: [PATCH] serial: 8250 check iir rdi in interrupt
From: Min Zhang <mzhang@mvista.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: gregkh@linuxfoundation.org, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 7:19 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> So we only need to check this in serial8250_handle_irq when IIR indicates
> a data timeout interrupt ?
>
> Can we do
>
>         if ((iir & 0x0F) == 0x0C) {
>                 /* Expensive RDI check */
>         }
>
>
>
> Alan

Checking data timeout interrupt is only for "too much work for irq"
problem. There is another console freeze problem which is caused by
reading receive FIFO when there is no RDI interrupt, such as during
THRI transmit interrupt, so no timeout interrupt. This time one has to
check two both IIR and LSR. After all these checking, it becomes the
original patch anyway.

I am posting another simpler revision to exclude timer handler from
this workaround, and make this workaround default off and inline.
