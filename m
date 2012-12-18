Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730Ab2LRMFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:05:10 -0500
Received: from 94.43.138.210.xn.2iij.net ([210.138.43.94]:56723 "EHLO
	mail.st-paulia.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754123Ab2LRMFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:05:08 -0500
Message-ID: <50D05BF3.3070807@linux-ipv6.org>
Date: Tue, 18 Dec 2012 21:05:07 +0900
From: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Organization: USAGI Project
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: stanley zhou <stanleyru@hotmail.com>
CC: davem@davemloft.net, w.sang@pengutronix.de, laurent.navet@gmail.com,
        ben-linux@fluff.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, khali@linux-fr.org, firedtoad@gmail.com,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Subject: Re: [IPv6] crashed when __ip6_del_rt()
References: <50CF84A5.7030706@linux-ipv6.org>,<50D04B4B.7060002@linux-ipv6.org>,<BAY173-W1475D04C810BF9A1D71FB8B0310@phx.gbl> <BAY173-W14E9D67B7924486F0518F0B0310@phx.gbl>
In-Reply-To: <BAY173-W14E9D67B7924486F0518F0B0310@phx.gbl>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

stanley zhou wrote:

> when call write_lock_bh() table is null cause crash in __ip6_del_rt().
> kernel version is 2.6.30.10
:
> static int __ip6_del_rt(struct rt6_info *rt, struct nl_info *info)
> {
> int err;
> struct fib6_table *table;
> struct net *net = dev_net(rt->rt6i_dev);
> 
> if (rt == net->ipv6.ip6_null_entry) {
> +++err = -ENOENT;
> +++goto out;
> --- return -ENOENT;
> }
> 
> table = rt->rt6i_table;
> write_lock_bh(&table->tb6_lock);
> err = fib6_del(rt, info);
> write_unlock_bh(&table->tb6_lock);
> +++out:
> dst_release(&rt->u.dst);
> return err;
> } 
>  

I think this is what commit 6825a26c ("ipv6: release reference of
ip6_null_entry's dst entry in __ip6_del_rt") by Gao feng
<gaofeng@cn.fujitsu.com> does, which is already in v3.7.

Are you suggesting that we should have this in -stable tree as well?

--yoshfuji


