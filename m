Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755473Ab2BFQtX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:49:23 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51010 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754464Ab2BFQtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:49:21 -0500
Date: Mon, 06 Feb 2012 11:49:17 -0500 (EST)
Message-Id: <20120206.114917.1450321525231150955.davem@davemloft.net>
To: netdev@pradeepdalvi.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/5] netdev: ethernet dev_alloc_skb to
 netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <59b9c48e067528d94b260b044e1b375c56c97040.1328445742.git.netdev@pradeepdalvi.com>
References: <cf736034e7bd407297e2ea9fbf247fb410eb7b39.1328445742.git.netdev@pradeepdalvi.com>
	<59b9c48e067528d94b260b044e1b375c56c97040.1328445742.git.netdev@pradeepdalvi.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 06 Feb 2012 08:49:19 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Date: Sun,  5 Feb 2012 18:20:10 +0530

> From: Pradeep A Dalvi <netdev@pradeepdalvi.com>
> 
> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>   - Removed extra skb->dev = dev after netdev_alloc_skb
> 
> Signed-off-by: Pradeep A Dalvi <netdev@pradeepdalvi.com>

Applied, but again I had to fix things:

> -    p = dev_alloc_skb(IEEE802_3_SZ + DE4X5_ALIGN + 2);
> +	p = netdev_alloc_skb(dev, IEEE802_3_SZ + DE4X5_ALIGN + 2);
 ...
> -    p = dev_alloc_skb(len + 2);
> +	p = netdev_alloc_skb(dev, len + 2);

Leave existing indentation alone.

> -		skb = dev_alloc_skb(ugeth->ug_info->uf_info.max_rx_buf_length +
> -				    UCC_GETH_RX_DATA_BUF_ALIGNMENT);
> +		skb = netdev_alloc_skb(ugeth->ndev,
> +				ugeth->ug_info->uf_info.max_rx_buf_length +
> +				UCC_GETH_RX_DATA_BUF_ALIGNMENT);

Line up subsequent lines of a multiline series of function arguments
properly, each should start at the first column after the function calls
openning parenthesis.
