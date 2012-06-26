Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab2FZFh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 01:37:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57743 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750799Ab2FZFh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 01:37:56 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FE94A26.5030706@jp.fujitsu.com>
Date: Tue, 26 Jun 2012 14:35:34 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, Tejun Heo <tj@kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>,
        Frederic Weisbecker <fweisbec@redhat.com>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >= PAGE_SIZE
 against fork bombs
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-12-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206252157000.30072@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1206252157000.30072@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/26 13:57), David Rientjes wrote:
> On Mon, 25 Jun 2012, Glauber Costa wrote:
>
>> diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
>> index ccc1899..914ec07 100644
>> --- a/include/linux/thread_info.h
>> +++ b/include/linux/thread_info.h
>> @@ -61,6 +61,12 @@ extern long do_no_restart_syscall(struct restart_block *parm);
>>   # define THREADINFO_GFP		(GFP_KERNEL | __GFP_NOTRACK)
>>   #endif
>>
>> +#ifdef CONFIG_CGROUP_MEM_RES_CTLR_KMEM
>> +# define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP | __GFP_KMEMCG)
>> +#else
>> +# define THREADINFO_GFP_ACCOUNTED (THREADINFO_GFP)
>> +#endif
>> +
>
> This type of requirement is going to become nasty very quickly if nobody
> can use __GFP_KMEMCG without testing for CONFIG_CGROUP_MEM_RES_CTLR_KMEM.
> Perhaps define __GFP_KMEMCG to be 0x0 if it's not enabled, similar to how
> kmemcheck does?

I agree.

Thanks,
-Kame


