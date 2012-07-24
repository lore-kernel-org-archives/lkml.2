Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab2GXX5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 19:57:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64750 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690Ab2GXX5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 19:57:41 -0400
MIME-Version: 1.0
In-Reply-To: <CANKRQni4SU=876iPtHJ2WC3Ub7QProJqHZ53Ru-n-njsdg8D5A@mail.gmail.com>
References: <1342000670-1005-1-git-send-email-tomoya.rohm@gmail.com>
	<201207111045.03275.arnd@arndb.de>
	<CANKRQni4SU=876iPtHJ2WC3Ub7QProJqHZ53Ru-n-njsdg8D5A@mail.gmail.com>
Date: Wed, 25 Jul 2012 08:57:41 +0900
Message-ID: <CANKRQnhcFr+e1H5p==UUTWfYb2nzdt8aVnOn2NvmYAXFiDxqew@mail.gmail.com>
Subject: Re: [PATCH] misc/pch_phub: Enable UART clock setting by module parameter
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Let me know this patch status.
If you have still any concern, let me know.

BTW, now I remember, Did you take part in LinuxConJapan last month ?
I also took part in this event as volunteer staff.
Additionally, I took charge of your session as time keeper.

Thanks in advance.
-- 
ROHM Co., Ltd.
tomoya

On Thu, Jul 12, 2012 at 9:54 AM, Tomoya MORINAGA <tomoya.rohm@gmail.com> wrote:
> On Wed, Jul 11, 2012 at 7:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> This looks like a rather nonscalable solution if you get to systems
>> with lots of clocks.
>
> This "clock" is internal clock, not external clock.
> This PacketHub provides clock to the UART module
> Both the PacketHub and the UART is in 1 chip LSI which is EG20T.
> So, selectable clock 1.8432MHz or 48MHz or 64MHz or 192MHz are enough.
>
>> Given that you are doing it for the uart clock, shouldn't that be
>> set from the uart driver using an ioctl like other serial ports do?
> PacketHub is not serial driver but special driver. So, ioctl doesn't
> suit PacketHub.
>
>> What would be the use case for an end user to override the module
>> parameter? Is it about platform specific settings or policy?
> I show use case.
> Currently, UART works with 1.8432MHz.
> Using this clock, as you know, maximum speed is 115k.
> A user wants to use 4M speed, the user need to modify pch_phun.c by hand.
> If this patch is applied, a user can specify uart_clock via a modules
> parameter and use 4M speed.
>
> My reference driver for this patch is drivers/tty/serial/pch_uart.c
> This driver can set uart_clock via a module parameter(user_uartclk).
>
> Thanks.
> --
> ROHM Co., Ltd.
> tomoya
