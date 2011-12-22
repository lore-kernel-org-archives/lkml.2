Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1LVLh3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 06:37:29 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36972 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921Ab1LVLh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 06:37:27 -0500
Date: Thu, 22 Dec 2011 11:39:16 +0000
From: Dave Martin <dave.martin@linaro.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Felipe Balbi <balbi@ti.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Uwe Kleine-K??nig <u.kleine-koenig@pengutronix.de>,
        "open list:ARM PORT" <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 02/10] arm: vexpress: fix kconfig warning
Message-ID: <20111222113916.GA2625@localhost>
References: <1324341747-5922-1-git-send-email-felipe.contreras@gmail.com>
 <1324341747-5922-3-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324341747-5922-3-git-send-email-felipe.contreras@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 02:42:19AM +0200, Felipe Contreras wrote:
> warning: (ARCH_OMAP4 && ARCH_VEXPRESS_CA9X4) selects ARM_ERRATA_720789 which has unmet direct dependencies (CPU_V7 && SMP)
> warning: (ARCH_VEXPRESS_CA9X4) selects ARM_ERRATA_751472 which has unmet direct dependencies (CPU_V7 && SMP)
> 
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  arch/arm/mach-vexpress/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-vexpress/Kconfig b/arch/arm/mach-vexpress/Kconfig
> index 9311484..3fbcb8c 100644
> --- a/arch/arm/mach-vexpress/Kconfig
> +++ b/arch/arm/mach-vexpress/Kconfig
> @@ -5,8 +5,8 @@ config ARCH_VEXPRESS_CA9X4
>  	bool "Versatile Express Cortex-A9x4 tile"
>  	select CPU_V7
>  	select ARM_GIC
> -	select ARM_ERRATA_720789
> -	select ARM_ERRATA_751472
> +	select ARM_ERRATA_720789 if SMP
> +	select ARM_ERRATA_751472 if SMP
>  	select ARM_ERRATA_753970

NAK -- I hit this problem too, but in fact the errata configs should not
really be dependent on SMP; these are fixed in a couple of patches
currently queued in Russell's patch system:

7196/1 - errata: remove SMP dependency for erratum 720789
7197/1 - errata: remove SMP dependency for erratum 751472

...so we should avoid duplicating knowledge about exactly what these
errata workarounds do, where it can be avoided.

In the meantime, the warning is harmless.

Cheers
---Dave
