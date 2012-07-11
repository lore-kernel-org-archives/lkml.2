Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753114Ab2GKI7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 04:59:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47581 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab2GKI7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 04:59:10 -0400
Subject: Re: [PATCH v3] net: cgroup: fix access the unallocated memory in
 netprio cgroup
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Gao feng <gaofeng@cn.fujitsu.com>
Cc: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lizefan@huawei.com, tj@kernel.org,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>
In-Reply-To: <1341995406-12719-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1341995406-12719-1-git-send-email-gaofeng@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Jul 2012 10:59:04 +0200
Message-ID: <1341997144.3265.7263.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 16:30 +0800, Gao feng wrote:
> there are some out of bound accesses in netprio cgroup.
> 
> now before accessing the dev->priomap.priomap array,we only check
> if the dev->priomap exist.and because we don't want to see
> additional bound checkings in fast path, so we should make sure
> that dev->priomap is null or array size of dev->priomap.priomap
> is equal to max_prioidx + 1;
> 
> and it's not needed to call extend_netdev_tabel in write_priomap,
> we can only allocate the net device's priomap which we change through
> net_prio.ifpriomap.
> 
> this patch add a return value for update_netdev_tables & extend_netdev_table,
> so when new_priomap is allocated failed,write_priomap will stop to access
> the priomap,and return -ENOMEM back to the userspace to tell the user
> what happend.
> 
> Change From v2:
> 1. protect extend_netdev_table by RTNL.
> 2. when extend_netdev_table failed,call dev_put to reduce device's refcount.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Cc: Eric Dumazet <edumazet@google.com>
> ---
>  

Acked-by: Eric Dumazet <edumazet@google.com>


