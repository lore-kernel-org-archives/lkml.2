Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751190Ab2JCTXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 15:23:33 -0400
Received: from londo.lunn.ch ([80.238.139.98]:43901 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab2JCTXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 15:23:32 -0400
Date: Wed, 3 Oct 2012 21:23:23 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org
Subject: Re: [PATCH] ARM: mv78xx0: correct addr_map_cfg __initdata annotation
Message-ID: <20121003192323.GB25766@lunn.ch>
References: <201210031906.35123.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210031906.35123.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 07:06:34PM +0000, Arnd Bergmann wrote:
> The annotation on the addr_map_cfg variable is in the wrong place.
> 
> Without this patch, building mv78xx0_defconfig results in:
> 
> /home/arnd/linux-arm/arch/arm/mach-mv78xx0/addr-map.c:59:2: warning: initialization from incompatible pointer type [enabled by default]
> /home/arnd/linux-arm/arch/arm/mach-mv78xx0/addr-map.c:59:2: warning: (near initialization for 'addr_map_cfg.win_cfg_base') [enabled by default]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> ---
> Queued in the late/fixes branch
> 
> diff --git a/arch/arm/mach-mv78xx0/addr-map.c b/arch/arm/mach-mv78xx0/addr-map.c
> index a9bc841..03f7486 100644
> --- a/arch/arm/mach-mv78xx0/addr-map.c
> +++ b/arch/arm/mach-mv78xx0/addr-map.c
> @@ -53,7 +53,7 @@ static void __init __iomem *win_cfg_base(const struct orion_addr_map_cfg *cfg, i
>  /*
>   * Description of the windows needed by the platform code
>   */
> -static struct __initdata orion_addr_map_cfg addr_map_cfg = {
> +static struct orion_addr_map_cfg addr_map_cfg __initdata = {
>  	.num_wins = 14,
>  	.remappable_wins = 8,
>  	.win_cfg_base = win_cfg_base,

Humm, been there, done that once. Must of forgotten to post it. :-(

Acked-by: Andrew Lunn <andrew@lunn.ch>
