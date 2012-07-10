Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab2GJJPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:15:25 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:38517 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2GJJPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:15:23 -0400
Subject: Re: [PATCH] net: cgroup: fix access the unallocated memory in
 netprio cgroup
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: nhorman@tuxdriver.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lizefan@huawei.com, tj@kernel.org,
        Eric Dumazet <edumazet@google.com>
In-Reply-To: <4FFBED84.1030905@cn.fujitsu.com>
References: <1341837625.3265.2748.camel@edumazet-glaptop>
	 <1341887508-20302-1-git-send-email-gaofeng@cn.fujitsu.com>
	 <1341893650.3265.3974.camel@edumazet-glaptop>
	 <4FFBED84.1030905@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 10 Jul 2012 11:15:07 +0200
Message-ID: <1341911707.3265.4603.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-10 at 16:53 +0800, Gao feng wrote:
> > Hi Gao
> > 
> > Is it still needed to call update_netdev_tables() from write_priomap() ?
> > 
> 
> Yes, I think it's needed,because read_priomap will show all of the net devices,
> 
> But we may add the netdev after create a netprio cgroup, so the new added netdev's
> priomap will not be allocated. if we don't call update_netdev_tables in write_priomap,
> we may access this unallocated memory.
> 

I realize my question was not clear.

If we write in write_priomap() a field of a single netdevice,
why should we allocate memory for all netdevices on the machine ?

So the question was : Do we really need to call
update_netdev_tables(alldevs), instead of extend_netdev_table(dev)



