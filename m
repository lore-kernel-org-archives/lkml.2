Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab1CIUz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 15:55:56 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36360 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239Ab1CIUzz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 15:55:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qdpsqH7LS85VMeBxEUX788ney8fP2X/l+PB0Qt6r8wQc3CvCtww4mcZavFbvNFOE7f
         IrfBJ7saNZEzYewA57MoUWqPxdTNJNtmePXjWJu1EZo7u8Do5I60MvF3TnbzL591YcqQ
         iEeN2vMX+n/mpCgpPJ4iT7X6ss0dyRxyN5rH4=
MIME-Version: 1.0
In-Reply-To: <1299703801-19378-1-git-send-email-vinaysawal@gmail.com>
References: <1299703801-19378-1-git-send-email-vinaysawal@gmail.com>
Date: Wed, 9 Mar 2011 21:55:53 +0100
Message-ID: <AANLkTin6tvLb23pvew7H=1HGmQMsmcMujwZ=i017okku@mail.gmail.com>
Subject: Re: [PATCH] Staging: bcm: Bcmnet: fixed checkpatch script issues
From: Belisko Marek <marek.belisko@gmail.com>
To: Vinay Sawal <vinaysawal@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 9, 2011 at 9:50 PM, Vinay Sawal <vinaysawal@gmail.com> wrote:
> Fixed all issues reported by checkpatch script on this file.
>
> Signed-off-by: Vinay Sawal <vinaysawal@gmail.com>
> ---
>  drivers/staging/bcm/Bcmnet.c |   51 +++++++++++++++++++++++++++++------------
>  1 files changed, 36 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/staging/bcm/Bcmnet.c b/drivers/staging/bcm/Bcmnet.c
> index a6ce239..4e38a76 100644
> --- a/drivers/staging/bcm/Bcmnet.c
> +++ b/drivers/staging/bcm/Bcmnet.c
> @@ -1,3 +1,23 @@
> +/*
> +    bcm/Bcmnet.c
> +    Bcm network driver
> +
> +    This program is free software; you can redistribute it and/or modify
> +    it under the terms of the GNU General Public License as published by
> +    the Free Software Foundation; either version 2 of the License, or
> +    (at your option) any later version.
> +
> +    This program is distributed in the hope that it will be useful,
> +    but WITHOUT ANY WARRANTY; without even the implied warranty of
> +    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +    GNU General Public License for more details.
> +
> +    You should have received a copy of the GNU General Public License
> +    along with this program; if not, write to the Free Software
> +    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> +
> +*/
NOt sure if I miss somethoing but why you add header
if you fix only checkpatch.pl fixes? I don't know that
checkpatch.pl complain about missing header file?
> +
>  #include "headers.h"
>
>  struct net_device *gblpnetdev;
> @@ -8,7 +28,7 @@ static INT bcm_open(struct net_device *dev)
>
>        if (Adapter->fw_download_done == FALSE) {
>                pr_notice(PFX "%s: link up failed (download in progress)\n",
> -                         dev->name);
> +                         dev->name);
>                return -EBUSY;
>        }
>
> @@ -50,7 +70,7 @@ static u16 bcm_select_queue(struct net_device *dev, struct sk_buff *skb)
>  * Description - This is the main transmit function for our virtual
>  *              interface(eth0). It handles the ARP packets. It
>  *              clones this packet and then Queue it to a suitable
> -*              Queue. Then calls the transmit_packet().
> +*              Queue. Then calls the transmit_packet().
>  *
>  * Parameter   -         skb - Pointer to the socket buffer structure
>  *               dev - Pointer to the virtual net device structure
> @@ -110,13 +130,13 @@ static netdev_tx_t bcm_transmit(struct sk_buff *skb, struct net_device *dev)
>  Register other driver entry points with the kernel
>  */
>  static const struct net_device_ops bcmNetDevOps = {
> -    .ndo_open          = bcm_open,
> -    .ndo_stop          = bcm_close,
> -    .ndo_start_xmit    = bcm_transmit,
> -    .ndo_change_mtu    = eth_change_mtu,
> -    .ndo_set_mac_address = eth_mac_addr,
> -    .ndo_validate_addr = eth_validate_addr,
> -    .ndo_select_queue  = bcm_select_queue,
> +       .ndo_open               = bcm_open,
> +       .ndo_stop               = bcm_close,
> +       .ndo_start_xmit         = bcm_transmit,
> +       .ndo_change_mtu         = eth_change_mtu,
> +       .ndo_set_mac_address    = eth_mac_addr,
> +       .ndo_validate_addr      = eth_validate_addr,
> +       .ndo_select_queue       = bcm_select_queue,
>  };
>
>  static struct device_type wimax_type = {
> @@ -138,7 +158,8 @@ static int bcm_get_settings(struct net_device *dev, struct ethtool_cmd *cmd)
>        return 0;
>  }
>
> -static void bcm_get_drvinfo(struct net_device *dev, struct ethtool_drvinfo *info)
> +static void bcm_get_drvinfo(struct net_device *dev,
> +                           struct ethtool_drvinfo *info)
>  {
>        PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(dev);
>        PS_INTERFACE_ADAPTER psIntfAdapter = Adapter->pvInterfaceAdapter;
> @@ -160,14 +181,14 @@ static u32 bcm_get_link(struct net_device *dev)
>        return Adapter->LinkUpStatus;
>  }
>
> -static u32 bcm_get_msglevel (struct net_device *dev)
> +static u32 bcm_get_msglevel(struct net_device *dev)
>  {
>        PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(dev);
>
>        return Adapter->msg_enable;
>  }
>
> -static void bcm_set_msglevel (struct net_device *dev, u32 level)
> +static void bcm_set_msglevel(struct net_device *dev, u32 level)
>  {
>        PMINI_ADAPTER Adapter = GET_BCM_ADAPTER(dev);
>
> @@ -177,7 +198,7 @@ static void bcm_set_msglevel (struct net_device *dev, u32 level)
>  static const struct ethtool_ops bcm_ethtool_ops = {
>        .get_settings   = bcm_get_settings,
>        .get_drvinfo    = bcm_get_drvinfo,
> -       .get_link       = bcm_get_link,
> +       .get_link       = bcm_get_link,
>        .get_msglevel   = bcm_get_msglevel,
>        .set_msglevel   = bcm_set_msglevel,
>  };
> @@ -206,7 +227,7 @@ int register_networkdev(PMINI_ADAPTER Adapter)
>        if (result != STATUS_SUCCESS) {
>                dev_err(&udev->dev,
>                        PFX "Error in Reading the mac Address: %d", result);
> -               return -EIO;
> +               return -EIO;
>        }
>
>        result = register_netdev(net);
> @@ -233,6 +254,6 @@ void unregister_networkdev(PMINI_ADAPTER Adapter)
>        if (netif_msg_probe(Adapter))
>                dev_info(&udev->dev, PFX "%s: unregister usb-%s%s\n",
>                         net->name, xdev->bus->bus_name, xdev->devpath);
> -
> +
>        unregister_netdev(Adapter->dev);
>  }
> --
> 1.6.2.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

thanks,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
icq: 290551086
web: http://open-nandra.com
