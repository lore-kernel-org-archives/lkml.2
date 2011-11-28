Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1K1NEI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 08:04:08 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:39285 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143Ab1K1NEH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 08:04:07 -0500
MIME-Version: 1.0
In-Reply-To: <20111128072713.GA17724@suse.de>
References: <CAJ0PZbQBXF1f7F27bkkT_ezFFtFi7kRVbF5WZXn+ZenZj2hT7w@mail.gmail.com>
	<201111251402.28016.arnd@arndb.de>
	<CACRpkdZSQcdK5ndSThQPRFAvp=sNMNDgBo5S6+H=t+0AYtJhOw@mail.gmail.com>
	<20111127230836.GA29728@suse.de>
	<20111128123114.2601bd7c@notabene.brown>
	<20111128072713.GA17724@suse.de>
Date: Mon, 28 Nov 2011 14:04:06 +0100
Message-ID: <CACRpkdZ+Epa_Y2Kr3dy3-BM8qrcV3f3fWsJXUAbhMTqd268+hw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] introduce: Multistate Switch Class
From: Linus Walleij <linus.walleij@linaro.org>
To: Greg KH <gregkh@suse.de>
Cc: NeilBrown <neilb@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        myungjoo.ham@gmail.com, linux-kernel@vger.kernel.org,
        Mike Lockwood <lockwood@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Donggeun Kim <dg77.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kalle Komierowski <karl.komierowski@stericsson.com>,
        Johan PALSSON <johan.palsson@stericsson.com>,
        Daniel WILLERUD <daniel.willerud@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>,
        morten.christiansen@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 8:27 AM, Greg KH <gregkh@suse.de> wrote:
> On Mon, Nov 28, 2011 at 12:31:14PM +1100, NeilBrown wrote:
>>
>>  My own thought is that this deserves a new device class which allows easy
>>  hook-up of in-kernel signalling using notifications and which can be
>>  exported as input devices in much the same way the 'gpio' devices can be
>>  exported via gpio_keys.  The switch could also optionally be exported through
>>  sysfs much like gpio can be exported through sysfs.
>
> That might also work, but again, odds are the HID spec already defines
> this type of "switch", so why recreate it as a different type of device?

I think both yes and no, but I will stand corrected.

When you plug it into a host, I guess your device will
negotiate power withdrawal from the host as anything else,
no matter what device or interface classes it presents.

However in the other case I am under the impression that
devices supporting EPS
http://en.wikipedia.org/wiki/Common_External_Power_Supply
Or the "battery charging specification"
http://www.usb.org/developers/devclass_docs/batt_charging_1_1.zip
do so in their Phy transceiver drivers, say e.g.
drivers/usb/otg/ab8500-usb.c in our case. This is sometime
called a "chinese charger" or "dedicated charger". It's just
appearing on the micro-USB port, it doesn't enumerate and
the OS driver does not talk to it. I think it notifies the transceiver
by short-circuiting D+ and D- and the transceiver/phy
driver may in many cases notify charging circuitry and
userspace that it's been plugged in (switch uevent,
cable insertion input event or whatever we come up with).

So no, I don't think HID defines this, it's defined in a
physical layer spec, and the interfaces to OS:es are
transciever/phy-custom.

I've CC:ed Morten who was part of writing the charging
spec so he can correct me if I'm saying the wrong thing.

Yours,
Linus Walleij
