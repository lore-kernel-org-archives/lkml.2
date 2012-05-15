Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792Ab2EOBMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 21:12:39 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59079 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab2EOBMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 21:12:38 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FB1AD0A.50901@jp.fujitsu.com>
Date: Tue, 15 May 2012 10:10:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] memcg: fix error code in hugetlb_force_memcg_empty()
References: <4FACDED0.3020400@jp.fujitsu.com> <4FACDFAE.5050808@jp.fujitsu.com> <20120514181556.GE2366@google.com> <20120514183219.GG2366@google.com>
In-Reply-To: <20120514183219.GG2366@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/05/15 3:32), Tejun Heo wrote:

> On Mon, May 14, 2012 at 11:15:56AM -0700, Tejun Heo wrote:
>> On Fri, May 11, 2012 at 06:45:18PM +0900, KAMEZAWA Hiroyuki wrote:
>>> -		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
>>> +		if (cgroup_task_count(cgroup)
>>> +			|| !list_empty(&cgroup->children)) {
>>> +			ret = -EBUSY;
>>>  			goto out;
>>
>> Why break the line?  It doesn't go over 80 col.
> 
> Ooh, it does.  Sorry, my bad.  But still, isn't it more usual to leave
> the operator in the preceding line and align the start of the second
> line with the first?  ie.
> 
> 		if (cgroup_task_count(cgroup) ||
> 		    !list_empty(&cgroup->children)) {
> 


How about this ?
==
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 27 Apr 2012 13:19:19 +0900
Subject: [PATCH] memcg: fix error code in hugetlb_force_memcg_empty()

Changelog:
 - clean up.
Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/hugetlb.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1d3c8ea9..82ec623 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1922,8 +1922,11 @@ int hugetlb_force_memcg_empty(struct cgroup *cgroup)
 	int ret = 0, idx = 0;
 
 	do {
-		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
+		if (cgroup_task_count(cgroup) ||
+		    !list_empty(&cgroup->children)){
+			ret = -EBUSY;
 			goto out;
+		}
 		/*
 		 * If the task doing the cgroup_rmdir got a signal
 		 * we don't really need to loop till the hugetlb resource
-- 
1.7.4.1



