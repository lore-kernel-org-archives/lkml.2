Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab2GILCH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:02:07 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42257 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752917Ab2GILCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:02:04 -0400
Date: Mon, 9 Jul 2012 07:01:54 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lizefan@huawei.com, tj@kernel.org,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] net: cgroup: fix out of bounds accesses
Message-ID: <20120709110154.GB9186@hmsreliant.think-freely.org>
References: <1341819910.3265.2106.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341819910.3265.2106.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 09:45:10AM +0200, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> dev->priomap is allocated by extend_netdev_table() called from
> update_netdev_tables().
> And this is only called if write_priomap() is called.
> 
> But if write_priomap() is not called, it seems we can have out of bounds
> accesses in cgrp_destroy(), read_priomap() & skb_update_prio()
> 
> With help from Gao Feng
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Gao feng <gaofeng@cn.fujitsu.com>
> ---
> net/core/dev.c            |    8 ++++++--
> net/core/netprio_cgroup.c |    4 ++--
> 2 files changed, 8 insertions(+), 4 deletions(-)
> 

Thank you for doing this Eric, Gao.  Just to be sure (I asked in the previous
thread), would it be better to avoid the length check in skb_update_prio, and
instead update the netdev tables to be long enough in cgrp_create and in
netprio_device_event on device registration?

Neil

