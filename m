Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab1GVUss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 16:48:48 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:40978 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab1GVUsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 16:48:47 -0400
MIME-Version: 1.0
In-Reply-To: <20110711135056.GT29245@infomag.iguana.be>
References: <20110711135056.GT29245@infomag.iguana.be>
Date: Fri, 22 Jul 2011 16:48:46 -0400
Message-ID: <CACqU3MUbStZ0M8g_AE1WppY5tpxfqDVdvJpj+U7KWJ3V9TBW-w@mail.gmail.com>
Subject: Re: [PATCH 0/11 v3] Generic Watchdog Timer Driver
From: Arnaud Lacombe <lacombar@gmail.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wolfram Sang <w.sang@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jul 11, 2011 at 9:50 AM, Wim Van Sebroeck <wim@iguana.be> wrote:
> Hi All,
>
> To reduce copying the same code over and over in each watchdog device driver, Alan Cox and myself constructed a new framework/API that consolidates the common watchdog timer driver functions.
> I incorporated the changes/feedback that I received from the second post.
>
> This framework/API consists of the following patches:
> part  1: Introduction of the WatchDog Timer Driver Core
> part  2: Add the basic ioctl functionality
> part  3: Add the WDIOC_KEEPALIVE ioctl
> part  4: Add the WDIOC_SETOPTIONS ioctl
> part  5: Add the WDIOC_SETTIMEOUT and WDIOC_GETTIMEOUT ioctl
> part  6: Add the Magic Close feature
> part  7: Add the nowayout feature
> part  8: Add support for a miscdev parent device
> part  9: Add support for extra ioctl calls
> part 10: Add the minimum and maximum timeout parameters.
> part 11: Remove llseek
>
> The code will also be added to linux-2.6-watchdog-next.
>
> Changes since V2:
> * all "flags" are unsigned
> * timeout values are also unsigned
> * removed unnececessary debugging
> * clean-up comments
> * the core will be in drivers/watchdog/ and not in drivers/watchdog/core/
>
I had the occasion to have a look to the code in -next this week, so
my comment will be based on this.

One thing which looked too constrained to me, is that the framework
only supports a for a single watchdog. While this is fine for most
board, I have an x86 based device which has 2 watchdog. This might be
silly, but that's what the hardware provide. The current wartchdog
framework would fail to adapt to this board. Moreover, one might think
to provide interface to fail-to-wire NICs device on top of the
watchdog framework. So at the end, it might be needed to be able to
register an infinite amount of watchdog. Though, I am not sure how it
would presented to userland, maybe something ala /dev/watchdog/[0-N].

Regards,
 - Arnaud

> Kind regards,
> Wim.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
