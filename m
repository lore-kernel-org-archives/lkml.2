Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab2BMUCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 15:02:06 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52333 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757833Ab2BMUCD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 15:02:03 -0500
MIME-Version: 1.0
In-Reply-To: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>
References: <1329114588-15430-1-git-send-email-ldewangan@nvidia.com>
Date: Mon, 13 Feb 2012 21:02:03 +0100
Message-ID: <CACRpkdb5VA4GJpB_0Xra=R0LUD9fz4CoDLjuwFHZ8SnTMz3fpg@mail.gmail.com>
Subject: Re: [PATCH V1 0/3] Support for open drain gpios in gpilib/fixed regulators.
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        dunlap@xenotime.net, lrg@ti.com, broonie@opensource.wolfsonmicro.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 13, 2012 at 7:29 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> This is series of patches  to add support of the open drain gpios
> in standard gpio library and using this in fixed regulators.
> - Added GPIOF_OD flag so that client can request the gpio with this flag.
> - Added support for the sysfs interface for open-drain.
> - Handle open drain gpio configuration properly.
> - Use this flag in fixed regualtor to tell that gpio is open drain.
> - Gpio documentation changes to have support for open-drain.

My gut feeling is that this stuff needs to go into pinctrl.

The reason, which has been discussed when similar patches (from me,
for example) were NACK:ed in the past, is that if we put in OD pin
properties, we put in all pin properties (open source, drive strength,
biasing pull-up/pull-down etc etc) and that is the reason to why the
orthogonal pinctrl subsystem was created in the first place.

So I'd opt for moving the driver you need to drivers/pinctrl and
expose the gpiolib interface from there, while adding pinctrl
on the side.

Also, we had a flamefest a while back as to whether we should
enumerate all config options (like OD, OS...) or have it all-custom,
and I was sort of shot down on that. But I have a generic control patch
set boiling so if you like that kind of stuff I'll respin it.

Yours,
Linus Walleij
