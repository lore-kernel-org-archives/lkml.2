Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab1IHMm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 08:42:28 -0400
Received: from mx2.parallels.com ([64.131.90.16]:50021 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932607Ab1IHMm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 08:42:26 -0400
Message-ID: <4E68B801.8000207@parallels.com>
Date: Thu, 8 Sep 2011 09:41:37 -0300
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: "Kirill A. Shutemov" <kirill@shutemov.name>
CC: <linux-kernel@vger.kernel.org>, <xemul@parallels.com>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        <containers@lists.osdl.org>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v2 3/9] socket: initial cgroup code.
References: <1315369399-3073-1-git-send-email-glommer@parallels.com> <1315369399-3073-4-git-send-email-glommer@parallels.com> <20110907221710.GA7845@shutemov.name> <4E684A6B.6030205@parallels.com> <20110908053558.GA9464@shutemov.name>
In-Reply-To: <20110908053558.GA9464@shutemov.name>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [189.121.42.206]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2011 02:35 AM, Kirill A. Shutemov wrote:
> On Thu, Sep 08, 2011 at 01:54:03AM -0300, Glauber Costa wrote:
>> On 09/07/2011 07:17 PM, Kirill A. Shutemov wrote:
>>> On Wed, Sep 07, 2011 at 01:23:13AM -0300, Glauber Costa wrote:
>>>> We aim to control the amount of kernel memory pinned at any
>>>> time by tcp sockets. To lay the foundations for this work,
>>>> this patch adds a pointer to the kmem_cgroup to the socket
>>>> structure.
>>>>
>>>> Signed-off-by: Glauber Costa<glommer@parallels.com>
>>>> CC: David S. Miller<davem@davemloft.net>
>>>> CC: Hiroyouki Kamezawa<kamezawa.hiroyu@jp.fujitsu.com>
>>>> CC: Eric W. Biederman<ebiederm@xmission.com>
>>>> ---
>>>>    include/linux/kmem_cgroup.h |   29 +++++++++++++++++++++++++++++
>>>>    include/net/sock.h          |    2 ++
>>>>    net/core/sock.c             |    5 ++---
>>>>    3 files changed, 33 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/include/linux/kmem_cgroup.h b/include/linux/kmem_cgroup.h
>>>> index 0e4a74b..77076d8 100644
>>>> --- a/include/linux/kmem_cgroup.h
>>>> +++ b/include/linux/kmem_cgroup.h
>>>> @@ -49,5 +49,34 @@ static inline struct kmem_cgroup *kcg_from_task(struct task_struct *tsk)
>>>>    	return NULL;
>>>>    }
>>>>    #endif /* CONFIG_CGROUP_KMEM */
>>>> +
>>>> +#ifdef CONFIG_INET
>>>
>>> Will it break something if you define the helpers even if CONFIG_INET
>>> is not defined?
>>> It will be much cleaner. You can reuse ifdef CONFIG_CGROUP_KMEM in this
>>> case.
>>
>> The helpers inside CONFIG_INET are needed for the network code,
>> regardless of kmem cgroup is defined or not, not the other way around.
>>
>> So I could remove CONFIG_INET, but I can't possibly move it inside
>> CONFIG_CGROUP_KMEM. So this buy us nothing.
>
> You can define empty under CONFIG_CGROUP_KMEM's #else, can't you?
> Like with kcg_from_cgroup()/kcg_from_task().
>
Do you really think it is cleaner?

Why would I define empty something that is not empty at all?
Look again. Most of those helpers would be the exact same with or 
without CONFIG_CGROUP_KMEM . The others, very few differences. If 
CONFIG_INET bothers you, I can remove it altogether, making it 
unconditional. But moving it inside CONFIG_CGROUP_KMEM makes no sense.
