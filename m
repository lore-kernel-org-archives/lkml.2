Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2GKBjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 21:39:20 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50114 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751731Ab2GKBjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 21:39:19 -0400
X-IronPort-AV: E=Sophos;i="4.77,564,1336320000"; 
   d="scan'208";a="5367625"
Message-ID: <4FFCD95A.1060204@cn.fujitsu.com>
Date: Wed, 11 Jul 2012 09:39:38 +0800
From: Gao feng <gaofeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: nhorman@tuxdriver.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, lizefan@huawei.com, tj@kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH v2] net: cgroup: fix access the unallocated memory in
 netprio cgroup
References: <1341917043-13264-1-git-send-email-gaofeng@cn.fujitsu.com>  <1341918350.3265.4830.camel@edumazet-glaptop> <1341918530.3265.4839.camel@edumazet-glaptop>
In-Reply-To: <1341918530.3265.4839.camel@edumazet-glaptop>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/11 09:39:08,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/07/11 09:39:10
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2012年07月10日 19:08, Eric Dumazet 写道:
> On Tue, 2012-07-10 at 13:05 +0200, Eric Dumazet wrote:
>> On Tue, 2012-07-10 at 18:44 +0800, Gao feng wrote:
>>> there are some out of bound accesses in netprio cgroup.
>>
>>> -	update_netdev_tables();
>>> +	ret = extend_netdev_table(dev, max_len);
>>> +	if (ret < 0)
>>> +		goto out_free_devname;
>>> +
>>>  	ret = 0;
>>>  	rcu_read_lock();
>>>  	map = rcu_dereference(dev->priomap);
>>
>> Its unfortunately adding a bug.
>>
>> extend_netdev_table() is protected by RTNL.
> 
> Please test your next patch using :
> 
> CONFIG_LOCKDEP=y
> CONFIG_PROVE_RCU=y
> 
> Because rtnl_dereference() should shout if you dont hold RTNL
> 

Oops, I miss it.
Thanks Eric & Neil,I will test v3 patch with these two CONFIG.

