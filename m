Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897Ab2EKJnh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 05:43:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40643 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab2EKJnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 05:43:35 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FACDED0.3020400@jp.fujitsu.com>
Date: Fri, 11 May 2012 18:41:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
CC: "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        Tejun Heo <tj@kernel.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH v3][0/6] memcg: prevent -ENOMEM in pre_destroy()
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, here is v3 based on memcg-devel tree.
git://github.com/mstsxfx/memcg-devel.git

This patch series is for avoiding -ENOMEM at calling pre_destroy() 
which is called at rmdir(). After this patch, charges will be moved
to root (if use_hierarchy==0) or parent (if use_hierarchy==1), and
we'll not see -ENOMEM in rmdir() of cgroup.

v2 included some other patches than ones for handling -ENOMEM problem,
but I divided it. I'd like to post others in different series, later.
No logical changes in general, maybe v3 is cleaner than v2.

0001 ....fix error code in memcg-hugetlb
0002 ....add res_counter_uncharge_until
0003 ....use res_counter_uncharge_until in memcg
0004 ....move charges to root is use_hierarchy==0
0005 ....cleanup for mem_cgroup_move_account()
0006 ....remove warning of res_counter_uncharge_nofail (from Costa's slub accounting series).

Regards,
-Kame

