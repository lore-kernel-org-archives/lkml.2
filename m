Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921Ab1K3N2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:28:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49937 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755582Ab1K3N2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:28:36 -0500
MIME-Version: 1.0
In-Reply-To: <20111130063500.GB12052@suse.de>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<20111127230836.GA29728@suse.de>
	<20111128123114.2601bd7c@notabene.brown>
	<20111128072713.GA17724@suse.de>
	<20111128090446.GB18919@core.coreip.homeip.net>
	<20111130063500.GB12052@suse.de>
Date: Wed, 30 Nov 2011 14:28:36 +0100
Message-ID: <CACRpkdY0vhV6cQgYDhfqAfGWVWWEsiFW4vJ7uumvWwigobpwUw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg KH <gregkh@suse.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, NeilBrown <neilb@suse.de>,
        Arnd Bergmann <arnd@arndb.de>, myungjoo.ham@gmail.com,
        linux-kernel@vger.kernel.org, Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 30, 2011 at 7:35 AM, Greg KH <gregkh@suse.de> wrote:

> So, how do you want this type of interface to look like, uevents only?
>
> Or something like gpio?
>
> Actually, why can't we just use gpio as-is here and just treat these
> devices as "generic" i/o "pins"?

For device drivers we have the issue that the management of
the GPIO pin-space give me the creeps. It is simple when things
are simple and then ugly things have start to happen, such
as dynamically bumping the GPIO pin range and associated
IRQ range at compile time using unreadable nested macros.
You roof the space at some arbitrary number at compile-time
in ARCH_NR_GPIOS and if you don't define it,
<asm-generic/gpio.h> will helpfully define that your system
has 256 GPIO pins.

The effect of the above on unified cross-ARM-arch kernels is
confusing as the meaning of the GPIO pinspace will
shift at runtime depending on what system it's running on.

A new subsystem could allocate switch/pin/line assignments
dynamically which is way more viable. (And how we chose to
do in in pinctrl.)

For userspace several people, notably the GPIOlib subsystem
maintainer Grant, expressed concerns about the sysfs interface
to GPIO. So I would not shoehorn new stuff in there, solidifying
it even more.

So I would recommend doing this as a new subsystem to save
us from trouble. There is more to be gained from splitting things
apart than keeping them together in this case IMO.

Yours,
Linus Walleij
