Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294Ab2ABGsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 01:48:23 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43342 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2ABGsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 01:48:21 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
Date: Sun, 1 Jan 2012 22:48:21 -0800
Message-ID: <CAOesGMirAda7rzZcM74fat0qV8giy3Qniqh4z_oA9OSzMAOwHg@mail.gmail.com>
Subject: Re: [RFC][PATCH 0/4] lcd: platform-lcd: Add lcd panel and device tree support
From: Olof Johansson <olof@lixom.net>
To: Thomas Abraham <thomas.abraham@linaro.org>
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

Hi,

On Sun, Jan 1, 2012 at 9:54 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:
> The platform-lcd driver depends on platform-specific callbacks to setup the
> lcd panel. These callbacks are supplied using driver's platform data. But
> for adding device tree support for platform-lcd driver, providing such
> callbacks is not possible (without using auxdata).
>
> Since the callbacks are usually lcd panel specific, it is possible to include
> the lcd panel specific setup and control functionality in the platform-lcd
> driver itself, thereby eliminating the need for supplying platform specific
> callbacks to the driver. The platform-lcd driver can include support for
> multiple lcd panels.
>
> This patchset removes the need for platform data for platform-lcd driver and
> adds support which can be used to implement lcd panel specific functionality
> in the driver. As an example, the support for Hydis hv070wsa lcd panel is added
> to the platform-lcd driver which is then used on the Exynos4 based Origen board.
> This currently breaks build for other users of platform-lcd driver. Those can be
> fixed if this approach is acceptable.

I think it would be a better idea to provide a generic binding for the
simple LCD panels that just need one or two power GPIOs to be turned
on (some tend to need one to activate and one for power control --
second might in some cases be handled through a regulator I suppose).
I'm sure there will be exceptions to this; panels that have quirks or
requirements on various things that will either require an expanded
binding, or custom probe functions.

Especially in the case you are providing -- that lcd driver is only
using a single gpio, and it would be much more valuable to have a
trivial binding for this that uses shared code for this. Otherwise
every single simple panel will need to be added over time.


-Olof
