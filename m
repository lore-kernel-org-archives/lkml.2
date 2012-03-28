Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766Ab2C1VqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:46:07 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:56824 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758278Ab2C1VqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:46:04 -0400
Date: Wed, 28 Mar 2012 17:45:59 -0400 (EDT)
Message-Id: <20120328.174559.650861844028495880.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: suspicious RCU usage warnings in 3.3.0
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1203281134090.13691@math.ut.ee>
References: <alpine.SOC.1.00.1203281134090.13691@math.ut.ee>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 28 Mar 2012 14:46:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Wed, 28 Mar 2012 11:45:48 +0300 (EEST)

> Is this the same RCU problem that was fixed after 3.3 (fix a potential 
> rcu_read_lock() imbalance in rt6_fill_node())? My problem does not seem 
> to be ipv6-only, most traces are from IPv6 but some for ip.

It's hard to say because the ipv6 RCU problem causes the warning to
trigger somewhere away from the ipv6 code that had the RCU locking
bug.

We essentially return back into userspace with the RCU lock held, so
the next time we go into the kernel for that thread and do RCU locking
is when we'll notice the problem.
