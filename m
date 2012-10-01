Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848Ab2JAGPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 02:15:05 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41976 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab2JAGPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 02:15:03 -0400
MIME-Version: 1.0
In-Reply-To: <1348868177-21205-12-git-send-email-arnd@arndb.de>
References: <1348868177-21205-1-git-send-email-arnd@arndb.de>
	<1348868177-21205-12-git-send-email-arnd@arndb.de>
Date: Mon, 1 Oct 2012 08:15:01 +0200
Message-ID: <CACRpkdZv2b8M2Y4BJpqOX72prLHf4aACbmYk=imevX7h-X65QQ@mail.gmail.com>
Subject: Re: [PATCH 11/12] pinctrl: samsung: use __devinit section for init code
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Thomas Abraham <thomas.abraham@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 11:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> The samsung pinctrl driver has a probe function that is
> __devinit and that calls a lot of other functions that are
> marked __init, which kbuild complains about.
>
> Marking everything __devinit means that the code does not
> discarded when CONFIG_HOTPLUG is set, which is a little
> more wasteful, but also more consistent
>
> Without this patch, building exynos_defconfig results in:
>
> WARNING: drivers/pinctrl/built-in.o(.devinit.text+0x124): Section mismatch in reference from the function samsung_pinctrl_probe() to the function .init.text:samsung_gpiolib_register()
> The function __devinit samsung_pinctrl_probe() references
> a function __init samsung_gpiolib_register().
> If samsung_gpiolib_register is only used by samsung_pinctrl_probe then
> annotate samsung_gpiolib_register with a matching annotation.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Thomas Abraham <thomas.abraham@linaro.org>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Stephen Warren <swarren@nvidia.com>
> Cc: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

I think the Samsing pinctrl driver has landed into next from some
branch in ARM SoC so you probably know better than me
where this thing should be merged...

Yours,
Linus Walleij
