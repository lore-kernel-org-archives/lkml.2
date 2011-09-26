Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773Ab1IZWsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 18:48:55 -0400
Received: from mx2.parallels.com ([64.131.90.16]:34395 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396Ab1IZWsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 18:48:53 -0400
Message-ID: <4E81012F.2070001@parallels.com>
Date: Mon, 26 Sep 2011 19:48:15 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <ebiederm@xmission.com>, <davem@davemloft.net>,
        <gthelen@google.com>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        <kirill@shutemov.name>
Subject: Re: [PATCH v3 4/7] per-cgroup tcp buffers control
References: <1316393805-3005-1-git-send-email-glommer@parallels.com> <1316393805-3005-5-git-send-email-glommer@parallels.com> <20110926195906.f1f5831c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110926195906.f1f5831c.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [201.82.135.174]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2011 07:59 AM, KAMEZAWA Hiroyuki wrote:
> On Sun, 18 Sep 2011 21:56:42 -0300
> Glauber Costa<glommer@parallels.com>  wrote:
>
>> With all the infrastructure in place, this patch implements
>> per-cgroup control for tcp memory pressure handling.
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: David S. Miller<davem@davemloft.net>
>> CC: Hiroyouki Kamezawa<kamezawa.hiroyu@jp.fujitsu.com>
>> CC: Eric W. Biederman<ebiederm@xmission.com>
>
> a comment below.
>
>> +int tcp_init_cgroup(struct proto *prot, struct cgroup *cgrp,
>> +		    struct cgroup_subsys *ss)
>> +{
>> +	struct mem_cgroup *cg = mem_cgroup_from_cont(cgrp);
>> +	unsigned long limit;
>> +
>> +	cg->tcp_memory_pressure = 0;
>> +	atomic_long_set(&cg->tcp_memory_allocated, 0);
>> +	percpu_counter_init(&cg->tcp_sockets_allocated, 0);
>> +
>> +	limit = nr_free_buffer_pages() / 8;
>> +	limit = max(limit, 128UL);
>> +
>> +	cg->tcp_prot_mem[0] = sysctl_tcp_mem[0];
>> +	cg->tcp_prot_mem[1] = sysctl_tcp_mem[1];
>> +	cg->tcp_prot_mem[2] = sysctl_tcp_mem[2];
>> +
>
> Then, the parameter doesn't inherit parent's one ?
>
> I think sockets_populate should pass 'parent' and
>
>
> I think you should have a function
>
>      mem_cgroup_should_inherit_parent_settings(parent)
>
> (This is because you made this feature as a part of memcg.
>   please provide expected behavior.)
>
All right Kame, will do.
Thanks.


