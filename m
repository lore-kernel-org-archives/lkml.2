Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab1I3JKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 05:10:09 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36513 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab1I3JKG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 05:10:06 -0400
MIME-Version: 1.0
In-Reply-To: <20110929080753.GC23944@n2100.arm.linux.org.uk>
References: <1315249786-15387-1-git-send-email-bryan.wu@canonical.com>
 <1315252298.1243.21.camel@ted> <20110929080753.GC23944@n2100.arm.linux.org.uk>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 30 Sep 2011 17:09:45 +0800
X-Google-Sender-Auth: Cq8IWyI5EVurpH-DzZcttOEynH8
Message-ID: <CAK5ve-KHZYoEyYEZP51oqXb6Vu3enfFFaaxx6SGzpU_eN_K_kw@mail.gmail.com>
Subject: Re: [PATCH 1/2] leds-class: change back LEDS_CLASS to tristate
 instead of bool
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Richard Purdie <richard.purdie@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linus.walleij@linaro.org,
        akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 4:07 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Mon, Sep 05, 2011 at 08:51:38PM +0100, Richard Purdie wrote:
>> On Tue, 2011-09-06 at 03:09 +0800, Bryan Wu wrote:
>> > LEDS_CLASS is required by leds and trigger drivers, but we can build it
>> > as module. So change this option back as tristate and treak the help
>> > message as well.
>> >
>> > Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
>>
>> Acked-by: Richard Purdie <rchard.purdie@linuxfoundation.org>
>>
>> > ---
>> >  drivers/leds/Kconfig |    7 +++++--
>> >  1 files changed, 5 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/leds/Kconfig b/drivers/leds/Kconfig
>> > index b591e72..1c35927 100644
>> > --- a/drivers/leds/Kconfig
>> > +++ b/drivers/leds/Kconfig
>> > @@ -17,10 +17,13 @@ menuconfig NEW_LEDS
>> >  if NEW_LEDS
>> >
>> >  config LEDS_CLASS
>> > -   bool "LED Class Support"
>> > +   tristate "LED Class Support"
>> >     help
>> >       This option enables the led sysfs class in /sys/class/leds.  You'll
>> > -     need this to do anything useful with LEDs.  If unsure, say N.
>> > +     need this to do anything useful with LEDs.  If unsure, say M.
>> > +
>> > +     Note: don't disable it as N, because plenty of led and trigger drivers
>> > +     are using this option.
>
> This is crap - putting a dependency in the help for an option is
> unacceptable when we have things like randconfig etc which are
> expected to work.
>
> If this must be 'm' or 'y', then make it depend on m to force the
> minimum setting.
>

I will remove the pointless help message and try to fix all compiling
error then, and send out the patch again.

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
