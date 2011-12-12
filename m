Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1LLXvU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 18:51:20 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:41353 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab1LLXvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 18:51:18 -0500
Date: Mon, 12 Dec 2011 18:51:13 -0500 (EST)
Message-Id: <20111212.185113.1211685406728953774.davem@davemloft.net>
To: artisdom@gmail.com
Cc: jpirko@redhat.com, jwboyer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipip, sit: copy parms.name after register_netdevice
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111208104619.GA20150@ted-OptiPlex-380>
References: <CAM7b5hyXkRTUwnE-NwXEff-34WjRfMSBDf2itMVhdJGi4XoA=g@mail.gmail.com>
	<20111207.235602.1465915988125994516.davem@davemloft.net>
	<20111208104619.GA20150@ted-OptiPlex-380>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 12 Dec 2011 15:51:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ted Feng <artisdom@gmail.com>
Date: Thu, 8 Dec 2011 18:46:21 +0800

> From: Ted Feng <artisdom@gmail.com>
> 
> Same fix as 731abb9cb2 for ipip and sit tunnel.
> Commit 1c5cae815d removed an explicit call to dev_alloc_name in
> ipip_tunnel_locate and ipip6_tunnel_locate, because register_netdevice
> will now create a valid name, however the tunnel keeps a copy of the
> name in the private parms structure. Fix this by copying the name back
> after register_netdevice has successfully returned.
> 
> This shows up if you do a simple tunnel add, followed by a tunnel show:
> 
> $ sudo ip tunnel add mode ipip remote 10.2.20.211
> $ ip tunnel
> tunl0: ip/ip  remote any  local any  ttl inherit  nopmtudisc
> tunl%d: ip/ip  remote 10.2.20.211  local any  ttl inherit
> $ sudo ip tunnel add mode sit remote 10.2.20.212
> $ ip tunnel
> sit0: ipv6/ip  remote any  local any  ttl 64  nopmtudisc 6rd-prefix 2002::/16
> sit%d: ioctl 89f8 failed: No such device
> sit%d: ipv6/ip  remote 10.2.20.212  local any  ttl inherit
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ted Feng <artisdom@gmail.com>

Applied.
