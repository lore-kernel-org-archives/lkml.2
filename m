Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751620Ab1GYN0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:26:00 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:53464 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751481Ab1GYNZ7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:25:59 -0400
MIME-Version: 1.0
In-Reply-To: <CACqU3MU=HKcFdC_B3x-APeJE_8SMLifmSUG22SrUw2GE-HHaSg@mail.gmail.com>
References: <CACqU3MU=HKcFdC_B3x-APeJE_8SMLifmSUG22SrUw2GE-HHaSg@mail.gmail.com>
Date: Mon, 25 Jul 2011 09:25:58 -0400
Message-ID: <CAPcSpEJZ47FQ3e84Mrf=U8GYw1W3Nx2DErgeSpvyuexC9fhsgA@mail.gmail.com>
Subject: Re: linux-next: Tree for July 22 (arm-davinci Kconfig warnings)
From: Ben Gardiner <bengardiner@nanometrics.ca>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 24, 2011 at 5:34 PM, Arnaud Lacombe <lacombar@gmail.com> wrote:
> Hi,

Hi Arnaud,

> The arm-davinci tree has 2 Kconfig warning, but also present in v3.0:
>
> arch/arm/mach-davinci/Kconfig:195:warning: config symbol defined without type
> arch/arm/mach-davinci/Kconfig:198:warning: config symbol defined without type

I hadn't noticed those warnings, sorry.

> This concerns GPIO_PCA953X and KEYBOARD_GPIO_POLLED. In both case,
> symbols are re-defined later on in `drivers/gpio/Kconfig' respectively
> in `arch/arm/mach-davinci/Kconfig' and
> `drivers/input/keyboard/Kconfig'.
>
> Is there any reason not to select those from MACH_DAVINCI_DA850_EVM
> definition, ala:

The reason for the GPIO_PCA953X and KEYBOARD_GPIO_POLLED fragments is
to get the symbols selected by default but allow those who
re-configure the kernel to select them instead as modules or even
disable them.

> diff --git a/arch/arm/mach-davinci/Kconfig b/arch/arm/mach-davinci/Kconfig
> index c0deaca..cec22e2 100644
> --- a/arch/arm/mach-davinci/Kconfig
> +++ b/arch/arm/mach-davinci/Kconfig
> @@ -163,6 +163,8 @@ config MACH_DAVINCI_DA850_EVM
>        bool "TI DA850/OMAP-L138/AM18x Reference Platform"
>        default ARCH_DAVINCI_DA850
>        depends on ARCH_DAVINCI_DA850
> +       select GPIO_PCA953X
> +       select KEYBOARD_GPIO_POLLED
>        help
>          Say Y here to select the TI DA850/OMAP-L138/AM18x Evaluation Module.
>
> @@ -192,12 +194,6 @@ config DA850_UI_RMII
>
>  endchoice
>
> -config GPIO_PCA953X
> -       default MACH_DAVINCI_DA850_EVM
> -
> -config KEYBOARD_GPIO_POLLED
> -       default MACH_DAVINCI_DA850_EVM
> -
>  config MACH_TNETV107X
>        bool "TI TNETV107X Reference Platform"
>        default ARCH_DAVINCI_TNETV107X

My understanding of this diff is that both GPIO_PCA953X and
KEYBOARD_GPIO_POLLED will be selected unconditionally as built-ins for
any MACH_DAVINCI_DA850_EVM. As opposed to having the symbols default
to 'y' and potentially be changed to 'm' or 'n' by someone
reconfiguring.

I took the idea of using these KConfig fragments from Sam Ravnborg
(added to CC); he suggested the method [1] in a response to a patch by
Stephen Rothwell (already on CC) which proposed a extension to the
'select' syntax [2]. If the select syntax extension or other
equivalent means is ready then arch/arm/mach-davinci can be converted.

Best Regards,
Ben Gardiner

[1] http://article.gmane.org/gmane.linux.ports.ppc.embedded/37132
[2] http://article.gmane.org/gmane.linux.ports.ppc.embedded/36839

---
Nanometrics Inc.
http://www.nanometrics.ca
