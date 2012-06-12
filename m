Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab2FLJAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 05:00:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56034 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab2FLI75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:59:57 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4FD70492.2090709@jp.fujitsu.com>
Date: Tue, 12 Jun 2012 17:57:54 +0900
From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: linux-mm@kvack.org, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V8 16/16] hugetlb/cgroup: add HugeTLB controller documentation
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-17-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1339232401-14392-17-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/06/09 18:00), Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V"<aneesh.kumar@linux.vnet.ibm.com>
> 
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>

Documentation in patch 1/16 will help other guy's review.


> ---
>   Documentation/cgroups/hugetlb.txt |   45 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 45 insertions(+)
>   create mode 100644 Documentation/cgroups/hugetlb.txt
> 
> diff --git a/Documentation/cgroups/hugetlb.txt b/Documentation/cgroups/hugetlb.txt
> new file mode 100644
> index 0000000..a9faaca
> --- /dev/null
> +++ b/Documentation/cgroups/hugetlb.txt
> @@ -0,0 +1,45 @@
> +HugeTLB Controller
> +-------------------
> +
> +The HugeTLB controller allows to limit the HugeTLB usage per control group and
> +enforces the controller limit during page fault. Since HugeTLB doesn't
> +support page reclaim, enforcing the limit at page fault time implies that,
> +the application will get SIGBUS signal if it tries to access HugeTLB pages
> +beyond its limit. This requires the application to know beforehand how much
> +HugeTLB pages it would require for its use.
> +


Isn't it better to mention hugetlb cgroup doesn't have its own free-huge-page-list,
it's just a quota. And system admin need to set up hugetlb page pool regardless
of using hugetlb cgroup.


> +HugeTLB controller can be created by first mounting the cgroup filesystem.
> +
> +# mount -t cgroup -o hugetlb none /sys/fs/cgroup
> +
> +With the above step, the initial or the parent HugeTLB group becomes
> +visible at /sys/fs/cgroup. At bootup, this group includes all the tasks in
> +the system. /sys/fs/cgroup/tasks lists the tasks in this cgroup.
> +
> +New groups can be created under the parent group /sys/fs/cgroup.
> +
> +# cd /sys/fs/cgroup
> +# mkdir g1
> +# echo $$>  g1/tasks
> +
> +The above steps create a new group g1 and move the current shell
> +process (bash) into it.
> +
> +Brief summary of control files
> +
> + hugetlb.<hugepagesize>.limit_in_bytes     # set/show limit of "hugepagesize" hugetlb usage
> + hugetlb.<hugepagesize>.max_usage_in_bytes # show max "hugepagesize" hugetlb  usage recorded
> + hugetlb.<hugepagesize>.usage_in_bytes     # show current res_counter usage for "hugepagesize" hugetlb
> + hugetlb.<hugepagesize>.failcnt		   # show the number of allocation failure due to HugeTLB limit
                                         ^^^^^^^^
breakage in spacing.

> +
> +For a system supporting two hugepage size (16M and 16G) the control
> +files include:
> +
> +hugetlb.16GB.limit_in_bytes
> +hugetlb.16GB.max_usage_in_bytes
> +hugetlb.16GB.usage_in_bytes
> +hugetlb.16GB.failcnt
> +hugetlb.16MB.limit_in_bytes
> +hugetlb.16MB.max_usage_in_bytes
> +hugetlb.16MB.usage_in_bytes
> +hugetlb.16MB.failcnt

seems nice.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

