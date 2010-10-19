Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0JSPXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 11:23:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60591
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752296Ab0JSPXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 11:23:39 -0400
Date: Tue, 19 Oct 2010 08:24:01 -0700 (PDT)
Message-Id: <20101019.082401.28817543.davem@davemloft.net>
To: xiaohui.xin@intel.com
Cc: netdev@vger.kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, mingo@elte.hu, herbert@gondor.hengli.com.au,
        jdike@linux.intel.com
Subject: Re: [PATCH v13 10/16] Add a hook to intercept external buffers
 from NIC driver.
From: David Miller <davem@davemloft.net>
In-Reply-To: <33f51c5eddec843260451eccbfa3c5fdea13b479.1287132437.git.xiaohui.xin@intel.com>
References: <1287133937-5538-1-git-send-email-xiaohui.xin@intel.com>
	<fc6e95d63a2c62aaf77f8ded22fc43ccefcdbbff.1287132437.git.xiaohui.xin@intel.com>
	<33f51c5eddec843260451eccbfa3c5fdea13b479.1287132437.git.xiaohui.xin@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiaohui.xin@intel.com
Date: Fri, 15 Oct 2010 17:12:11 +0800

> @@ -2891,6 +2922,11 @@ static int __netif_receive_skb(struct sk_buff *skb)
>  ncls:
>  #endif
>  
> +	/* To intercept mediate passthru(zero-copy) packets here */
> +	skb = handle_mpassthru(skb, &pt_prev, &ret, orig_dev);
> +	if (!skb)
> +		goto out;
> +
>  	/* Handle special case of bridge or macvlan */
>  	rx_handler = rcu_dereference(skb->dev->rx_handler);
>  	if (rx_handler) {

If you consume the packet here, devices in passthru mode cannot
be use with bonding.

But there is nothing that prevents a bond being created with such
a device.

So we have to either prevent such configurations (bad) or make
it work somehow (good) :-)
