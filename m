Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297Ab1JHKLB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 06:11:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64938 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab1JHKK5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 06:10:57 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-23-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-23-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 8 Oct 2011 18:10:37 +0800
Message-ID: <CAMPhdO_oP9t-miSr-OgWEUT9QycSQUx8y8gRyBcuswaB4rWiug@mail.gmail.com>
Subject: Re: [PATCH 22/26] ARM: pxa: only select SMC91x on xcep when
 networking is enabled
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The smc91x driver is not strictly required for xcep, but it
> can only be enabled if ethernet support is built into the
> kernel, so make the dependency more specific.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-pxa/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/Kconfig b/arch/arm/mach-pxa/Kconfig
> index 491c522..ef35ce9 100644
> --- a/arch/arm/mach-pxa/Kconfig
> +++ b/arch/arm/mach-pxa/Kconfig
> @@ -174,7 +174,7 @@ config MACH_XCEP
>        select MTD_CFI_INTELEXT
>        select MTD_CFI
>        select MTD_CHAR
> -       select SMC91X
> +       select SMC91X if NET_ETHERNET

Or let's just remove this 'select SMC91X' completely as it's not
strictly required?

BTW - how's the Kconfig cleanup works going? I guess going forward,
the best way for such cases might be to introduce HAVE_SMC91X, and
let SMC91X to depend on this? However, that could in turn introduce
a massive number of HAVE_* for various drivers.

>        help
>          PXA255 based Single Board Computer with SMC 91C111 ethernet chip and 64 MB of flash.
>          Tuned for usage in Libera instruments for particle accelerators.
> --
> 1.7.5.4
>
>
