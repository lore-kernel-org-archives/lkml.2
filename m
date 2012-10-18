Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab2JRImQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:42:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52661 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752337Ab2JRImP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:42:15 -0400
Date: Thu, 18 Oct 2012 10:42:12 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Li Zefan <lizefan@huawei.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 5/6] memcg: make mem_cgroup_reparent_charges non failing
Message-ID: <20121018084212.GA24295@dhcp22.suse.cz>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-6-git-send-email-mhocko@suse.cz>
 <507FBE1B.4080906@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507FBE1B.4080906@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 18-10-12 16:30:19, Li Zefan wrote:
> >  static int mem_cgroup_force_empty_write(struct cgroup *cont, unsigned int event)
> > @@ -5013,13 +5011,9 @@ free_out:
> >  static int mem_cgroup_pre_destroy(struct cgroup *cont)
> >  {
> >  	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
> > -	int ret;
> >  
> > -	css_get(&memcg->css);
> > -	ret = mem_cgroup_reparent_charges(memcg);
> > -	css_put(&memcg->css);
> > -
> > -	return ret;
> > +	mem_cgroup_reparent_charges(memcg);
> > +	return 0;
> >  }
> >  
> 
> Why don't you make pre_destroy() return void?

Yes I plan to do that later after I have feedback for this RFC.  I am
especially interested whether the cgroup core patch is OK, resp. has to
be reworked to pull pre_destroy outside of cgroup_lock

Thanks
-- 
Michal Hocko
SUSE Labs
