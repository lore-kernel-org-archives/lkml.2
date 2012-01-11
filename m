Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab2AKOrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 09:47:35 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56531 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2AKOrc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 09:47:32 -0500
MIME-Version: 1.0
In-Reply-To: <1326189567-21663-3-git-send-email-florian@openwrt.org>
References: <1326189567-21663-1-git-send-email-florian@openwrt.org>
	<1326189567-21663-3-git-send-email-florian@openwrt.org>
Date: Wed, 11 Jan 2012 22:47:31 +0800
Message-ID: <CAA_GA1fJAsjmcZ6ixoMajut0U1V+gNewFqDkhdOjS8Btd-4O3Q@mail.gmail.com>
Subject: Re: [PATCH 02/21] bfin_mac: use an unique MDIO bus name.
From: Bob Liu <lliubbo@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Bob Liu <bob.liu@analog.com>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 5:59 PM, Florian Fainelli <florian@openwrt.org> wrote:
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
>  drivers/net/ethernet/adi/bfin_mac.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/ethernet/adi/bfin_mac.c b/drivers/net/ethernet/adi/bfin_mac.c
> index b6d69c9..d812a10 100644
> --- a/drivers/net/ethernet/adi/bfin_mac.c
> +++ b/drivers/net/ethernet/adi/bfin_mac.c
> @@ -1670,7 +1670,8 @@ static int __devinit bfin_mii_bus_probe(struct platform_device *pdev)
>        miibus->name = "bfin_mii_bus";
>        miibus->phy_mask = mii_bus_pd->phy_mask;
>
> -       snprintf(miibus->id, MII_BUS_ID_SIZE, "0");
> +       snprintf(miibus->id, MII_BUS_ID_SIZE, "%s-%x",
> +               pdev->name, pdev->id);
>        miibus->irq = kmalloc(sizeof(int)*PHY_MAX_ADDR, GFP_KERNEL);
>        if (!miibus->irq)
>                goto out_err_irq_alloc;
> --
> 1.7.5.4

Looks fine for me.  Thanks.

Acked-by: Bob Liu <lliubbo@gmail.com>

-- 
Regards,
--Bob
