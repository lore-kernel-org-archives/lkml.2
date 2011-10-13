Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1JMI01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:26:27 -0400
Received: from mx2.parallels.com ([64.131.90.16]:45123 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab1JMI0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:26:25 -0400
Message-ID: <4E96A091.4000705@parallels.com>
Date: Thu, 13 Oct 2011 12:25:53 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <ebiederm@xmission.com>, <davem@davemloft.net>,
        <gthelen@google.com>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        <kirill@shutemov.name>, <avagin@parallels.com>, <devel@openvz.org>
Subject: Re: [PATCH v6 3/8] foundations of per-cgroup memory pressure controlling.
References: <1318242268-2234-1-git-send-email-glommer@parallels.com> <1318242268-2234-4-git-send-email-glommer@parallels.com> <20111013145353.161009ea.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111013145353.161009ea.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 09:53 AM, KAMEZAWA Hiroyuki wrote:
> On Mon, 10 Oct 2011 14:24:23 +0400
> Glauber Costa<glommer@parallels.com>  wrote:
>
>> This patch converts struct sock fields memory_pressure,
>> memory_allocated, sockets_allocated, and sysctl_mem (now prot_mem)
>> to function pointers, receiving a struct mem_cgroup parameter.
>>
>> enter_memory_pressure is kept the same, since all its callers
>> have socket a context, and the kmem_cgroup can be derived from
>> the socket itself.
>>
>> To keep things working, the patch convert all users of those fields
>> to use acessor functions.
>>
>> In my benchmarks I didn't see a significant performance difference
>> with this patch applied compared to a baseline (around 1 % diff, thus
>> inside error margin).
>>
>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>> CC: David S. Miller<davem@davemloft.net>
>> CC: Hiroyouki Kamezawa<kamezawa.hiroyu@jp.fujitsu.com>
>> CC: Eric W. Biederman<ebiederm@xmission.com>
>
> Reviewed-by: KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>
>
> a nitpick.
>
>
>>   #ifdef CONFIG_INET
>> +enum {
>> +	UNDER_LIMIT,
>> +	OVER_LIMIT,
>> +};
>> +
>
> It may be better to move this to res_counter.h or memcontrol.h
>
Sorry Kame,

It is in memcontrol.h already. What exactly do you mean here ?



