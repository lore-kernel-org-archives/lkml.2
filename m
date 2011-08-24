Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864Ab1HXJQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:16:01 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:33275 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1HXJP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:15:57 -0400
MIME-Version: 1.0
In-Reply-To: <1313636407.19990.102.camel@finisterre.wolfsonmicro.main>
References: <1313019091-15354-1-git-send-email-kheitke@codeaurora.org>
	<1772239.ndMLD9ec3r@wuerfel>
	<20110817080327.GD13460@opensource.wolfsonmicro.com>
	<201108171242.24918.arnd@arndb.de>
	<1313586241.19990.94.camel@finisterre.wolfsonmicro.main>
	<CACRpkdbSVF1FxpuocoXkDFH3vDQc4OoTwjU+9iqj0=vVs3R3dQ@mail.gmail.com>
	<1313636407.19990.102.camel@finisterre.wolfsonmicro.main>
Date: Wed, 24 Aug 2011 11:15:56 +0200
Message-ID: <CACRpkdbSQWej3iZF7qww1q5KW6kQTW6bqrVs4+rkLvhP5qu5fA@mail.gmail.com>
Subject: Re: [RFC PATCH] slimbus: Linux driver framework for SLIMbus.
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kenneth Heitke <kheitke@codeaurora.org>,
        sdharia@codeaurora.org, David Brown <davidb@codeaurora.org>,
        bryanh@codeaurora.org, linux-arm-msm@vger.kernel.org,
        rdunlap@xenotime.net, rmk+kernel@arm.linux.org.uk,
        john.stultz@linaro.org, akpm@linux-foundation.org, ohad@wizery.com,
        gregkh@suse.de, stefanr@s5r6.in-berlin.de, lethal@linux-sh.org,
        linville@tuxdriver.com, zajec5@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 18, 2011 at 5:00 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, 2011-08-17 at 15:17 +0200, Linus Walleij wrote:
>> On Wed, Aug 17, 2011 at 3:04 PM, Mark Brown
>> <broonie@opensource.wolfsonmicro.com> wrote:
>
>> > The device driver will know what power supplies and other signals the
>> > device has, and it will know how and when to use them. (...)
>
>> And I guess there is nothing in the spec claiming that all devices
>> be powered-on when you boot?
>
> I don't believe so, and if there were I'd not expect anyone to pay a
> blind bit of notice to it.

That means that the regulators handling the slimbus devices
will need to be enabled before the drivers issue regulator_get()
and regulator_enable() on them.

Does the regulator constraint .always_on have this semantic
effect, so the regulator framework can power up the devices
without their drivers claiming the regulators first?

Or would we need a new .boot_enable flag to handle that?

> If my memory serves (I don't have access to the relevant documents right
> now) the device announces itself when it detects that the bus is alive.
> Slimbus is a relatively heavyweight interface so the extra cost of doing
> this won't be too bad.

OK so if we can just power the device the bus can probably
autodetect all devices on it, it seems.

Thanks,
Linus Walleij
