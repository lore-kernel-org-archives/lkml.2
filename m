Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab2EVTP7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:15:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:50013 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750823Ab2EVTP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:15:58 -0400
Date: Tue, 22 May 2012 15:15:54 -0400 (EDT)
Message-Id: <20120522.151554.106838106733194160.davem@davemloft.net>
To: kunx.jiang@intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        yanmin_zhang@linux.intel.com
Subject: Re: [PATCH] ipv4: fix the rcu race between free_fib_info and
 ip_route_output_slow
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FBB6105.2060808@intel.com>
References: <4FBB6105.2060808@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 22 May 2012 12:15:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "kun.jiang" <kunx.jiang@intel.com>
Date: Tue, 22 May 2012 17:48:53 +0800

> From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> 
> We hit a kernel OOPS.
 ...
> In function free_fib_info, we don't reset nexthop_nh->nh_dev to NULL before releasing
> nh_dev. kfree_rcu(fi, rcu) would release the whole area.
> 
> Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
> Signed-off-by: Kun Jiang <kunx.jiang@intel.com>

This isn't a fix.  You're keeping around a pointer to a completely
released object, which is therefore illegal to dereference.

That's why we must set it to NULL, to catch such illegal accesses.
