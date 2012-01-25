Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312Ab2AYEFA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 23:05:00 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:44846 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab2AYEE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 23:04:58 -0500
Date: Tue, 24 Jan 2012 23:03:54 -0500 (EST)
Message-Id: <20120124.230354.1696063062900108959.davem@davemloft.net>
To: steweg@ynet.sk
Cc: kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch v3, kernel version 3.2.1] Source mode for macvlan
 interface
From: David Miller <davem@davemloft.net>
In-Reply-To: <25119746.2341327416953583.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <12446987.2261327416407141.JavaMail.root@5-MeO-DMT.ynet.sk>
	<25119746.2341327416953583.JavaMail.root@5-MeO-DMT.ynet.sk>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 24 Jan 2012 20:03:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Gula <steweg@ynet.sk>
Date: Tue, 24 Jan 2012 15:55:53 +0100 (CET)

> diff -uprN -X linux/Documentation/dontdiff linux-3.2.1-orig/net/core/rtnetlink.c linux/net/core/rtnetlink.c
> --- linux-3.2.1-orig/net/core/rtnetlink.c	2012-01-12 20:42:45.000000000 +0100
> +++ linux/net/core/rtnetlink.c	2012-01-24 14:26:58.083219352 +0100
> @@ -1506,6 +1506,9 @@ errout:
>  
>  	if (send_addr_notify)
>  		call_netdevice_notifiers(NETDEV_CHANGEADDR, dev);
> +	min_ifinfo_dump_size = max_t(u16, if_nlmsg_size(dev),
> +					min_ifinfo_dump_size);
> +

What is this?  And whatever it is why isn't it 1) described in the
commit message and why isn't it 2) in a seperate patch if it's
unrelated to this macvlan change?

I'm not apply this patch as it is right now, it needs some sort of
change.

