Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab2EaJoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 05:44:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38734 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753964Ab2EaJoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 05:44:05 -0400
Date: Thu, 31 May 2012 11:43:56 +0200
From: Michal Hocko <mhocko@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Konrad Rzeszutek Wilk <konrad@darnok.org>, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, rientjes@google.com,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH -V7 10/14] hugetlbfs: Add new HugeTLB cgroup
Message-ID: <20120531094355.GB12809@tiehlicka.suse.cz>
References: <1338388739-22919-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1338388739-22919-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120531011953.GE401@localhost.localdomain>
 <20120531054316.GD24855@skywalker.linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531054316.GD24855@skywalker.linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 31-05-12 11:13:16, Aneesh Kumar K.V wrote:
> On Wed, May 30, 2012 at 09:19:54PM -0400, Konrad Rzeszutek Wilk wrote:
[...]
> > > +static struct cgroup_subsys_state *hugetlb_cgroup_create(struct cgroup *cgroup)
> > > +{
> > > +	int idx;
> > > +	struct cgroup *parent_cgroup;
> > > +	struct hugetlb_cgroup *h_cgroup, *parent_h_cgroup;
> > > +
> > > +	h_cgroup = kzalloc(sizeof(*h_cgroup), GFP_KERNEL);
> > > +	if (!h_cgroup)
> > > +		return ERR_PTR(-ENOMEM);
> > > +
> > 
> > No need to check cgroup for NULL?
> 
> Other cgroups (memcg) doesn't do that. Can we really get NULL cgroup tere ?

No we cannot. See cfa449461e67b60df986170eecb089831fa9e49a

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
