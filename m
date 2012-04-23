Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753762Ab2DWGRa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 02:17:30 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:58482 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753684Ab2DWGR2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 02:17:28 -0400
MIME-Version: 1.0
In-Reply-To: <1335114510-29413-1-git-send-email-agust@denx.de>
References: <1335114510-29413-1-git-send-email-agust@denx.de>
Date: Mon, 23 Apr 2012 11:47:25 +0530
Message-ID: <CAP05o4JpwtERvLRitBKztrcr_9N+Kxm+SgU=yptUu9VfL3avkg@mail.gmail.com>
Subject: Re: [PATCH] mfd: omap-ush-host: Fix build breakage
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 10:38 PM, Anatolij Gustschin <agust@denx.de> wrote:
> Commit 1fcb57d0f6e1150003d222051aaaf4bc4a9ccc94 (ARM: OMAP3: USB: Fix
> the EHCI ULPI PHY reset issue) removed #include <linux/gpio.h> which
> indirectly includes 'plat/cpu.h'. This caused build breakage:
>
> drivers/mfd/omap-usb-host.c: In function 'omap_usbhs_init':
> drivers/mfd/omap-usb-host.c:525:3: error: implicit declaration of function 'cpu_is_omap3430'
> drivers/mfd/omap-usb-host.c:525:3: error: implicit declaration of function 'omap_rev'
> drivers/mfd/omap-usb-host.c:525:43: error: 'OMAP3430_REV_ES2_1' undeclared (first use in this function)
>
> Include <plat/cpu.h> to fix it.
>
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> Cc: Keshava Munegowda <Keshava_mgowda@ti.com>
> ---
>  drivers/mfd/omap-usb-host.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index c8aae66..7e96bb2 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -25,6 +25,7 @@
>  #include <linux/clk.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/spinlock.h>
> +#include <plat/cpu.h>
>  #include <plat/usb.h>
>  #include <linux/pm_runtime.h>
>
> --
> 1.7.1
>

Yes, this seems correct!
But, on which config you are seeing this error?

regards
keshava
