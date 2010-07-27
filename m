Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0G0UoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 16:44:20 -0400
Received: from mail.vyatta.com ([76.74.103.46]:56639 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751915Ab0G0UoT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 16:44:19 -0400
Date: Tue, 27 Jul 2010 13:44:17 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Joe Perches <joe@perches.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] drivers/net/bfin_mac.c: Use pr_fmt,
 netdev_<level>
Message-ID: <20100727134417.62420ec1@nehalam>
In-Reply-To: <1280258531.24054.10.camel@Joe-Laptop.home>
References: <1280258531.24054.10.camel@Joe-Laptop.home>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 12:22:11 -0700
Joe Perches <joe@perches.com> wrote:

>  
> +static struct sk_buff *bfin_alloc_skb(void)
> +{
> +	/* allocate a new skb */
> +	struct sk_buff *new_skb = dev_alloc_skb(PKT_BUF_SIZE + NET_IP_ALIGN);
> +
> +	if (!new_skb)
> +		return NULL;
> +
> +	skb_reserve(new_skb, NET_IP_ALIGN);

Why not use netdev_alloc_skb_ip_align ?

-- 
