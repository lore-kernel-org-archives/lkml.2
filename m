Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2GIM4g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 08:56:36 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:43516 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2GIM4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 08:56:34 -0400
Date: Mon, 9 Jul 2012 08:56:22 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lizefan@huawei.com, tj@kernel.org,
        Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] net: cgroup: fix out of bounds accesses
Message-ID: <20120709125622.GD9186@hmsreliant.think-freely.org>
References: <1341819910.3265.2106.camel@edumazet-glaptop>
 <20120709110154.GB9186@hmsreliant.think-freely.org>
 <1341834652.3265.2642.camel@edumazet-glaptop>
 <20120709121350.GC9186@hmsreliant.think-freely.org>
 <1341837625.3265.2748.camel@edumazet-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341837625.3265.2748.camel@edumazet-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 02:40:25PM +0200, Eric Dumazet wrote:
> On Mon, 2012-07-09 at 08:13 -0400, Neil Horman wrote:
> > On Mon, Jul 09, 2012 at 01:50:52PM +0200, Eric Dumazet wrote:
> > > On Mon, 2012-07-09 at 07:01 -0400, Neil Horman wrote:
> > > 
> > > > Thank you for doing this Eric, Gao.  Just to be sure (I asked in the previous
> > > > thread), would it be better to avoid the length check in skb_update_prio, and
> > > > instead update the netdev tables to be long enough in cgrp_create and in
> > > > netprio_device_event on device registration?
> > > 
> > > Yes probably, and it is even needed because extend_netdev_table() can
> > > acutally fail to expand the table if kzalloc() returned NULL.
> > > 
> > > Current code just ignores this allocation failure so we also can crash
> > > in write_priomap()
> > > 
> > ACK, can you follow up with a patch please?
> 
> Gao was working on this allocation problem (he privately sent me a v1 of
> his patch), so I think we can wait Gao submit a v2 to combine all the
> work/ideas in a single patch.
> 
> (ie make sure we dont need additional bound checkings in fast path)
> 
> 
Ok, I agree.  thanks!
Neil

> 
> 
