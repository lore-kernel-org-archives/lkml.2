Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2ITNYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 09:24:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60449 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab2ITNYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 09:24:10 -0400
Date: Thu, 20 Sep 2012 15:24:00 +0200
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>, containers@lists.linux-foundation.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Glauber Costa <glommer@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Thomas Graf <tgraf@suug.ch>,
        "Serge E. Hallyn" <serue@us.ibm.com>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Neil Horman <nhorman@tuxdriver.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH 2.6.32] memcg: warn on deeper hierarchies with
 use_hierarchy==0
Message-ID: <20120920132400.GC23872@dhcp22.suse.cz>
References: <20120913205827.GO7677@google.com>
 <20120914150306.GQ28039@dhcp22.suse.cz>
 <20120919140203.GA5398@dhcp22.suse.cz>
 <20120919140308.GB5398@dhcp22.suse.cz>
 <alpine.DEB.2.00.1209191237020.749@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1209191237020.749@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 19-09-12 12:38:18, David Rientjes wrote:
> On Wed, 19 Sep 2012, Michal Hocko wrote:
> 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index f99f599..b61c34b 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3106,6 +3106,11 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
> >  	} else {
> >  		parent = mem_cgroup_from_cont(cont->parent);
> >  		mem->use_hierarchy = parent->use_hierarchy;
> > +		WARN_ONCE(!mem->use_hierarchy && parent != root_mem_cgroup,
> > +				"Creating hierarchies with use_hierarchy==0 "
> > +				"(flat hierarchy) is considered deprecated. "
> > +				"If you believe that your setup is correct, "
> > +				"we kindly ask you to contact linux-mm@kvack.org and let us know");
> 
> When I deprecated /proc/pid/oom_adj (now removed), we did a WARN_ONCE() 
> and others complained that this unnecessarily alters userspace scripts 
> that a serious issue has occurred and Linus agreed that we shouldn't do 
> deprecation in this way.  The alternative is to use printk_once() instead.

Yes printk_once is an alternative but I really wanted to have this as
much visible as possible. People tend to react to stack traceces more
and this one will trigger only if somebody is either doing something
wrong or the configuration is the one we are looking for.

Comparing to oom_adj, that one was used much more often so the WARN_ONCE
was too verbose especially when you usually had to wait for an userspace
update which is not the case here.
-- 
Michal Hocko
SUSE Labs
