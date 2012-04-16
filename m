Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab2DPHWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 03:22:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47920 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab2DPHV7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 03:21:59 -0400
MIME-Version: 1.0
In-Reply-To: <1334483574-3997-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1334483574-3997-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Date: Mon, 16 Apr 2012 09:21:58 +0200
Message-ID: <CACRpkdZ8yH1ZSG-nQ9dLm0TipHS-jZDuxwqohUC=LGH9V-5q4w@mail.gmail.com>
Subject: Re: [PATCH] gpiolib/arches: Centralise bolierplate asm/gpio.h
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Grant Likely <grant@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-alpha@vger.kernel.org, linux-ia64@vger.kernel.org,
        microblaze-uclinux@itee.uq.edu.au, linux@openrisc.net,
        "linuxppc-dev@lists.ozlabs.org list" <linuxppc-dev@lists.ozlabs.org>,
        sparclinux@vger.kernel.org, Chris Zankel <chris@zankel.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2012 at 11:52 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> Rather than requiring architectures that use gpiolib but don't have any
> need to define anything custom to copy an asm/gpio.h provide a Kconfig
> symbol which architectures must select in order to include gpio.h and
> for other architectures just provide the trivial implementation directly.
>
> This makes it much easier to do gpiolib updates and is also a step towards
> making gpiolib APIs available on every architecture.
>
> For architectures with existing boilerplate code leave a stub header in
> place which warns on direct inclusion of asm/gpio.h and includes
> linux/gpio.h to catch code that's doing this.  Direct inclusion of
> asm/gpio.h has long been deprecated.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  arch/alpha/include/asm/gpio.h      |   59 ++----------------------------
>  arch/arm/Kconfig                   |    1 +
>  arch/avr32/Kconfig                 |    1 +
>  arch/blackfin/Kconfig              |    1 +
>  arch/ia64/include/asm/gpio.h       |   59 ++----------------------------
>  arch/m68k/Kconfig.cpu              |    1 +
>  arch/microblaze/include/asm/gpio.h |   57 ++---------------------------
>  arch/mips/Kconfig                  |    1 +
>  arch/openrisc/include/asm/gpio.h   |   69 ++---------------------------------
>  arch/powerpc/include/asm/gpio.h    |   57 ++---------------------------
>  arch/sh/Kconfig                    |    1 +
>  arch/sparc/include/asm/gpio.h      |   40 ++-------------------
>  arch/unicore32/Kconfig             |    1 +
>  arch/x86/include/asm/gpio.h        |   57 ++---------------------------
>  arch/xtensa/include/asm/gpio.h     |   60 ++-----------------------------
>  drivers/gpio/Kconfig               |    8 ++++
>  include/linux/gpio.h               |   34 +++++++++++++++++
>  17 files changed, 81 insertions(+), 426 deletions(-)

This looks good but I think we need to page the alpha, ia64, m68k, microblaze,
openrisc etc subarch maintainers on this patch so they have their say.

Yours,
Linus Walleij
