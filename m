Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558Ab2AWPZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:25:20 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:41514 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202Ab2AWPZS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:25:18 -0500
Message-ID: <1327332314.2525.25.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [patch v1, kernel version 3.2.1] Source mode for macvlan
 interaface
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Stefan Gula <steweg@ynet.sk>
Cc: Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 23 Jan 2012 16:25:14 +0100
In-Reply-To: <22013455.801327321838477.JavaMail.root@5-MeO-DMT.ynet.sk>
References: <22013455.801327321838477.JavaMail.root@5-MeO-DMT.ynet.sk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 23 janvier 2012 à 13:30 +0100, Stefan Gula a écrit :

> +static void macvlan_forward_sources_one(struct sk_buff *skb,
> +					struct macvlan_dev *vlan)
> +{
> +	struct sk_buff *nskb;
> +	struct net_device *dev;
> +	int len;
> +	int ret;
> +
> +	dev = vlan->dev;
> +	if (unlikely(!(dev->flags & IFF_UP)))
> +		return;
> +
> +	nskb = skb_clone(skb, GFP_ATOMIC);
> +	if (!nskb)
> +		return;
> +
> +	len = nskb->len + ETH_HLEN;
> +	nskb = skb_share_check(nskb, GFP_ATOMIC);
> +	if (!nskb)
> +		return;

I am trying to understand how/why skb_share_check() is needed/useful
after skb_clone() ...



