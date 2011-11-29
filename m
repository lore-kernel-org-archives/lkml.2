Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab1K2Jpq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 04:45:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63271 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab1K2Jpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 04:45:44 -0500
MIME-Version: 1.0
In-Reply-To: <CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<201111281753.45287.arnd@arndb.de>
	<CAJ0PZbT8FcCq=6GzLxOhhpRvCbCaJJEhE9_2GXXT4P0XZp6H-w@mail.gmail.com>
Date: Tue, 29 Nov 2011 10:45:43 +0100
Message-ID: <CACRpkdZsitv8rfcidS2auATg7_VGtDZt7z-we1UJcP2C32dujg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: Linus Walleij <linus.walleij@linaro.org>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>, Greg KH <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 29, 2011 at 10:11 AM, MyungJoo Ham <myungjoo.ham@gmail.com> wrote:

> For the next iteration, I'm considering the followings. It'd be much
> appreciated if I could get some comments about those beforehand.
> 1. ABI documentation

Good!

> 2. move the location from /drivers/misc to an independent location.
> /drivers/switch? /drivers/multistate-switch? /drivers/msc?
> /drivers/mswitch? ...

drivers/switch if I have my say. It looks intuitive.

> 3. Allow the notifiee device drivers to register its specific
> interest. The interface would look like:
> int switch_register_interest(struct switch_dev *sdev, const char
> *cable_name, struct notifier_block *b);
> (the rationale is that the notifiee device does not need to know the
> detail about the switch dev configuration but for the name of the
> switch dev or notifier).
> or even
> int switch_register_interest(const char *switch_name, const char
> *cable_name, struct notifier_block *b);
> and allow notifee to forget about the sdev pointer as well. (and all
> the other APIs are for implementing notifier, not notifiee)

Good.

I will likely ack this once the code looks real nice, FWIW.

Yours,
Linus Walleij
