Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab2CSHf7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 03:35:59 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36543 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab2CSHf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 03:35:57 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F66E169.5000909@jp.fujitsu.com>
Date: Mon, 19 Mar 2012 16:34:01 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -V4 07/10] hugetlbfs: Add memcg control files for hugetlbfs
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331919570-2264-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F66A059.20801@jp.fujitsu.com> <87wr6hjc58.fsf@linux.vnet.ibm.com>
In-Reply-To: <87wr6hjc58.fsf@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/19 16:14), Aneesh Kumar K.V wrote:

> On Mon, 19 Mar 2012 11:56:25 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> (2012/03/17 2:39), Aneesh Kumar K.V wrote:
>>
>>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>>>
>>> This add control files for hugetlbfs in memcg
>>>
>>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>>
>>
>> I have a question. When a user does
>>
>> 	1. create memory cgroup as
>> 		/cgroup/A
>> 	2. insmod hugetlb.ko
>> 	3. ls /cgroup/A
>>
>> and then, files can be shown ? Don't we have any problem at rmdir A ?
>>
>> I'm sorry if hugetlb never be used as module.
> 
> HUGETLBFS cannot be build as kernel module
> 
> 
>>
>> a comment below.
>>
>>> ---
>>>  include/linux/hugetlb.h    |   17 +++++++++++++++
>>>  include/linux/memcontrol.h |    7 ++++++
>>>  mm/hugetlb.c               |   25 ++++++++++++++++++++++-
>>>  mm/memcontrol.c            |   48 ++++++++++++++++++++++++++++++++++++++++++++
>>>  4 files changed, 96 insertions(+), 1 deletions(-)
> 
> 
> ......
> 
>>>
>>> +#ifdef CONFIG_MEM_RES_CTLR_HUGETLB
>>> +static char *mem_fmt(char *buf, unsigned long n)
>>> +{
>>> +	if (n >= (1UL << 30))
>>> +		sprintf(buf, "%luGB", n >> 30);
>>> +	else if (n >= (1UL << 20))
>>> +		sprintf(buf, "%luMB", n >> 20);
>>> +	else
>>> +		sprintf(buf, "%luKB", n >> 10);
>>> +	return buf;
>>> +}
>>> +
>>> +int mem_cgroup_hugetlb_file_init(int idx)
>>> +{
>>
>>
>> __init ? 
> 
> Added .
> 
>> And... do we have guarantee that this function is called before
>> creating root mem cgroup even if CONFIG_HUGETLBFS=y ?
>>
> 
> Yes. This should be called before creating root mem cgroup.
> 


O.K. BTW, please read Tejun's recent post..
 
https://lkml.org/lkml/2012/3/16/522

Can you use his methods ?

I guess you can write...

CGROUP_SUBSYS_CFTYLES_COND(mem_cgroup_subsys,
			hugetlb_cgroup_files,
			if XXXXMB hugetlb is allowed);

Hmm.

Thanks,
-Kame


