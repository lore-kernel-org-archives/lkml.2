Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2GIVv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:51:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59569 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab2GIVv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:51:26 -0400
Date: Mon, 09 Jul 2012 14:51:25 -0700 (PDT)
Message-Id: <20120709.145125.1903343847210013668.davem@davemloft.net>
To: gaofeng@cn.fujitsu.com
Cc: eric.dumazet@gmail.com, nhorman@tuxdriver.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        lizefan@huawei.com, tj@kernel.org
Subject: Re: [PATCH] net: cgroup: fix out of bounds accesses
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FFA9321.4030407@cn.fujitsu.com>
References: <1341819910.3265.2106.camel@edumazet-glaptop>
	<4FFA9321.4030407@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gao feng <gaofeng@cn.fujitsu.com>
Date: Mon, 09 Jul 2012 16:15:29 +0800

> 于 2012年07月09日 15:45, Eric Dumazet 写道:
>> From: Eric Dumazet <edumazet@google.com>
>> 
>> dev->priomap is allocated by extend_netdev_table() called from
>> update_netdev_tables().
>> And this is only called if write_priomap() is called.
>> 
>> But if write_priomap() is not called, it seems we can have out of bounds
>> accesses in cgrp_destroy(), read_priomap() & skb_update_prio()
>> 
>> With help from Gao Feng
>> 
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Cc: Neil Horman <nhorman@tuxdriver.com>
>> Cc: Gao feng <gaofeng@cn.fujitsu.com>
>> ---
>> net/core/dev.c            |    8 ++++++--
>> net/core/netprio_cgroup.c |    4 ++--
>> 2 files changed, 8 insertions(+), 4 deletions(-)
> 
> Acked-by: Gao feng <gaofeng@cn.fujitsu.com>

Applied.
