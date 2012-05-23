Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab2EWHln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:41:43 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57292 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755623Ab2EWHlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:41:42 -0400
Subject: Re: [PATCH] ipv4: fix the rcu race between free_fib_info and
 ip_route_output_slow
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, kunx.jiang@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1337758775.3361.2056.camel@edumazet-glaptop>
References: <4FBB6105.2060808@intel.com>
	 <20120522.151554.106838106733194160.davem@davemloft.net>
	 <1337742123.14538.175.camel@ymzhang.sh.intel.com>
	 <20120522.232310.911242148705021745.davem@davemloft.net>
	 <1337747829.3361.1599.camel@edumazet-glaptop>
	 <1337748897.14538.184.camel@ymzhang.sh.intel.com>
	 <1337749339.3361.1655.camel@edumazet-glaptop>
	 <1337753757.14538.190.camel@ymzhang.sh.intel.com>
	 <1337754459.3361.1850.camel@edumazet-glaptop>
	 <1337755623.14538.194.camel@ymzhang.sh.intel.com>
	 <1337756138.3361.1922.camel@edumazet-glaptop>
	 <1337757238.3361.1965.camel@edumazet-glaptop>
	 <1337757862.14538.199.camel@ymzhang.sh.intel.com>
	 <1337758775.3361.2056.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 09:41:34 +0200
Message-ID: <1337758894.3361.2064.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 09:39 +0200, Eric Dumazet wrote:

> spinlock is needed mainly because of ip_fib_check_default(), but this
> could be changed to use RCU as well. 
> 
> (readers use RCU, writers already hold RTNL -> no more fib_info_lock )

Since its not a fast path and hash table can be resized, its probably
not worth the pain.


