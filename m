Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab1IENL1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 09:11:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55541 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625Ab1IENLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 09:11:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd-3NVWhU73cri5bj8aT7hGLEVZC9EMX6dshLp6o40acnw@mail.gmail.com>
References: <CAKYAXd_QrgHHdiev-Vxt=FrwkJg-3qfjxzqkPmgLbwZ=U4358Q@mail.gmail.com>
	<CACRpkdYkk+W98RoCCwRWXyF+_1_H9gujxHLCPnqtPMn401fZvg@mail.gmail.com>
	<CAKYAXd8VUAZ1gL-MZx7y6+nORJ4m2U+SFyzF2duB-9NUcbqBQw@mail.gmail.com>
	<CAKnu2Mq=4Y=hiv-R7PvPyYCYmo9enu6_FPcoT089LxSa=_xMhw@mail.gmail.com>
	<CAKYAXd-3NVWhU73cri5bj8aT7hGLEVZC9EMX6dshLp6o40acnw@mail.gmail.com>
Date: Mon, 5 Sep 2011 15:11:25 +0200
Message-ID: <CACRpkdYhGCBX5soSY6Dn5jK3jjZ3A0XXX=_Ffr+3auHJHWphvA@mail.gmail.com>
Subject: Re: RFC : mmc : Use wait_for_completion_timeout() instead of
 wait_for_completion in case of multiple write blocks.
From: Linus Walleij <linus.walleij@linaro.org>
To: NamJae Jeon <linkinjeon@gmail.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Kyungmin Park <kmpark@infradead.org>,
        Sebastian Rasmussen <Sebastian.Rasmussen@stericsson.com>,
        Ulf Hansson <Ulf.Hansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 5, 2011 at 2:30 AM, NamJae Jeon <linkinjeon@gmail.com> wrote:

>>> host
>>> controller can just know whether card is finish to program to use busy
>>> line. If unstable card is holding busy line while writing using DMA,
>>> hang problem will happen by wait_for_completion.
>>> so I think that mmc driver need some exception to avoid this problem.
>>
>> Yes you can add a timeout in the driver itself. Just set up
>> a common timer, no big deal.
>
> I didn't decide, how much timeout should I add ? first, I think that I
> try to add timeout_ns * the number of blocks. but If timeout_ns is 1.6
> sec and the number of blocks is 512, the timeout will be very long. or
> If I just add 10*HZ(10 sec), Is it proper ?

The timeout_ns comes from the card CSD bits 112 thru 119.
"Data read access-time 1".

According to the spec this "Defines the asynchronous part of the data
access time."

I don't know how to interpret this, but it says nothing about the
number of blocks involved and nor does the drivers we have
interpret it that way.

This time AFAICT is for the entire transaction, not per-block.

In the mmci driver we calculate the clock cycles required for
timeout_ns and the number of clock cycles in
timeout_clks and that's it. That's the timeout for the
entire operation. This is how all drivers work I think.

Yours,
Linus Walleij
