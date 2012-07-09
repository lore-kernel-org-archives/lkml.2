Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2GIHSU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 03:18:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53636 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2GIHST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 03:18:19 -0400
Date: Mon, 09 Jul 2012 00:18:18 -0700 (PDT)
Message-Id: <20120709.001818.22457351541916000.davem@davemloft.net>
To: gaofeng@cn.fujitsu.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        nhorman@tuxdriver.com, tj@kernel.org, lizefan@huawei.com,
        eric.dumazet@gmail.com
Subject: Re: [PATCH v2] cgroup: fix panic in netprio_cgroup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1341480520-25081-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1341480520-25081-1-git-send-email-gaofeng@cn.fujitsu.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.97 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gao feng <gaofeng@cn.fujitsu.com>
Date: Thu, 5 Jul 2012 17:28:40 +0800

> we set max_prioidx to the first zero bit index of prioidx_map in
> function get_prioidx.
> 
> So when we delete the low index netprio cgroup and adding a new
> netprio cgroup again,the max_prioidx will be set to the low index.
> 
> when we set the high index cgroup's net_prio.ifpriomap,the function
> write_priomap will call update_netdev_tables to alloc memory which
> size is sizeof(struct netprio_map) + sizeof(u32) * (max_prioidx + 1),
> so the size of array that map->priomap point to is max_prioidx +1,
> which is low than what we actually need.
> 
> fix this by adding check in get_prioidx,only set max_prioidx when
> max_prioidx low than the new prioidx.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>

Applied.
