Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab1K1TKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 14:10:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15625 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1K1TKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 14:10:19 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 28 Nov 2011 11:10:18 -0800
Subject: Re: [PATCH] net: rfkill: convert net/rfkill/* to use
 module_platform_driver()
From: Rhyland Klein <rklein@nvidia.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Antonio Ospite <ospite@studenti.unina.it>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
In-Reply-To: <1322471704.2730.1.camel@phoenix>
References: <1322471704.2730.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 28 Nov 2011 11:09:47 -0800
Message-ID: <1322507387.3888.1.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 01:15 -0800, Axel Lin wrote:
> This patch converts the drivers in net/rfkill/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.
> 
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: Antonio Ospite <ospite@studenti.unina.it>
> Cc: Rhyland Klein <rklein@nvidia.com>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  net/rfkill/rfkill-gpio.c      |   13 +------------
>  net/rfkill/rfkill-regulator.c |   12 +-----------
>  2 files changed, 2 insertions(+), 23 deletions(-)
> 
> diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
> index 128677d..ca355e7 100644
> --- a/net/rfkill/rfkill-gpio.c
> +++ b/net/rfkill/rfkill-gpio.c
> @@ -220,18 +220,7 @@ static struct platform_driver rfkill_gpio_driver = {
>  	},
>  };
>  
> -static int __init rfkill_gpio_init(void)
> -{
> -	return platform_driver_register(&rfkill_gpio_driver);
> -}
> -
> -static void __exit rfkill_gpio_exit(void)
> -{
> -	platform_driver_unregister(&rfkill_gpio_driver);
> -}
> -
> -module_init(rfkill_gpio_init);
> -module_exit(rfkill_gpio_exit);
> +module_platform_driver(rfkill_gpio_driver);
>  
>  MODULE_DESCRIPTION("gpio rfkill");
>  MODULE_AUTHOR("NVIDIA");

Gpio part looks good to me.

Acked-by: Rhyland Klein <rklein@nvidia.com>

