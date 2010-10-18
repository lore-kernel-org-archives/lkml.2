Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757691Ab0JRTwN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 15:52:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42655 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab0JRTwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 15:52:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=q+fo0bIie9LQF3kbEwd7Wem1wNes8WjA2coMIYgLP15jbQWlgYN3oE789KsBW2oiuL
         FiZTsogusvn2Ul0mb2eHt1Hyt1RpGw2KiB3+LvsFjDaIFXEB0aEc1WV0Se0iQJ3hk1SX
         Pja5qCg4TuJgYaI8T0lZlpb1t9mUPzzlgV5aI=
MIME-Version: 1.0
In-Reply-To: <20101018163357.659efe25@endymion.delvare>
References: <1287359019-1476-1-git-send-email-vapier@gentoo.org>
 <20101018103610.77b7e605@endymion.delvare> <544AC56F16B56944AEC3BD4E3D5917713094520EDB@LIMKCMBX1.ad.analog.com>
 <20101018140136.2b44d29e@endymion.delvare> <544AC56F16B56944AEC3BD4E3D5917713094520FA6@LIMKCMBX1.ad.analog.com>
 <20101018163357.659efe25@endymion.delvare>
From: Mike Frysinger <vapier@gentoo.org>
Date: Mon, 18 Oct 2010 15:51:49 -0400
X-Google-Sender-Auth: MT8QGlS-0YuhzFqdqPx3UPCAWRc
Message-ID: <AANLkTi=fAYqxsGre9kOt9Z8nDXZ9JFjZtKUiMrE3Qn9b@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [PATCH] i2c: add irq_flags to board info
To: Jean Delvare <khali@linux-fr.org>
Cc: "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        David Brownell <david-b@pacbell.net>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 10:33, Jean Delvare wrote:
> Why do we have set_irq_type() if we're not supposed to call it? I am
> not claiming to be an expert in the area, but it seems totally
> reasonable to me that the same piece of code instantiating an I2C
> device is also responsible for setting its IRQ type.

but we're back to the same issue mentioned earlier -- you cant have a
single kernel build with modules supporting multiple drivers
simultaneously.  we like to ship development boards with a single
kernel build on it with many modules.  then people can pick the addon
boards they wish to prototype with at runtime by plugging in the card
and loading the module.

if the only way to change flags on a pin is via set_irq_type(), that
kernel build is instantly tied to whatever device you've decided to
compile statically into the board's init code.  so now to prototype
multiple boards, we have to tell people to boot different kernels !?
and we have to store multiple kernels and sets of kernel modules in
the rootfs !?

>> The user decides which add-on module is plugged onto the processor board,
>> by loading the appropriate driver module.
>
> This can't work, sorry. Unless you are using I2C device auto-detection,
> which I seem to understand is NOT used in the embedded world at all,
> loading a driver module doesn't do anything if a device it supports
> hasn't been instantiated first. So the user can't just load a driver
> and see the required I2C devices magically appear for the driver to
> bind to them.

why cant user selection work ?  the user picks `modprobe foo` because
they have a 'foo' device plugged in.

i'm not sure what "I2C device auto-detection" means.  are you talking
about a userspace app/daemon that scans the I2C bus, looks up the
slave ids in the module db, and then automatically loads the modules
that it finds bindings for ?

>> There are drivers that work around this deficiency, by adding irq_flags to the bus
>> clients dev.platform_data.  See include/linux/spi/ads7846.h for one example.
>
> Interesting example, better matching the initial comment that came
> along with the patch. But it also seems to be an isolated case, as I
> can't find any other irq_flags in include/linux/{i2c,spi}/.

we've been holding off posting things because we need the core extended first
-mike
