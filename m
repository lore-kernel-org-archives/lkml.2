Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758837Ab2CSMJD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 08:09:03 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47425 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757065Ab2CSMJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 08:09:00 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F672165.4050506@jp.fujitsu.com>
Date: Mon, 19 Mar 2012 21:07:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Glauber Costa <glommer@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, linux-mm@kvack.org,
        mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 04/10] memcg: Add HugeTLB extension
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F669C2E.1010502@jp.fujitsu.com> <874ntlkrp6.fsf@linux.vnet.ibm.com> <4F66D993.2080100@jp.fujitsu.com> <4F671AE6.5020204@parallels.com>
In-Reply-To: <4F671AE6.5020204@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/19 20:39), Glauber Costa wrote:

> On 03/19/2012 11:00 AM, KAMEZAWA Hiroyuki wrote:
>> (2012/03/19 15:52), Aneesh Kumar K.V wrote:
>>
>>> On Mon, 19 Mar 2012 11:38:38 +0900, KAMEZAWA Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com>  wrote:
>>>> (2012/03/17 2:39), Aneesh Kumar K.V wrote:
>>>>
>>>>> From: "Aneesh Kumar K.V"<aneesh.kumar@linux.vnet.ibm.com>
>>>>>
>>>>> This patch implements a memcg extension that allows us to control
>>>>> HugeTLB allocations via memory controller.
>>>>>
>>>>
>>>>
>>>> If you write some details here, it will be helpful for review and
>>>> seeing log after merge.
>>>
>>> Will add more info.
>>>
>>>>
>>>>
>>>>> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>
>>>>> ---
>>>>>   include/linux/hugetlb.h    |    1 +
>>>>>   include/linux/memcontrol.h |   42 +++++++++++++
>>>>>   init/Kconfig               |    8 +++
>>>>>   mm/hugetlb.c               |    2 +-
>>>>>   mm/memcontrol.c            |  138 ++++++++++++++++++++++++++++++++++++++++++++
>>>>>   5 files changed, 190 insertions(+), 1 deletions(-)
>>>
>>> ....
>>>
>>>>> +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
>>>>> +static bool mem_cgroup_have_hugetlb_usage(struct mem_cgroup *memcg)
>>>>> +{
>>>>> +	int idx;
>>>>> +	for (idx = 0; idx<  hugetlb_max_hstate; idx++) {
>>>>> +		if (memcg->hugepage[idx].usage>  0)
>>>>> +			return 1;
>>>>> +	}
>>>>> +	return 0;
>>>>> +}
>>>>
>>>>
>>>> Please use res_counter_read_u64() rather than reading the value directly.
>>>>
>>>
>>> The open-coded variant is mostly derived from mem_cgroup_force_empty. I
>>> have updated the patch to use res_counter_read_u64.
>>>
>>
>> Ah, ok. it's(maybe) my bad. I'll schedule a fix.
>>
> Kame,
> 
> I actually have it ready here. I can submit it if you want.
> 


That's good :) please post.
(But I'm sorry I'll be absent tomorrow.)

Thanks,
-Kame

