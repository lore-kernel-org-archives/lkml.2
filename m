Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab1FJNbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:31:39 -0400
Received: from cantor.suse.de ([195.135.220.2]:54325 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756407Ab1FJNbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:31:36 -0400
Date: Fri, 10 Jun 2011 15:31:33 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        Ying Han <yinghan@google.com>
Subject: Re: [BUGFIX][PATCH v3] memcg: fix behavior of per cpu charge cache
 draining.
Message-ID: <20110610133133.GB3818@tiehlicka.suse.cz>
References: <20110609093045.1f969d30.kamezawa.hiroyu@jp.fujitsu.com>
 <20110610081218.GC4832@tiehlicka.suse.cz>
 <20110610173958.d9ab901c.kamezawa.hiroyu@jp.fujitsu.com>
 <20110610090802.GB4110@tiehlicka.suse.cz>
 <20110610185952.a07b968f.kamezawa.hiroyu@jp.fujitsu.com>
 <20110610110412.GE4110@tiehlicka.suse.cz>
 <BANLkTingsPiS81KEkOb6+eKdz=2UMUHmQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTingsPiS81KEkOb6+eKdz=2UMUHmQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 10-06-11 21:24:51, Hiroyuki Kamezawa wrote:
> 2011/6/10 Michal Hocko <mhocko@suse.cz>:
> > On Fri 10-06-11 18:59:52, KAMEZAWA Hiroyuki wrote:
[...]
> >> @@ -1670,8 +1670,7 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
> >>               victim = mem_cgroup_select_victim(root_mem);
> >>               if (victim == root_mem) {
> >>                       loop++;
> >> -                     if (loop >= 1)
> >> -                             drain_all_stock_async();
> >> +                     drain_all_stock_async(root_mem);
> >>                       if (loop >= 2) {
> >>                               /*
> >>                                * If we have not been able to reclaim
> >
> > This still doesn't prevent from direct reclaim even though we have freed
> > enough pages from pcp caches. Should I post it as a separate patch?
> >
> 
> yes. please in different thread. Maybe moving this out of loop will
> make sense. (And I have a cleanup patch for this loop. I'll do that
> when I post it later, anyway)

OK, I will wait for your cleanup then.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
