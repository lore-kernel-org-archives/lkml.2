Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab2BFRHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 12:07:46 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51175 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab2BFRHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 12:07:45 -0500
Date: Mon, 06 Feb 2012 12:07:40 -0500 (EST)
Message-Id: <20120206.120740.1750013890695365167.davem@davemloft.net>
To: netdev@pradeepdalvi.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 4/5] netdev: ethernet dev_alloc_skb to
 netdev_alloc_skb
From: David Miller <davem@davemloft.net>
In-Reply-To: <d8ad7b1e88df72e284cbc8b8fba1745530923375.1328445742.git.netdev@pradeepdalvi.com>
References: <cf736034e7bd407297e2ea9fbf247fb410eb7b39.1328445742.git.netdev@pradeepdalvi.com>
	<d8ad7b1e88df72e284cbc8b8fba1745530923375.1328445742.git.netdev@pradeepdalvi.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 06 Feb 2012 09:07:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Pradeep A. Dalvi" <netdev@pradeepdalvi.com>
Date: Sun,  5 Feb 2012 18:21:05 +0530

> From: Pradeep A Dalvi <netdev@pradeepdalvi.com>
> 
> Replaced deprecating dev_alloc_skb with netdev_alloc_skb in drivers/net/ethernet
>   - Removed extra skb->dev = dev after netdev_alloc_skb
> 
> Signed-off-by: Pradeep A Dalvi <netdev@pradeepdalvi.com>

I'm not applying this, you screw up the code formatting in too
many locations.

Do NOT take the output of checkpatch literally, look at the result
and determine on your own whether it looks reasonable or not:

> -		struct sk_buff *skb = dev_alloc_skb(np->rx_buf_sz + NV_RX_ALLOC_PAD);
> +		struct sk_buff *skb =
> +			netdev_alloc_skb(dev, np->rx_buf_sz + NV_RX_ALLOC_PAD);

This, looks like crap.  The longer line is better.

> -			struct sk_buff *skb = dev_alloc_skb(hmp->rx_buf_sz + 2);
> +			struct sk_buff *skb = netdev_alloc_skb(dev,
> +					hmp->rx_buf_sz + 2);

Same thing here.

> -			struct sk_buff *skb = dev_alloc_skb(yp->rx_buf_sz + 2);
> +			struct sk_buff *skb = netdev_alloc_skb(dev,
> +					yp->rx_buf_sz + 2);

Column line-up rule violated, and this looks like crap as a result.  The long
single line would look 100 times better.

And there are many other instances of this problem.

Here's my advice, just do the textual change of the function name and add
the network device argument, don't mess with the coding style at all.

You're fare much better than how these patches ended up in the cases where
you tried to "improve" things.
