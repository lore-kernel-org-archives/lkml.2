Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754408Ab1D1HHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 03:07:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54286 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab1D1HHe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 03:07:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Ln4zuRuVHn4pwPNfdIkd96EOgv7BXpBUtWDdlbK34J0klqoPW4BcTHJCTcBafxd3vz
         UVmeTgD0wVSw+SIqZSOOe0/oXnqmuAA1xrdGC6ZR9B8RY5MsnzGzMKuPxiy0Sas84CeM
         ugecncA5kJbInNNscbgmFXfTvFSU0N/KmdqCQ=
MIME-Version: 1.0
In-Reply-To: <0D753D10438DA54287A00B027084269764D2650215@AUSP01VMBX24.collaborationhost.net>
References: <1303910002-3333-1-git-send-email-linus.walleij@stericsson.com>
	<0D753D10438DA54287A00B027084269764D2650215@AUSP01VMBX24.collaborationhost.net>
Date: Thu, 28 Apr 2011 09:07:33 +0200
X-Google-Sender-Auth: 1fPjUggg9FLu59m6web6TbP4USw
Message-ID: <BANLkTikc7B5J0Z_aiS5kXCxMSxcFrfSRxw@mail.gmail.com>
Subject: Re: [PATCH 02/10] mach-u300: rewrite gpio driver, move to drivers/gpio
From: Linus Walleij <linus.walleij@linaro.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/4/27 H Hartley Sweeten <hartleys@visionengravers.com>:
> On Wednesday, April 27, 2011 6:13 AM, Linus Walleij wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> This rewrites the U300 GPIO driver using gpiolib and the irq_chip
>> abstractions, makes it runtime-configured rather than compile-time,
>> and moves it to the drivers/gpio subsystem where it belongs,
>> depopulating the ARM tree of one more driver.
>>
>> Cc: Jonas Aaberg <jonas.aberg@stericsson.com>
>> Acked-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>
> If this and other platform-specific GPIO drivers are going to be
> moved to the drivers/gpio subsystem, the Kconfig and Makefile should
> probably be updated to reflect this.
>
> In drivers/gpio/Kconfig:
>
> #
> # platform-neutral GPIO infrastructure and expanders
> #
>
> And in drivers/gpio/Makefile:
>
> # generic gpio support: dedicated expander chips, etc
> #
> # NOTE: platform-specific GPIO drivers don't belong in the
> # drivers/gpio directory; put them with other platform setup
> # code, IRQ controllers, board init, etc.

Yeah, you're right. I can take these comments out, simply.
I'll review the files as bit to make sure there aren't any more
statements like that.

> The Makefile should probably be reordered, either alphabetically
> or grouped by type (arch/mmio/i2c/spi/pci/etc) and then
> alphabetically in order to reduce merge conflicts.

Yes, but if I do that in my patchset I will screw up Grants GPIO tree
completely, so I prefer that Grant do this. And maybe after pulling
in my GPIO consolidation tree to his in that case, so we don't get
undesired collisions. So leaving this for the GPIO maintainer.

Yours,
Linus Walleij
