Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925Ab2ENBJf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 21:09:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:51157 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab2ENBJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 21:09:34 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FB05AD6.1090400@jp.fujitsu.com>
Date: Mon, 14 May 2012 10:07:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] memcg: fix error code in hugetlb_force_memcg_empty()
References: <4FACDED0.3020400@jp.fujitsu.com> <4FACDFAE.5050808@jp.fujitsu.com> <20120511141754.e0719c26.akpm@linux-foundation.org>
In-Reply-To: <20120511141754.e0719c26.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/12 6:17), Andrew Morton wrote:

> On Fri, 11 May 2012 18:45:18 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
>> The conditions are handled as -EBUSY, _now_.
> 
> The changelog is poor.  I rewrote it to
> 
> : hugetlb_force_memcg_empty() incorrectly returns 0 (success) when the
> : cgroup is found to be busy.  Return -EBUSY instead.
> 
> But it still doesn't tell us the end-user-visible effects of the bug. 
> It should.
> 


Ah, sorry. How about this ?



The force_empty interface allows to make the memcg only when the cgroup
doesn't include any tasks.

	# echo 0 > /cgroup/xxxx/memory.force_empty

If cgroup isn't empty, force_empty does nothing and retruns -EBUSY in usual
memcg, memcontrol.c. But hugetlb implementation has inconsitency with
it and returns 0 and do nothing. Fix it to return -EBUSY.

Thanks,
-Kame


