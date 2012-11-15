Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767879Ab2KON4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 08:56:53 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:57000 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767793Ab2KON4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:56:52 -0500
Date: Thu, 15 Nov 2012 14:56:35 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH 1/4] pinctrl: dove: Prevent NULL dereference if
 of_match_device returns NULL
Message-ID: <20121115145635.2fae2fc9@skate>
In-Reply-To: <CAFRkauCybE+UcBD17u3J6hoxEA88GM0tatxkrKtWqVNvDPC9dA@mail.gmail.com>
References: <1352955096.6793.1.camel@phoenix>
	<20121115083511.08f5a16f@skate>
	<CAFRkauCybE+UcBD17u3J6hoxEA88GM0tatxkrKtWqVNvDPC9dA@mail.gmail.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Axel Lin,

On Thu, 15 Nov 2012 21:44:07 +0800, Axel Lin wrote:

> BTW, I found there is no way to compile the dove and kirkwood pinctrl
> drivers.
> I need add below patch to compile these two drivers, how do you think about
> below patch?
> ( In dove, the USE_OF is optional, it is selected only when MACH_DOVE_DT is
> enabled )
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 14f8160..dda6785 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -531,6 +531,8 @@ config ARCH_DOVE
>         select CPU_V7
>         select GENERIC_CLOCKEVENTS
>         select MIGHT_HAVE_PCI
> +       select PINCTRL
> +       select PINCTRL_DOVE if USE_OF
>         select PLAT_ORION_LEGACY
>         select USB_ARCH_HAS_EHCI
>         help
> @@ -542,6 +544,8 @@ config ARCH_KIRKWOOD
>         select CPU_FEROCEON
>         select GENERIC_CLOCKEVENTS
>         select PCI
> +       select PINCTRL
> +       select PINCTRL_KIRKWOOD
>         select PLAT_ORION_LEGACY
>         help
>           Support for the following Marvell Kirkwood series SoCs:

See "[PATCH 1/5] ARM: Kirkwood: Allow use of pinctrl" and "[PATCH 4/5]
ARM: Dove: Make use of pinctrl driver" which have been posted by Andrew
Lunn on October, 24th.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
