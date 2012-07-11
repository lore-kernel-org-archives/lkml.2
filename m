Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab2GKMvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 08:51:25 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54311 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752668Ab2GKMvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 08:51:24 -0400
X-IronPort-AV: E=Sophos;i="4.77,567,1336320000"; 
   d="scan'208";a="5374209"
Message-ID: <4FFD76DE.4090308@cn.fujitsu.com>
Date: Wed, 11 Jul 2012 20:51:42 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Neil Horman <nhorman@tuxdriver.com>
CC: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lizefan@huawei.com, tj@kernel.org,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v3] net: cgroup: fix access the unallocated memory in
 netprio cgroup
References: <1341995406-12719-1-git-send-email-gaofeng@cn.fujitsu.com> <20120711121102.GB26643@hmsreliant.think-freely.org>
In-Reply-To: <20120711121102.GB26643@hmsreliant.think-freely.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/11 20:51:11,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/11 20:51:14
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年07月11日 20:11, Neil Horman 写道:
> On Wed, Jul 11, 2012 at 04:30:06PM +0800, Gao feng wrote:
>> there are some out of bound accesses in netprio cgroup.
>>
>> now before accessing the dev->priomap.priomap array,we only check
>> if the dev->priomap exist.and because we don't want to see
>> additional bound checkings in fast path, so we should make sure
>> that dev->priomap is null or array size of dev->priomap.priomap
>> is equal to max_prioidx + 1;
>>
>> and it's not needed to call extend_netdev_tabel in write_priomap,
>> we can only allocate the net device's priomap which we change through
>> net_prio.ifpriomap.
>>
>> this patch add a return value for update_netdev_tables & extend_netdev_table,
>> so when new_priomap is allocated failed,write_priomap will stop to access
>> the priomap,and return -ENOMEM back to the userspace to tell the user
>> what happend.
>>
>> Change From v2:
>> 1. protect extend_netdev_table by RTNL.
>> 2. when extend_netdev_table failed,call dev_put to reduce device's refcount.
>>
>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>> Cc: Neil Horman <nhorman@tuxdriver.com>
>> Cc: Eric Dumazet <edumazet@google.com>
>> ---
>>  net/core/netprio_cgroup.c |   54 ++++++++++++++++++++++++++++++++------------
>>  1 files changed, 39 insertions(+), 15 deletions(-)
>>
> I still think the use of max_priomap in write_priomap is racy (please see my
> previous note).
> 
> Neil

Yes, you are right :(
we need a v4 patch.

Thanks!
