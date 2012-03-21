Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab2CUEtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 00:49:01 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:49840 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab2CUEs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 00:48:59 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Glauber Costa <glommer@parallels.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 04/10] memcg: Add HugeTLB extension
In-Reply-To: <4F671AE6.5020204@parallels.com>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F669C2E.1010502@jp.fujitsu.com> <874ntlkrp6.fsf@linux.vnet.ibm.com> <4F66D993.2080100@jp.fujitsu.com> <4F671AE6.5020204@parallels.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 21 Mar 2012 10:18:43 +0530
Message-ID: <87obrqsgno.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12032104-4790-0000-0000-000001E228CF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa <glommer@parallels.com> writes:

> On 03/19/2012 11:00 AM, KAMEZAWA Hiroyuki wrote:
>> (2012/03/19 15:52), Aneesh Kumar K.V wrote:
>>
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
> This one has bitten me as well when I was trying to experiment with the 
> res_counter performance...

Do we really need memcg.res.usage to be accurate in that while loop ? If
we miss a zero update because we encountered a partial update; in the
next loop we will find it zero right ?

-aneesh

