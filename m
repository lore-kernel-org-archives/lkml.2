Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab2LMN5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:57:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55924 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220Ab2LMN5U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:57:20 -0500
Date: Thu, 13 Dec 2012 14:56:56 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Jianguo Wu <wujianguo@huawei.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, tj@kernel.org,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, dhillf@gmail.com,
        Liujiang <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        qiuxishi <qiuxishi@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v2 UPDATE] mm/hugetlb: create hugetlb cgroup file in
 hugetlb_init
Message-ID: <20121213135656.GB27775@dhcp22.suse.cz>
References: <50C94DE5.2040302@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C94DE5.2040302@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 13-12-12 11:39:17, Jianguo Wu wrote:
> Build kernel with CONFIG_HUGETLBFS=y,CONFIG_HUGETLB_PAGE=y
> and CONFIG_CGROUP_HUGETLB=y, then specify hugepagesz=xx boot option,
> system will boot fail.
> 
> This failure is caused by following code path:
> setup_hugepagesz
> 	hugetlb_add_hstate
> 		hugetlb_cgroup_file_init
> 			cgroup_add_cftypes
> 				kzalloc <--slab is *not available* yet
> 
> For this path, slab is not available yet, so memory allocated will be
> failed, and cause WARN_ON() in hugetlb_cgroup_file_init().
> 
> So I move hugetlb_cgroup_file_init() into hugetlb_init().
> 
> Changelog:
>   do code refactor as suggesting by Aneesh
>   add Reviewed-by and Acked-by 
> 
> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> Acked-by: Michal Hocko <mhocko@suse.cz>

Any reason to not add Cc: stable as I suggested earlier?
-- 
Michal Hocko
SUSE Labs
