Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532Ab2C2IKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 04:10:15 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56609 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264Ab2C2IKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 04:10:05 -0400
Date: Thu, 29 Mar 2012 10:10:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, akpm@linux-foundation.org,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V4 05/10] hugetlb: add charge/uncharge calls for HugeTLB
 alloc/free
Message-ID: <20120329081003.GC30465@tiehlicka.suse.cz>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1331919570-2264-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120328131706.GF20949@tiehlicka.suse.cz>
 <87sjgs1v6x.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sjgs1v6x.fsf@skywalker.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 28-03-12 23:09:34, Aneesh Kumar K.V wrote:
> Michal Hocko <mhocko@suse.cz> writes:
> 
> > On Fri 16-03-12 23:09:25, Aneesh Kumar K.V wrote:
> >> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
> >> 
> >> This adds necessary charge/uncharge calls in the HugeTLB code
> >
> > This begs for more description...
> > Other than that it looks correct.
> >
> 
> Updated as below
> 
>     hugetlb: add charge/uncharge calls for HugeTLB alloc/free
>     
>     This adds necessary charge/uncharge calls in the HugeTLB code. We do
>     memcg charge in page alloc and uncharge in compound page destructor.
>     We also need to ignore HugeTLB pages in __mem_cgroup_uncharge_common
>     because that get called from delete_from_page_cache

and from mem_cgroup_end_migration used during soft_offline_page.

Btw., while looking at mem_cgroup_end_migration, I have noticed that you
need to take care of mem_cgroup_prepare_migration as well otherwise the
page would get charged as a normal (shmem) page.

>     
> -aneesh
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
