Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759Ab1KJSqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 13:46:09 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64192 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932685Ab1KJSqF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 13:46:05 -0500
MIME-Version: 1.0
In-Reply-To: <30a7c46d924c29d1faf879bc9522e4ec8565d378.1320875577.git.david.decotigny@google.com>
References: <cover.1320875577.git.david.decotigny@google.com> <30a7c46d924c29d1faf879bc9522e4ec8565d378.1320875577.git.david.decotigny@google.com>
From: David Decotigny <david.decotigny@google.com>
Date: Thu, 10 Nov 2011 10:45:43 -0800
Message-ID: <CAG88wWbq4Gn-DTTkNNQkzG7p7db1xEUYmPYQNx0oKZP8FetJZA@mail.gmail.com>
Subject: Re: [PATCH net-next v1 4/9] forcedeth: stats for rx_packets based on
 hardware registers
To: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        David Decotigny <david.decotigny@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

After discussion with original author of patch  "forcedeth: statistics
optimization" (21828163b2b31e0675cb3e66a2a4a231dec06236), I will
revise this strategy, and step back to using software counters to make
the accounting of packets received at software level more accurate.
Will send an update to this series shortly.

Regards,

--
David Decotigny


On Wed, Nov 9, 2011 at 2:09 PM, David Decotigny
<david.decotigny@google.com> wrote:
> Use the hardware registers instead of a software implementation to
> account for the number of RX packets.
>
>
>
> Signed-off-by: David Decotigny <david.decotigny@google.com>
> ---
>  drivers/net/ethernet/nvidia/forcedeth.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index cd7f83d..0071d5c 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -1712,6 +1712,7 @@ static struct net_device_stats *nv_get_stats(struct net_device *dev)
>                nv_get_hw_stats(dev);
>
>                /* copy to net_device stats */
> +               dev->stats.rx_packets = np->estats.rx_packets;
>                dev->stats.tx_packets = np->estats.tx_packets;
>                dev->stats.rx_bytes = np->estats.rx_bytes;
>                dev->stats.tx_bytes = np->estats.tx_bytes;
> @@ -2690,7 +2691,6 @@ static int nv_rx_process(struct net_device *dev, int limit)
>                skb_put(skb, len);
>                skb->protocol = eth_type_trans(skb, dev);
>                napi_gro_receive(&np->napi, skb);
> -               dev->stats.rx_packets++;
>  next_pkt:
>                if (unlikely(np->get_rx.orig++ == np->last_rx.orig))
>                        np->get_rx.orig = np->first_rx.orig;
> @@ -2773,7 +2773,6 @@ static int nv_rx_process_optimized(struct net_device *dev, int limit)
>                                __vlan_hwaccel_put_tag(skb, vid);
>                        }
>                        napi_gro_receive(&np->napi, skb);
> -                       dev->stats.rx_packets++;
>                } else {
>                        dev_kfree_skb(skb);
>                }
> --
> 1.7.3.1
>
>
