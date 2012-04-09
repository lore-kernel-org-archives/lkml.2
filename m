Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2DIJBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 05:01:53 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56917 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab2DIJBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 05:01:52 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F82A510.5030004@jp.fujitsu.com>
Date: Mon, 09 Apr 2012 18:00:00 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, mgorman@suse.de, dhillf@gmail.com, aarcange@redhat.com,
        mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V5 07/14] memcg: Add HugeTLB extension
References: <1333738260-1329-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1333738260-1329-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <4F827BF9.2090205@jp.fujitsu.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu) <87zkalcn26.fsf@skywalker.in.ibm.com>
In-Reply-To: <87zkalcn26.fsf@skywalker.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/04/09 17:43), Aneesh Kumar K.V wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> 
>> (2012/04/07 3:50), Aneesh Kumar K.V wrote:
>>
>>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>>>
>>> This patch implements a memcg extension that allows us to control HugeTLB
>>> allocations via memory controller. The extension allows to limit the
>>> HugeTLB usage per control group and enforces the controller limit during
>>> page fault. Since HugeTLB doesn't support page reclaim, enforcing the limit
>>> at page fault time implies that, the application will get SIGBUS signal if it
>>> tries to access HugeTLB pages beyond its limit. This requires the application
>>> to know beforehand how much HugeTLB pages it would require for its use.
>>>
>>> The charge/uncharge calls will be added to HugeTLB code in later patch.
>>>
>>> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>>
>>
>> Hmm, seems ok to me. please explain 'this patch doesn't include updates
>> for memcg destroying, it will be in patch 12/14' or some...
>>
>> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>>
>>
>> BTW, you don't put res_counter for hugeltb under CONFIG_MEM_RES_CTLR_HUGETLB...
>> do you think we need the config ?
> 
> 
> That results in more #ifdef CONFIG_MEM_RES_CTLR_HUGETLB in the
> memcg code (mem_cgroup_create/mem_cgroup_read/write etc). I was not
> sure we want to do that. Let me know if you think we really need to do this.
> 


Hm. ok. BTW, how about removing all CONFIG_MEM_RES_CTLR_HUGETLB and makes 
all codes just depends on CONFIG_CGROUP_MEM_RES_CTLR && CONFIG_HUGETLB ?

How other guys thinks ? (Anyway we can do it later....)

Thanks,
-Kame


