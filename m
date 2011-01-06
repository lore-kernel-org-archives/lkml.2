Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1AFD3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 22:29:38 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42557 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159Ab1AFD3g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 22:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=o6K3g5TysoPnyjefsFAXb8jyJ805Hy/5bZdjFTTezT82pmK+EzUQe+jLxwKGXdO0mg
         SF3YD4G1BooSj8IHi+quNsvIym2jXVh8RqzsoA5ZVJMlnRNUYp4iDH9agzYKjP5jWkf5
         qiphZqBSDEfZs7sDeEhI4mPYsw+3bZNac1l+g=
MIME-Version: 1.0
In-Reply-To: <20110106133107.463c3e60.sfr@canb.auug.org.au>
References: <20110106133107.463c3e60.sfr@canb.auug.org.au>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Thu, 6 Jan 2011 11:29:15 +0800
Message-ID: <AANLkTi=SmAOxTKmP5w-GKbx1mEDAXAJs7Cv58tRV-AOk@mail.gmail.com>
Subject: Re: linux-next: manual merge of the bjdooks-i2c tree with the arm tree
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dirk Brandewie <dirk.brandewie@gmail.com>,
        Marek Vasut <marek.vasut@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 10:31 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Ben,
>
> Today's linux-next merge of the bjdooks-i2c tree got a conflict in
> arch/arm/mach-pxa/pxa27x.c, arch/arm/mach-pxa/pxa3xx.c and
> arch/arm/mach-pxa/trizeps4.c between commit
> ad68bb9f7a3cd47396635a5e3895215af57579da ("ARM: pxa: Access SMEMC via
> virtual addresses") from the arm tree and commit
> 0a56f28ec486273d84d25571573908344aa67176 ("arm/pxa2xx: reorganize I2C
> files") from the bjdooks-i2c tree.
>
> I fixed it up (see below) and can carry the fix as necessary.

Thanks Stephen, that looks sane to me.

> --
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
>
> diff --cc arch/arm/mach-pxa/pxa27x.c
> index b2130b7,1c77e89..0000000
> --- a/arch/arm/mach-pxa/pxa27x.c
> +++ b/arch/arm/mach-pxa/pxa27x.c
> @@@ -17,9 -17,8 +17,10 @@@
>  #include <linux/suspend.h>
>  #include <linux/platform_device.h>
>  #include <linux/sysdev.h>
>  +#include <linux/io.h>
> + #include <linux/i2c/pxa-i2c.h>
>
>  +#include <asm/mach/map.h>
>  #include <mach/hardware.h>
>  #include <asm/irq.h>
>  #include <mach/irqs.h>
> @@@ -29,10 -28,7 +30,8 @@@
>  #include <mach/ohci.h>
>  #include <mach/pm.h>
>  #include <mach/dma.h>
>  +#include <mach/smemc.h>
>
> - #include <plat/i2c.h>
> -
>  #include "generic.h"
>  #include "devices.h"
>  #include "clock.h"
> diff --cc arch/arm/mach-pxa/pxa3xx.c
> index e14818f,c9d9729..0000000
> --- a/arch/arm/mach-pxa/pxa3xx.c
> +++ b/arch/arm/mach-pxa/pxa3xx.c
> @@@ -21,8 -21,8 +21,9 @@@
>  #include <linux/irq.h>
>  #include <linux/io.h>
>  #include <linux/sysdev.h>
> + #include <linux/i2c/pxa-i2c.h>
>
>  +#include <asm/mach/map.h>
>  #include <mach/hardware.h>
>  #include <mach/gpio.h>
>  #include <mach/pxa3xx-regs.h>
> @@@ -31,8 -31,6 +32,7 @@@
>  #include <mach/pm.h>
>  #include <mach/dma.h>
>  #include <mach/regs-intc.h>
>  +#include <mach/smemc.h>
> - #include <plat/i2c.h>
>
>  #include "generic.h"
>  #include "devices.h"
> diff --cc arch/arm/mach-pxa/trizeps4.c
> index 43fc9ca,995e671..0000000
> --- a/arch/arm/mach-pxa/trizeps4.c
> +++ b/arch/arm/mach-pxa/trizeps4.c
> @@@ -47,8 -47,6 +47,7 @@@
>  #include <mach/mmc.h>
>  #include <mach/irda.h>
>  #include <mach/ohci.h>
>  +#include <mach/smemc.h>
> - #include <plat/i2c.h>
>
>  #include "generic.h"
>  #include "devices.h"
>
