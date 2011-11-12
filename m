Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756892Ab1KLB2a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 20:28:30 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:56883 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab1KLB22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 20:28:28 -0500
Date: Fri, 11 Nov 2011 20:28:07 -0500 (EST)
Message-Id: <20111111.202807.1335209533396648252.davem@davemloft.net>
To: horti@google.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        david.decotigny@google.com, ian.campbell@citrix.com,
        rick.jones2@hp.com, eric.dumazet@gmail.com, maheshb@google.com
Subject: Re: [PATCH net-next v1] net-forcedeth: Add internal loopback
 support for forcedeth NICs.
From: David Miller <davem@davemloft.net>
In-Reply-To: <177427773f155c883809613ddf1ce28546aaac3e.1320871300.git.horti@google.com>
References: <cover.1320871300.git.horti@google.com>
	<177427773f155c883809613ddf1ce28546aaac3e.1320871300.git.horti@google.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Fri, 11 Nov 2011 17:28:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sanjay Hortikar <horti@google.com>
Date: Wed,  9 Nov 2011 12:45:25 -0800

> @@ -5124,6 +5266,12 @@ static int nv_open(struct net_device *dev)
>  
>  	spin_unlock_irq(&np->lock);
>  
> +	/* If the loopback feature was set while the device was down, make sure
> +	* that it's set correctly now.
> +	*/

Improperly formatted comment, it should be:

	/*
	 *
	 */

> @@ -5328,6 +5476,10 @@ static int __devinit nv_probe(struct pci_dev *pci_dev, const struct pci_device_i
>  
>  	dev->features |= dev->hw_features;
>  
> +	/* Add loopback capability to the device. */
> +	dev->hw_features |= NETIF_F_LOOPBACK;
> +
> +
>  	np->pause_flags = NV_PAUSEFRAME_RX_CAPABLE | NV_PAUSEFRAME_RX_REQ | NV_PAUSEFRAME_AUTONEG;

Please do not add all of these extra empty lines.
