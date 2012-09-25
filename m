Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab2IYBWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 21:22:10 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:55109 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750849Ab2IYBWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 21:22:08 -0400
Message-ID: <5061073C.4010002@gmail.com>
Date: Tue, 25 Sep 2012 03:22:04 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] ARM: dove: Fix tauros2 device tree init
References: <1348531338-16624-1-git-send-email-sebastian.hesselbarth@gmail.com> <1348531338-16624-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1348531338-16624-3-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2012 02:02 AM, Sebastian Hesselbarth wrote:
> During the review process of dove DT patches, Tauros2 cache
> init call was changed and DT support added. This patch fixes
> the call to Tauros2 init and adds a DT node. Moreover, plat/irq.h
> include was missing from mach-dove/common.c.
 > ...
> diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
> index b37bef1..343a4bc 100644
> --- a/arch/arm/mach-dove/common.c
> +++ b/arch/arm/mach-dove/common.c
> @@ -32,6 +32,7 @@
>   #include<linux/irq.h>
>   #include<plat/time.h>
>   #include<linux/platform_data/usb-ehci-orion.h>
> +#include<plat/irq.h>
>   #include<plat/common.h>
>   #include<plat/addr-map.h>
>   #include "common.h"
> @@ -399,7 +400,7 @@ static void __init dove_dt_init(void)
>   		(dove_tclk + 499999) / 1000000);
>
>   #ifdef CONFIG_CACHE_TAUROS2
> -	tauros2_init();
> +	tauros2_init(0);
>   #endif
>   	dove_setup_cpu_mbus();
>

I thought about the importance of the individual patches and
except 2/6 all can wait for the next release cycle if too late.

But 2/6 is important because the change in tauros2_init
breaks build on dove.

Sebastian

