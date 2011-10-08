Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab1JHHpN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 03:45:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38806 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab1JHHpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 03:45:11 -0400
MIME-Version: 1.0
In-Reply-To: <1317499438-14058-19-git-send-email-arnd@arndb.de>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-19-git-send-email-arnd@arndb.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Sat, 8 Oct 2011 15:44:50 +0800
Message-ID: <CAMPhdO88OdwjfERo=Ri_-_xR75S53d-HKW1Ah0WGnu_0P1gRXQ@mail.gmail.com>
Subject: Re: [PATCH 18/26] ARM: pxa: MTD_XIP is not actually working any more
To: Arnd Bergmann <arnd@arndb.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> The headers files required for XIP support have moved around
> over the last few years, and the code no longer builds.
> Until someone fixes this, let's just disable support, leaving
> sa1100 as the only platform still supporting xip.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

It is actually fixable, the problem is really mtd-xip.h is referencing
the interrupt registers directly which I moved them to mach-pxa/irq.c
for better modularization.

I'm fine to drop XIP. I'm afraid Nico's gonna be a bit disappointed
as I broke his favorite XIP code :-)

> ---
>  arch/arm/Kconfig |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 570c9fd..71b0ccb 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -619,7 +619,6 @@ config ARCH_PNX4008
>  config ARCH_PXA
>        bool "PXA2xx/PXA3xx-based"
>        depends on MMU
> -       select ARCH_MTD_XIP
>        select ARCH_HAS_CPUFREQ
>        select CLKDEV_LOOKUP
>        select CLKSRC_MMIO
> --
> 1.7.5.4
>
>
