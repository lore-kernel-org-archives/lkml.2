Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab2GJJgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 05:36:31 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:58455 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab2GJJga convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 05:36:30 -0400
X-IronPort-AV: E=Sophos;i="4.77,559,1336320000"; 
   d="scan'208";a="5364631"
Message-ID: <4FFBF7B2.9070609@cn.fujitsu.com>
Date: Tue, 10 Jul 2012 17:36:50 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: nhorman@tuxdriver.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lizefan@huawei.com, tj@kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] net: cgroup: fix access the unallocated memory in netprio
 cgroup
References: <1341837625.3265.2748.camel@edumazet-glaptop>  <1341887508-20302-1-git-send-email-gaofeng@cn.fujitsu.com>  <1341893650.3265.3974.camel@edumazet-glaptop>  <4FFBED84.1030905@cn.fujitsu.com> <1341911707.3265.4603.camel@edumazet-glaptop>
In-Reply-To: <1341911707.3265.4603.camel@edumazet-glaptop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/10 17:36:20,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/10 17:36:23
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年07月10日 17:15, Eric Dumazet 写道:
> On Tue, 2012-07-10 at 16:53 +0800, Gao feng wrote:
>>> Hi Gao
>>>
>>> Is it still needed to call update_netdev_tables() from write_priomap() ?
>>>
>>
>> Yes, I think it's needed,because read_priomap will show all of the net devices,
>>
>> But we may add the netdev after create a netprio cgroup, so the new added netdev's
>> priomap will not be allocated. if we don't call update_netdev_tables in write_priomap,
>> we may access this unallocated memory.
>>
> 
> I realize my question was not clear.
> 
> If we write in write_priomap() a field of a single netdevice,
> why should we allocate memory for all netdevices on the machine ?
> 
> So the question was : Do we really need to call
> update_netdev_tables(alldevs), instead of extend_netdev_table(dev)
> 
> 

I get it.

You are right,Indeed we only need to call extend_netdev_table
for the netdev witch we want to change.

and I read the commit f5c38208d32412d72b97a4f0d44af0eb39feb20b,
found why we need delay allocation.

I will send a v2 patch.

Thanks!
