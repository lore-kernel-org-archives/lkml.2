Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755058Ab1HaCp0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 22:45:26 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47913 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab1HaCpX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 22:45:23 -0400
MIME-Version: 1.0
In-Reply-To: <1314653699.5939.299.camel@rex>
References: <1314647628-21707-1-git-send-email-bryan.wu@canonical.com>
 <alpine.LFD.2.00.1108291630020.20358@xanadu.home> <1314653699.5939.299.camel@rex>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 31 Aug 2011 10:45:03 +0800
X-Google-Sender-Auth: FAV9pauZnVlNCS0IpxoWdy-0Ngc
Message-ID: <CAK5ve-+J3hzVB=_b0AOJ-Q1LYewahVraMti=y=6AaQy3+iy+rg@mail.gmail.com>
Subject: Re: [PATCH] leds: kill CONFIG_LEDS_CLASS option
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 5:34 AM, Richard Purdie <rpurdie@rpsys.net> wrote:
> On Mon, 2011-08-29 at 16:34 -0400, Nicolas Pitre wrote:
>> On Tue, 30 Aug 2011, Bryan Wu wrote:
>>
>> > Almost all the new leds driver and trigger driver are depends on
>> > CONFIG_LED_CLASS, so there is no such user with CONFIG_NEW_LEDS=y
>> > and CONFIG_LED_CLASS=n. Moreover, lots of API functions in led-class.c
>> > are very common and should be built-in when CONFIG_NEW_LEDS=y.
>> >
>> > Obviously, CONFIG_LEDS_CLASS is pointless. This patch kills it and
>> > also updates defconfigs which contains CONFIG_LEDS_CLASS.
>> >
>> > Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>> > ---
>
> Looking at the code I'm a little concerned to see the direction this is
> going. There was originally a reason that there were two options, it was
> related to being able to compile as much of the LED code as a module as
> possible.
>

I quite understand the original reason for 2 options, but I failed to
see any user of CONFIG_NEW_LEDS=y and CONFIG_LEDS_CLASS=n.

> It looks like commit 5ada28bf76752e33dce3d807bf0dfbe6d1b943ad changed
> the tristate to a bool at which point the separate option obviously
> becomes pointless.
>

Exactly, this patch added some function API which are used very widely
as default LEDS driver behavior in some drivers.

> Rather than accept the current direction and force everything builtin,
> I'd much rather this code became modular capable again. There is no good
> reason we should be forced to build everything into a kernel.
>

OK, cool. I'd like to help and could you please also give some
comments about my ledtrig-cpu driver in this patchset?

Thanks a lot,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
