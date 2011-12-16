Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab1LPKGq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:06:46 -0500
Received: from mx2.parallels.com ([64.131.90.16]:53476 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143Ab1LPKGj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:06:39 -0500
Message-ID: <4EEB1807.1000308@parallels.com>
Date: Fri, 16 Dec 2011 14:05:59 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <netdev@vger.kernel.org>,
        <cgroups@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH v2] net: fix sleeping while atomic problem in sock mem_cgroup.
References: <1324026582-5214-1-git-send-email-glommer@parallels.com>  <1324027869.2273.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>  <4EEB1508.3080405@parallels.com> <1324029886.2273.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
In-Reply-To: <1324029886.2273.9.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [85.26.155.19]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2011 02:04 PM, Eric Dumazet wrote:
> Le vendredi 16 décembre 2011 à 13:53 +0400, Glauber Costa a écrit :
>> On 12/16/2011 01:31 PM, Eric Dumazet wrote:
>>> Le vendredi 16 décembre 2011 à 13:09 +0400, Glauber Costa a écrit :
>>>> Since we can't scan the proto_list to initialize sock cgroups, as it
>>>> holds a rwlock, and we also want to keep the code generic enough to
>>>> avoid calling the initialization functions of protocols directly,
>>>> I propose we keep the interested parties in a separate list. This list
>>>> is protected by a mutex so we can sleep and do the necessary allocations.
>>>>
>>>> Also fixes a reference problem found by Randy Dunlap's randconfig.
>>>>
>>>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>>>> CC: Hiroyouki Kamezawa<kamezawa.hiroyu@jp.fujitsu.com>
>>>> CC: David S. Miller<davem@davemloft.net>
>>>> CC: Eric Dumazet<eric.dumazet@gmail.com>
>>>> CC: Stephen Rothwell<sfr@canb.auug.org.au>
>>>> CC: Randy Dunlap<rdunlap@xenotime.net>
>>>> ---
>>>
>>> Sorry to come late, but why dont we convert proto_list_lock to a mutex ?
>>
>> I didn't suggest this, as I imagined there could be some performance
>> implications to be drawn from it that may not be obvious to me.
>>
>> But if it is okay with you net guys, it is certainly okay with me as well.
>
> This 'lock' is not performance sensitive, its very seldom taken.
>
> If we really wanted to be fast, it would not be a rwlock anymore ;)
>
> "cat /proc/net/protocols" could eventually use RCU locking if we want
> parallelism. (I dont think its needed)
>

Well, in this case, I myself think this is a better solution. Do you 
want to push the patch yourself, or should I do it ?


