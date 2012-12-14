Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2LNBi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:38:56 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:32542 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab2LNBiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:38:55 -0500
Message-ID: <50CA830B.2050209@huawei.com>
Date: Fri, 14 Dec 2012 09:38:19 +0800
From: Jianguo Wu <wujianguo@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, <dhillf@gmail.com>,
        Liujiang <jiang.liu@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        qiuxishi <qiuxishi@huawei.com>, Hanjun Guo <guohanjun@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 UPDATE] mm/hugetlb: create hugetlb cgroup file in hugetlb_init
References: <50C94DE5.2040302@huawei.com> <20121213135656.GB27775@dhcp22.suse.cz>
In-Reply-To: <20121213135656.GB27775@dhcp22.suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.216]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/12/13 21:56, Michal Hocko wrote:

> On Thu 13-12-12 11:39:17, Jianguo Wu wrote:
>> Build kernel with CONFIG_HUGETLBFS=y,CONFIG_HUGETLB_PAGE=y
>> and CONFIG_CGROUP_HUGETLB=y, then specify hugepagesz=xx boot option,
>> system will boot fail.
>>
>> This failure is caused by following code path:
>> setup_hugepagesz
>> 	hugetlb_add_hstate
>> 		hugetlb_cgroup_file_init
>> 			cgroup_add_cftypes
>> 				kzalloc <--slab is *not available* yet
>>
>> For this path, slab is not available yet, so memory allocated will be
>> failed, and cause WARN_ON() in hugetlb_cgroup_file_init().
>>
>> So I move hugetlb_cgroup_file_init() into hugetlb_init().
>>
>> Changelog:
>>   do code refactor as suggesting by Aneesh
>>   add Reviewed-by and Acked-by 
>>
>> Signed-off-by: Jianguo Wu <wujianguo@huawei.com>
>> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
>> Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
>> Acked-by: Michal Hocko <mhocko@suse.cz>
> 
> Any reason to not add Cc: stable as I suggested earlier?

Hi Michal,

Sorry for forgot that.
Andrew has added Cc: stable when added to -mm tree.


