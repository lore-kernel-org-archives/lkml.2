Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab1JMIUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 04:20:12 -0400
Received: from mx2.parallels.com ([64.131.90.16]:53778 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218Ab1JMIUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 04:20:10 -0400
Message-ID: <4E969F19.4010802@parallels.com>
Date: Thu, 13 Oct 2011 12:19:37 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Greg Thelen <gthelen@google.com>
CC: <linux-kernel@vger.kernel.org>, <paul@paulmenage.org>,
        <lizf@cn.fujitsu.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <ebiederm@xmission.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-mm@kvack.org>, <kirill@shutemov.name>,
        <avagin@parallels.com>, <devel@openvz.org>
Subject: Re: [PATCH v6 1/8] Basic kernel memory functionality for the Memory
 Controller
References: <1318242268-2234-1-git-send-email-glommer@parallels.com> <1318242268-2234-2-git-send-email-glommer@parallels.com> <CAHH2K0awiPZZ9EJLyZy_p_ehf0-waQ-vGUAhAZEpdCMnYqKidA@mail.gmail.com>
In-Reply-To: <CAHH2K0awiPZZ9EJLyZy_p_ehf0-waQ-vGUAhAZEpdCMnYqKidA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/2011 11:18 AM, Greg Thelen wrote:
> On Mon, Oct 10, 2011 at 3:24 AM, Glauber Costa<glommer@parallels.com>  wrote:
>> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
>> index 06eb6d9..bf00cd2 100644
>> --- a/Documentation/cgroups/memory.txt
>> +++ b/Documentation/cgroups/memory.txt
> ...
>> @@ -255,6 +262,31 @@ When oom event notifier is registered, event will be delivered.
>>    per-zone-per-cgroup LRU (cgroup's private LRU) is just guarded by
>>    zone->lru_lock, it has no lock of its own.
>>
>> +2.7 Kernel Memory Extension (CONFIG_CGROUP_MEM_RES_CTLR_KMEM)
>> +
>> + With the Kernel memory extension, the Memory Controller is able to limit
>
> Extra leading space before 'With'.
>
>> +the amount of kernel memory used by the system. Kernel memory is fundamentally
>> +different than user memory, since it can't be swapped out, which makes it
>> +possible to DoS the system by consuming too much of this precious resource.
>> +Kernel memory limits are not imposed for the root cgroup.
>> +
>> +Memory limits as specified by the standard Memory Controller may or may not
>> +take kernel memory into consideration. This is achieved through the file
>> +memory.independent_kmem_limit. A Value different than 0 will allow for kernel
>
> s/Value/value/
>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 3508777..d25c5cb 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
> ...
>> +static int kmem_limit_independent_write(struct cgroup *cont, struct cftype *cft,
>> +                                       u64 val)
>> +{
>> +       cgroup_lock();
>> +       mem_cgroup_from_cont(cont)->kmem_independent_accounting = !!val;
>> +       cgroup_unlock();
>
> I do not think cgroup_lock,unlock are needed here.  The cont and
> associated cgroup should be guaranteed by the caller to be valid.
> Does this lock provide some other synchronization?
Yeah, I think I was being overcautious.

With the following comments addressed, can I add your Reviewed-by to 
this one ?

