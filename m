Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761195Ab2EKXuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 19:50:07 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:44574 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1760447Ab2EKXuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 19:50:04 -0400
Message-ID: <4FADA5B9.1060303@xenotime.net>
Date: Fri, 11 May 2012 16:50:17 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: David Miller <davem@davemloft.net>, paul.gortmaker@windriver.com,
        sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, david.daney@cavium.com
Subject: Re: [PATCH] net: of/phy: fix build error when phylib is built as
 a module
References: <20120510.224352.2149006669429730060.davem@davemloft.net> <1336751221-19127-1-git-send-email-bjorn@mork.no>
In-Reply-To: <1336751221-19127-1-git-send-email-bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 08:47 AM, Bjørn Mork wrote:

> CONFIG_OF_MDIO is tristate and will be m if PHYLIB is m.  Use
> IS_ENABLED macro to prevent build error:
> 
>  ERROR: "of_mdio_find_bus" [drivers/net/phy/mdio-mux.ko] undefined!
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Cc: David Daney <david.daney@cavium.com>
> Signed-off-by: Bjørn Mork <bjorn@mork.no>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.


> ---
> I wonder if this could be as banal as this?  Not even build tested...
> 
> Should be wrapped into commit 25106022 if it works, to ensure
> bisectability.
> 
> 
> 
> Bjørn
> 
>  drivers/net/phy/mdio_bus.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 83d5c9f..683ef1c 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -88,7 +88,7 @@ static struct class mdio_bus_class = {
>  	.dev_release	= mdiobus_release,
>  };
>  
> -#ifdef CONFIG_OF_MDIO
> +#if IS_ENABLED(CONFIG_OF_MDIO)
>  /* Helper function for of_mdio_find_bus */
>  static int of_mdio_bus_match(struct device *dev, void *mdio_bus_np)
>  {



-- 
~Randy
