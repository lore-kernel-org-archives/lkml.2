Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104Ab2EWGqP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:46:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:14242 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab2EWGqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:46:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="146625192"
Message-ID: <1337755623.14538.194.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH] ipv4: fix the rcu race between free_fib_info and
 ip_route_output_slow
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, kunx.jiang@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 14:47:03 +0800
In-Reply-To: <1337754459.3361.1850.camel@edumazet-glaptop>
References: <4FBB6105.2060808@intel.com>
	 <20120522.151554.106838106733194160.davem@davemloft.net>
	 <1337742123.14538.175.camel@ymzhang.sh.intel.com>
	 <20120522.232310.911242148705021745.davem@davemloft.net>
	 <1337747829.3361.1599.camel@edumazet-glaptop>
	 <1337748897.14538.184.camel@ymzhang.sh.intel.com>
	 <1337749339.3361.1655.camel@edumazet-glaptop>
	 <1337753757.14538.190.camel@ymzhang.sh.intel.com>
	 <1337754459.3361.1850.camel@edumazet-glaptop>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 08:27 +0200, Eric Dumazet wrote:
> On Wed, 2012-05-23 at 14:15 +0800, Yanmin Zhang wrote:
> 
> > 
> > Besides fi->fib_dev here, we need check fi->fib_hash, fi->fib_lhash,
> > and nexthop_nh->nh_hash.
> 
> No, its not needed.
I am checking it now.
fib_create_info=>fib_find_info, but fib_find_info is not protected by
fib_info_lock. See the codes:


link_it:
        ofi = fib_find_info(fi);
        if (ofi) {
                fi->fib_dead = 1;
                free_fib_info(fi);
                ofi->fib_treeref++;
                return ofi;
        }

> 
> I am sending a patch, because I feel this area is too complex for non
> netdev guys.
Indeed, it's complicated. I will test your patches.


