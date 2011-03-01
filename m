Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab1CAH1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 02:27:08 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64957 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755495Ab1CAH1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 02:27:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=V6z74ElVBWNE87nYMhJG0m6cBAsgAIHKdVNrAgiOPqyKh7aQuhkAx9zQ+6DyZ8bAnk
         kvNm8JOzOqXPloRb5IkNXipFm3wNlQfFxHSHJMJq/xDn4iRkLaoJgR+0GL1zrU5+o7OW
         FfJnIOAYRozpHG0S6PIOC0iOALHN4xBtH47s8=
Subject: Re: [PATCH] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bhutchings@solarflare.com, joe@perches.com, dilinger@queued.net,
        mirqus@gmail.com, davem@davemloft.net,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1298962129-1605-1-git-send-email-ratbert.chuang@gmail.com>
References: <1298627845-1583-1-git-send-email-ratbert.chuang@gmail.com>
	 <1298962129-1605-1-git-send-email-ratbert.chuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 08:27:00 +0100
Message-ID: <1298964420.2676.59.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 01 mars 2011 à 14:48 +0800, Po-Yu Chuang a écrit :
> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> 
> FTMAC100 Ethernet Media Access Controller supports 10/100 Mbps and
> MII.  This driver has been working on some ARM/NDS32 SoC's including
> Faraday A320 and Andes AG101.
> 
> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
> ---
> v2:
> always use NAPI
> do not use our own net_device_stats structure
> don't set trans_start and last_rx
> stats.rx_packets and stats.rx_bytes include dropped packets
> add missed netif_napi_del()
> initialize spinlocks in probe function
> remove rx_lock and hw_lock
> use netdev_[err/info/dbg] instead of dev_* ones
> use netdev_alloc_skb_ip_align()
> remove ftmac100_get_stats()
> use is_valid_ether_addr() instead of is_zero_ether_addr()
> add const to ftmac100_ethtool_ops and ftmac100_netdev_ops
> use net_ratelimit() instead of printk_ratelimit()
> no explicit inline
> use %pM to print MAC address
> add comment before wmb
> use napi poll() to handle all interrupts
> 
> v3:
> undo "stats.rx_packets and stats.rx_bytes include dropped packets"
> ftmac100_mdio_read() returns 0 if error
> fix comment typos
> use pr_fmt and pr_info
> define INT_MASK_ALL_ENABLED
> define MACCR_ENABLE_ALL
> do not count length error many times
> use bool/true/false
> use cpu_to_le32/le32_to_cpu to access descriptors
> indent style fix
> 
> v4:
> should not access skb after netif_receive_skb()
> use resource_size()
> better way to use cpu_to_le32/le32_to_cpu
> use spin_lock() for tx_lock
> combine all netdev_info() together in ftmac100_poll()
> 
> v5:
> use dev_kfree_skb() in ftmac100_tx_complete_packet()
> cpu_to_le32/le32_to_cpu usage fix
> drop GFP_DMA
> 
> v6:
> cpu_to_le32/le32_to_cpu usage fix
> remove "tx queue full" message
> reduce critical section protected by tx_lock
> add check of MAX_PKT_SIZE and RX_BUF_SIZE
> add __exit to ftmac100_remove()
> simplify ftmac100_rx_packet()
> zero copy - use skb_fill_page_desc() and __pskb_pull_tail().
> pull more data to skb head to include tcp/ip header
> 
> v7:
> allocate 128 bytes skb and pull 64 bytes only
> 
>  drivers/net/Kconfig    |    9 +
>  drivers/net/Makefile   |    1 +
>  drivers/net/ftmac100.c | 1196 ++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/net/ftmac100.h |  180 ++++++++
>  4 files changed, 1386 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/ftmac100.c
>  create mode 100644 drivers/net/ftmac100.h

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>


