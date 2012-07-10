Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752698Ab2GJCdE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:33:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61519 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752130Ab2GJCdC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:33:02 -0400
X-IronPort-AV: E=Sophos;i="4.77,556,1336320000"; 
   d="scan'208";a="5358991"
Message-ID: <4FFB9473.4040203@cn.fujitsu.com>
Date: Tue, 10 Jul 2012 10:33:23 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: eric.dumazet@gmail.com, nhorman@tuxdriver.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        lizefan@huawei.com, tj@kernel.org
Subject: Re: [PATCH] net: cgroup: fix out of bounds accesses
References: <1341819910.3265.2106.camel@edumazet-glaptop> <4FFA9321.4030407@cn.fujitsu.com> <20120709.145125.1903343847210013668.davem@davemloft.net>
In-Reply-To: <20120709.145125.1903343847210013668.davem@davemloft.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/10 10:32:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/10 10:32:56
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年07月10日 05:51, David Miller 写道:
> From: Gao feng <gaofeng@cn.fujitsu.com>
> Date: Mon, 09 Jul 2012 16:15:29 +0800
> 
>> 于 2012年07月09日 15:45, Eric Dumazet 写道:
>>> From: Eric Dumazet <edumazet@google.com>
>>>
>>> dev->priomap is allocated by extend_netdev_table() called from
>>> update_netdev_tables().
>>> And this is only called if write_priomap() is called.
>>>
>>> But if write_priomap() is not called, it seems we can have out of bounds
>>> accesses in cgrp_destroy(), read_priomap() & skb_update_prio()
>>>
>>> With help from Gao Feng
>>>
>>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>>> Cc: Neil Horman <nhorman@tuxdriver.com>
>>> Cc: Gao feng <gaofeng@cn.fujitsu.com>
>>> ---
>>> net/core/dev.c            |    8 ++++++--
>>> net/core/netprio_cgroup.c |    4 ++--
>>> 2 files changed, 8 insertions(+), 4 deletions(-)
>>
>> Acked-by: Gao feng <gaofeng@cn.fujitsu.com>
> 
> Applied.
> 

Hi David

Please see my patch in this thread, I think it's a better way to fix this bug.

Thanks.
