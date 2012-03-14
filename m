Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756657Ab2CNP6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 11:58:16 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:43799 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab2CNP6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 11:58:14 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org
Subject: Re: [PATCH -V3 5/8] hugetlbfs: Add memcg control files for hugetlbfs
In-Reply-To: <20120314043530.d6f3d424.akpm@linux-foundation.org>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20120313144233.49026e6a.akpm@linux-foundation.org> <87lin38mkd.fsf@linux.vnet.ibm.com> <20120314043530.d6f3d424.akpm@linux-foundation.org>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 14 Mar 2012 21:27:57 +0530
Message-ID: <87d38f89a2.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12031415-9574-0000-0000-000001CCCF52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012 04:35:30 -0700, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 14 Mar 2012 16:40:58 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > > 
> > > > +int mem_cgroup_hugetlb_file_init(struct hstate *h, int idx);
> > > 
> > > 
> > > No, please put it in a header file.  Always.  Where both callers and
> > > the implementation see the same propotype.
> > > 
> > > > +#else
> > > > +static int mem_cgroup_hugetlb_file_init(struct hstate *h, int idx)
> > > > +{
> > > > +	return 0;
> > > > +}
> > > > +#endif
> > > 
> > > So this will go into the same header file.
> > > 
> > 
> > I was not sure whether i want to put mem_cgroup_hugetlb_file_init in
> > linux/memcontrol.h .
> 
> The above is a declaration, not the definition (implementation).
> 
> > Ideally i want to have that in mm/hugetlb.c and in
> > linux/hugetlb.h. That would require me to make mem_cgroup_read and
> > others non static and move few #defines to memcontrol.h. That would
> > involve larger code movement which i didn't want to do. ? What do you
> > suggest ? Just move mem_cgroup_hugetlb_file_init to memcontrol.h ?
> 
> In memcontrol.h:
> 
> #ifdef CONFIG_FOO
> extern int mem_cgroup_hugetlb_file_init(struct hstate *h, int idx);
> #else
> static inline int mem_cgroup_hugetlb_file_init(struct hstate *h, int idx)
> {
> 	return 0;
> }
> #endif
> 

Will do that in the next iteration.

-aneesh

