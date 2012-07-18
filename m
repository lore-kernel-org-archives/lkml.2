Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab2GRBQa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 21:16:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47050 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751566Ab2GRBQR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 21:16:17 -0400
Message-ID: <1342574175.2012.12.camel@joe2Laptop>
Subject: Re: [PATCH] staging/et131x: fix checkpatch warnings
From: Joe Perches <joe@perches.com>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Einon <mark.einon@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 17 Jul 2012 18:16:15 -0700
In-Reply-To: <1342573366-8167-1-git-send-email-yamanetoshi@gmail.com>
References: <1342442513-10488-1-git-send-email-yamanetoshi@gmail.com>
	 <1342573366-8167-1-git-send-email-yamanetoshi@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-18 at 10:02 +0900, Toshiaki Yamane wrote:
> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>

Hello.  Just some trivial notes:

> diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
[]
> @@ -2553,8 +2555,8 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
[]
> -	printk(KERN_INFO "Packet Status Ring %lx\n",
> -	    (unsigned long) rx_ring->ps_ring_physaddr);
> +	pr_info("Packet Status Ring %lx\n",
> +		(unsigned long) rx_ring->ps_ring_physaddr);
> @@ -2574,7 +2576,7 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
[]
> -	printk(KERN_INFO "PRS %lx\n", (unsigned long)rx_ring->rx_status_bus);
> +	pr_info("PRS %lx\n", (unsigned long)rx_ring->rx_status_bus);

These might as well use %p without a cast to unsigned long
	pr_info("Packet Status Ring: %p\n", rx_ring->ps_ring_phydaddr);
[]
	pr_info("PRS: %p\n", rx_ring->rx_status_bus);

[]
> @@ -5186,8 +5188,8 @@ static int et131x_set_mac_addr(struct net_device *netdev, void *new_mac)
[]
> -	printk(KERN_INFO "%s: Setting MAC address to %pM\n",
> -			netdev->name, netdev->dev_addr);
> +	pr_info("%s: Setting MAC address to %pM\n",
> +		netdev->name, netdev->dev_addr);

Please use netdev_<level> when there is a
struct net_device * available.

	netdev_info(netdev, "Setting MAC address to %pM\n", netdev->dev_addr);


