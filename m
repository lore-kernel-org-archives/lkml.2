Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2AWUxI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 15:53:08 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43819 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab2AWUxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 15:53:06 -0500
MIME-Version: 1.0
In-Reply-To: <1327343540-30348-1-git-send-email-torne@google.com>
References: <1327343540-30348-1-git-send-email-torne@google.com>
Date: Mon, 23 Jan 2012 15:53:05 -0500
Message-ID: <CAP=VYLqpUun0FtCs4VWDeLm-mAri=+UV3psRA12eVbV1So_c-Q@mail.gmail.com>
Subject: Re: [PATCH] r8169: Randomise invalid MAC addresses
From: Paul Gortmaker <paul.gortmaker@gmail.com>
To: "Torne (Richard Coles)" <torne@google.com>
Cc: nic_swsd@realtek.com, romieu@fr.zoreil.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 1:32 PM, Torne (Richard Coles) <torne@google.com> wrote:
> From: "Torne (Richard Coles)" <torne@google.com>
>
> If the default MAC address stored in the card is invalid, replace it
> with a random address and complain about it.

You might want to have a look at this thread and its outcome.

https://lkml.org/lkml/2012/1/14/75

Paul.

>
> Signed-off-by: Torne (Richard Coles) <torne@google.com>
> ---
>  drivers/net/ethernet/realtek/r8169.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
> index 7a0c800..ec5ebbb 100644
> --- a/drivers/net/ethernet/realtek/r8169.c
> +++ b/drivers/net/ethernet/realtek/r8169.c
> @@ -4103,6 +4103,14 @@ rtl8169_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>        /* Get MAC address */
>        for (i = 0; i < ETH_ALEN; i++)
>                dev->dev_addr[i] = RTL_R8(MAC0 + i);
> +
> +       if (!is_valid_ether_addr(dev->dev_addr)) {
> +               /* Report it and use a random ethernet address instead */
> +               netdev_err(dev, "Invalid MAC address: %pM\n", dev->dev_addr);
> +               random_ether_addr(dev->dev_addr);
> +               netdev_info(dev, "Using random MAC address: %pM\n",
> +                           dev->dev_addr);
> +       }
>        memcpy(dev->perm_addr, dev->dev_addr, dev->addr_len);
>
>        SET_ETHTOOL_OPS(dev, &rtl8169_ethtool_ops);
> --
> 1.7.7.3
>
> --
> To unsubscribe from this list: send the line "unsubscribe netdev" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
