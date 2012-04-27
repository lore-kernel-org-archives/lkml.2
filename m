Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab2D0Frk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 01:47:40 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49732 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab2D0Frj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 01:47:39 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F9A327A.6050409@jp.fujitsu.com>
Date: Fri, 27 Apr 2012 14:45:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Tejun Heo <tj@kernel.org>,
        Han Ying <yinghan@google.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, kamezawa.hiroyuki@gmail.com
Subject: [RFC][PATCH 0/7 v2] memcg: prevent failure in pre_destroy()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a v2 patch for preventing failure in memcg->pre_destroy().
With this patch, ->pre_destroy() will never return error code and
users will not see warning at rmdir(). And this work will simplify
memcg->pre_destroy(), largely.

This patch is based on linux-next + hugetlb memory control patches.

I post this as RFC because I'll have vacation in the next week and
hugetlb patches are not visible in linux-next yet.
So, I'm not in hurry. Please review when you have time.

I'll rebase this onto memcg-devel in the next post.
== BTW, memory cgroup's github is here == 
git://github.com/mstsxfx/memcg-devel.git

Since v1, Whole patch designs are changed. In this version, I didn't
remove ->pre_destroy() but make it succeed always. There are no
asynchronous operation and no big patches. But this introduces
2 changes to cgroup core.

After this series, if use_hierarchy==0, all resources will be moved
to root cgroup at rmdir() or force_empty().

Brief patch conents are

0001 : my version of compile-fix for linux-next, Aneesh will post his own version.
0002 : fix error code in hugetlb_force_memcg_empty
0003 : add res_counter_uncharge_until()
0004 : use res_counter_uncharge_until() at move_parent()
0005 : move charges to root cgroup at rmdir, if use_hierarchy=0
0006 : clean up mem_cgroup_move_account()
0007 : cgroup : avoid attaching task to cgroup where ->pre_destroy() is running.
0008 : cgroup : avoid creating a new cgroup under a cgroup where ->pre_destroy() is running.
0009 : remove -EINTR from memcg->pre_destroy().

Thanks,
-Kame

