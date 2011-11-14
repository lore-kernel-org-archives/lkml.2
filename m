Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752959Ab1KNFZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 00:25:00 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:43554 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab1KNFY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 00:24:59 -0500
Date: Mon, 14 Nov 2011 00:24:56 -0500 (EST)
Message-Id: <20111114.002456.1590067179487443754.davem@davemloft.net>
To: jwboyer@redhat.com
Cc: jpirko@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] ip6_tunnel: copy parms.name after register_netdevice
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111111011023.GE2170@zod.bos.redhat.com>
References: <20111111011023.GE2170@zod.bos.redhat.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 13 Nov 2011 21:24:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Josh Boyer <jwboyer@redhat.com>
Date: Thu, 10 Nov 2011 20:10:23 -0500

> @@ -288,6 +288,8 @@ static struct ip6_tnl *ip6_tnl_create(struct net *net, struct ip6_tnl_parm *p)
>  
>  	if ((err = register_netdevice(dev)) < 0)
>  		goto failed_free;
> +	
> +	strcpy(t->parms.name, dev->name);

Trailing whitespace on that blank line you're adding.

I fixed this up, applied, and queued up for -stable, thanks.
