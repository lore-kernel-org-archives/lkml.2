Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753297Ab2ABRb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 12:31:58 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63372 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2ABRbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 12:31:55 -0500
MIME-Version: 1.0
In-Reply-To: <CAOesGMirAda7rzZcM74fat0qV8giy3Qniqh4z_oA9OSzMAOwHg@mail.gmail.com>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
	<CAOesGMirAda7rzZcM74fat0qV8giy3Qniqh4z_oA9OSzMAOwHg@mail.gmail.com>
Date: Mon, 2 Jan 2012 23:01:54 +0530
Message-ID: <CAJuYYwTGWHCpEnE5w8b7mmg_oaFiygQSSey7ra+nR+Q9_Bi_tA@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/4] lcd: platform-lcd: Add lcd panel and device tree support
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof,

On 2 January 2012 12:18, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> On Sun, Jan 1, 2012 at 9:54 PM, Thomas Abraham
> <thomas.abraham@linaro.org> wrote:
>> The platform-lcd driver depends on platform-specific callbacks to setup the
>> lcd panel. These callbacks are supplied using driver's platform data. But
>> for adding device tree support for platform-lcd driver, providing such
>> callbacks is not possible (without using auxdata).
>>
>> Since the callbacks are usually lcd panel specific, it is possible to include
>> the lcd panel specific setup and control functionality in the platform-lcd
>> driver itself, thereby eliminating the need for supplying platform specific
>> callbacks to the driver. The platform-lcd driver can include support for
>> multiple lcd panels.
>>
>> This patchset removes the need for platform data for platform-lcd driver and
>> adds support which can be used to implement lcd panel specific functionality
>> in the driver. As an example, the support for Hydis hv070wsa lcd panel is added
>> to the platform-lcd driver which is then used on the Exynos4 based Origen board.
>> This currently breaks build for other users of platform-lcd driver. Those can be
>> fixed if this approach is acceptable.
>
> I think it would be a better idea to provide a generic binding for the
> simple LCD panels that just need one or two power GPIOs to be turned
> on (some tend to need one to activate and one for power control --
> second might in some cases be handled through a regulator I suppose).
> I'm sure there will be exceptions to this; panels that have quirks or
> requirements on various things that will either require an expanded
> binding, or custom probe functions.

A majority of the existing users of the platform-lcd driver are using
a single gpio to enable or disable the display. As you mentioned, a
generic binding can be added for such lcd panels. There are other
implementations that use one or more gpios but requires toggling those
gpios in a panel specific way (usually with some delay). Such
implementations will require custom panel support included in the
platfrom-lcd driver. I will prepare a patch for these cases.

>
> Especially in the case you are providing -- that lcd driver is only
> using a single gpio, and it would be much more valuable to have a
> trivial binding for this that uses shared code for this. Otherwise
> every single simple panel will need to be added over time.

Yes. I agree. It is better to have a common binding and there are many
panels that can use this generic binding. I will make these changes.

Thanks for your review.

Regards,
Thomas.

>
>
> -Olof
