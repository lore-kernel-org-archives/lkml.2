Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942Ab2EKR6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 13:58:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44198 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422632Ab2EKR6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 13:58:09 -0400
Message-ID: <4FAD532E.401@gmail.com>
Date: Fri, 11 May 2012 10:58:06 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        David Miller <davem@davemloft.net>
CC: "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] net: of/phy: fix build error when phylib is built as
 a module
References: <20120510.224352.2149006669429730060.davem@davemloft.net> <1336751221-19127-1-git-send-email-bjorn@mork.no>
In-Reply-To: <1336751221-19127-1-git-send-email-bjorn@mork.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 08:47 AM, Bjørn Mork wrote:
> CONFIG_OF_MDIO is tristate and will be m if PHYLIB is m.  Use
> IS_ENABLED macro to prevent build error:
>
>   ERROR: "of_mdio_find_bus" [drivers/net/phy/mdio-mux.ko] undefined!
>
> Reported-by: Randy Dunlap<rdunlap@xenotime.net>
> Cc: David Daney<david.daney@cavium.com>
> Signed-off-by: Bjørn Mork<bjorn@mork.no>

I was able to reproduce the failure, and this patch both fixes it and 
seems correct, so...

Acked-by: David Daney<david.daney@cavium.com>

Sorry about this failure.


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
>   drivers/net/phy/mdio_bus.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 83d5c9f..683ef1c 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -88,7 +88,7 @@ static struct class mdio_bus_class = {
>   	.dev_release	= mdiobus_release,
>   };
>
> -#ifdef CONFIG_OF_MDIO
> +#if IS_ENABLED(CONFIG_OF_MDIO)
>   /* Helper function for of_mdio_find_bus */
>   static int of_mdio_bus_match(struct device *dev, void *mdio_bus_np)
>   {

