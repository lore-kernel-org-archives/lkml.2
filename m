Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab2GIIPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 04:15:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23681 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751937Ab2GIIPP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 04:15:15 -0400
X-IronPort-AV: E=Sophos;i="4.77,551,1336320000"; 
   d="scan'208";a="5354007"
Message-ID: <4FFA9321.4030407@cn.fujitsu.com>
Date: Mon, 09 Jul 2012 16:15:29 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, nhorman@tuxdriver.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        lizefan@huawei.com, tj@kernel.org
Subject: Re: [PATCH] net: cgroup: fix out of bounds accesses
References: <1341819910.3265.2106.camel@edumazet-glaptop>
In-Reply-To: <1341819910.3265.2106.camel@edumazet-glaptop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/09 16:15:01,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/09 16:15:06
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年07月09日 15:45, Eric Dumazet 写道:
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

Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
