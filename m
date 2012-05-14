Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab2ENSQD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 14:16:03 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46570 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327Ab2ENSQB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 14:16:01 -0400
Date: Mon, 14 May 2012 11:15:56 -0700
From: Tejun Heo <tj@kernel.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Han Ying <yinghan@google.com>, Glauber Costa <glommer@parallels.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/6] memcg: fix error code in
 hugetlb_force_memcg_empty()
Message-ID: <20120514181556.GE2366@google.com>
References: <4FACDED0.3020400@jp.fujitsu.com>
 <4FACDFAE.5050808@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FACDFAE.5050808@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 06:45:18PM +0900, KAMEZAWA Hiroyuki wrote:
> -		if (cgroup_task_count(cgroup) || !list_empty(&cgroup->children))
> +		if (cgroup_task_count(cgroup)
> +			|| !list_empty(&cgroup->children)) {
> +			ret = -EBUSY;
>  			goto out;

Why break the line?  It doesn't go over 80 col.

Thanks.

-- 
tejun
