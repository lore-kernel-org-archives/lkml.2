Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab2FNJZo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:25:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755400Ab2FNJZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:25:42 -0400
Date: Thu, 14 Jun 2012 11:25:40 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com,
        rientjes@google.com, akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V9 11/15] hugetlb/cgroup: Add charge/uncharge routines
 for hugetlb cgroup
Message-ID: <20120614092539.GI27397@tiehlicka.suse.cz>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339583254-895-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339583254-895-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 13-06-12 15:57:30, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> 
> This patchset add the charge and uncharge routines for hugetlb cgroup.
> We do cgroup charging in page alloc and uncharge in compound page
> destructor. Assigning page's hugetlb cgroup is protected by hugetlb_lock.
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

Reviewed-by: Michal Hocko <mhocko@suse.cz>

One minor comment
[...]
> +void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
> +				  struct hugetlb_cgroup *h_cg,
> +				  struct page *page)
> +{
> +	if (hugetlb_cgroup_disabled() || !h_cg)
> +		return;
> +
> +	spin_lock(&hugetlb_lock);
> +	set_hugetlb_cgroup(page, h_cg);
> +	spin_unlock(&hugetlb_lock);
> +	return;
> +}

I guess we can remove the lock here because nobody can see the page yet,
right?

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
