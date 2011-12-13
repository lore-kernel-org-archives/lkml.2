Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755790Ab1LMULq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:11:46 -0500
Received: from mx2.parallels.com ([64.131.90.16]:43157 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755002Ab1LMULn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:11:43 -0500
Message-ID: <4EE7B154.4050208@parallels.com>
Date: Wed, 14 Dec 2011 00:11:00 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <christoph.paasch@uclouvain.be>, David Miller <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <ebiederm@xmission.com>, <gthelen@google.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH v9 0/9] Request for inclusion: per-cgroup tcp memory pressure
 controls
References: <1323676029-5890-1-git-send-email-glommer@parallels.com>  <20111212.190734.1967808916779299221.davem@davemloft.net>  <4EE757D7.6060006@uclouvain.be> <1323784748.2950.4.camel@edumazet-laptop>
In-Reply-To: <1323784748.2950.4.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [83.149.8.203]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2011 05:59 PM, Eric Dumazet wrote:
> Le mardi 13 décembre 2011 à 14:49 +0100, Christoph Paasch a écrit :
>
>> now there are plenty of compiler-warnings when CONFIG_CGROUPS is not set:
>>
>> In file included from include/linux/tcp.h:211:0,
>>                   from include/linux/ipv6.h:221,
>>                   from include/net/ip_vs.h:23,
>>                   from kernel/sysctl_binary.c:6:
>> include/net/sock.h:67:57: warning: ‘struct cgroup_subsys’ declared
>> inside parameter list [enabled by default]
>> include/net/sock.h:67:57: warning: its scope is only this definition or
>> declaration, which is probably not what you want [enabled by default]
>> include/net/sock.h:67:57: warning: ‘struct cgroup’ declared inside
>> parameter list [enabled by default]
>> include/net/sock.h:68:61: warning: ‘struct cgroup_subsys’ declared
>> inside parameter list [enabled by default]
>> include/net/sock.h:68:61: warning: ‘struct cgroup’ declared inside
>> parameter list [enabled by default]
>>
>>
>> Because struct cgroup is only declared if CONFIG_CGROUPS is enabled.
>> (cfr. linux/cgroup.h)
>>
>
> Yes, we probably need forward reference like this :
>
> Thanks !
>
> [PATCH net-next] net: fix build error if CONFIG_CGROUPS=n
>
> Reported-by: Christoph Paasch<christoph.paasch@uclouvain.be>
> Signed-off-by: Eric Dumazet<eric.dumazet@gmail.com>
I am deeply sorry about that.
I was pretty sure I tested this case. But now that I looked into it, it 
occurs to me that I may have tested it only with the Memory Cgroup 
disabled, not with the master flag off.

Thanks for spotting this

