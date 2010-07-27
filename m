Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab0G0Uwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 16:52:41 -0400
Received: from mail.perches.com ([173.55.12.10]:2126 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab0G0Uwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 16:52:39 -0400
Subject: Re: [PATCH net-next] drivers/net/bfin_mac.c: Use pr_fmt,
 netdev_<level>
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        uclinux-dist-devel <uclinux-dist-devel@blackfin.uclinux.org>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100727134417.62420ec1@nehalam>
References: <1280258531.24054.10.camel@Joe-Laptop.home>
	 <20100727134417.62420ec1@nehalam>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 27 Jul 2010 13:52:37 -0700
Message-ID: <1280263957.24054.35.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-27 at 13:44 -0700, Stephen Hemminger wrote:
> On Tue, 27 Jul 2010 12:22:11 -0700
> Joe Perches <joe@perches.com> wrote:
> > +static struct sk_buff *bfin_alloc_skb(void)
> > +{
> > +	/* allocate a new skb */
> > +	struct sk_buff *new_skb = dev_alloc_skb(PKT_BUF_SIZE + NET_IP_ALIGN);
> > +
> > +	if (!new_skb)
> > +		return NULL;
> > +
> > +	skb_reserve(new_skb, NET_IP_ALIGN);
>
> Why not use netdev_alloc_skb_ip_align ?

I was consolidating duplicated code.

It could be changed, but right now, desc_list_init isn't
passed a struct netdevice.

Perhaps you'll submit that as a follow-on?


