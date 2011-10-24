Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab1JXWWx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 18:22:53 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:43882 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab1JXWWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 18:22:51 -0400
Date: Mon, 24 Oct 2011 18:21:42 -0400 (EDT)
Message-Id: <20111024.182142.2299822581628382143.davem@davemloft.net>
To: kth3321@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, romieu@fr.zoreil.com,
        suhwan@wiznet.co.kr, bongbong@wiznet.co.kr
Subject: Re: [PATCH net-next] w5300: add WIZnet W5300 Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1319272916-5541-1-git-send-email-kth3321@gmail.com>
References: <1319272916-5541-1-git-send-email-kth3321@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 24 Oct 2011 15:21:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Taehun Kim <kth3321@gmail.com>
Date: Sat, 22 Oct 2011 17:41:56 +0900

> +struct wiz_private {
> +	void __iomem *base;
> +	struct net_device *dev;
> +	u8 rxbuf_conf[MAX_SOCK_NUM];
> +	u8 txbuf_conf[MAX_SOCK_NUM];
> +	struct net_device_stats stats;
> +	struct napi_struct napi;
> +	spinlock_t lock;
> +	u32 msg_enable;
> +};

You don't need to have a private net_device_stats, just use the
one in struct net_device, and then you can also get rid of your
private ->ndo_get_stats() method.
