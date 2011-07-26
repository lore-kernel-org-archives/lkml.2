Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819Ab1GZVST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 17:18:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58965 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753112Ab1GZVSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 17:18:16 -0400
Date: Tue, 26 Jul 2011 14:17:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        balbir@linux.vnet.ibm.com, linux-mm@kvack.org,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org,
        Tim Deegan <Tim.Deegan@citrix.com>
Subject: Re: [PATCH] memcg: do not expose uninitialized mem_cgroup_per_node
 to world
Message-Id: <20110726141754.c69b96c6.akpm@linux-foundation.org>
In-Reply-To: <4DF24D04.1080802@redhat.com>
References: <1306925044-2828-1-git-send-email-imammedo@redhat.com>
	<20110601123913.GC4266@tiehlicka.suse.cz>
	<4DE6399C.8070802@redhat.com>
	<20110601134149.GD4266@tiehlicka.suse.cz>
	<4DE64F0C.3050203@redhat.com>
	<20110601152039.GG4266@tiehlicka.suse.cz>
	<4DE66BEB.7040502@redhat.com>
	<BANLkTimbqHPeUdue=_Z31KVdPwcXtbLpeg@mail.gmail.com>
	<4DE8D50F.1090406@redhat.com>
	<BANLkTinMamg_qesEffGxKu3QkT=zyQ2MRQ@mail.gmail.com>
	<4DEE26E7.2060201@redhat.com>
	<20110608123527.479e6991.kamezawa.hiroyu@jp.fujitsu.com>
	<20110608140951.115ab1dd.akpm@linux-foundation.org>
	<4DF24D04.1080802@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Jun 2011 18:57:40 +0200
Igor Mammedov <imammedo@redhat.com> wrote:

> On 06/08/2011 11:09 PM, Andrew Morton wrote:
> > The original patch:
> >
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4707,7 +4707,6 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
> >   	if (!pn)
> >   		return 1;
> >
> > -	mem->info.nodeinfo[node] = pn;
> >   	for (zone = 0; zone<  MAX_NR_ZONES; zone++) {
> >   		mz =&pn->zoneinfo[zone];
> >   		for_each_lru(l)
> > @@ -4716,6 +4715,7 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
> >   		mz->on_tree = false;
> >   		mz->mem = mem;
> >   	}
> > +	mem->info.nodeinfo[node] = pn;
> >   	return 0;
> >   }
> >
> > looks like a really good idea.  But it needs a new changelog and I'd be
> > a bit reluctant to merge it as it appears that the aptch removes our
> > only known way of reproducing a bug.
> >
> > So for now I think I'll queue the patch up unchangelogged so the issue
> > doesn't get forgotten about.
> >
> Problem was in rhel's xen hv.
> It was missing fix for imul emulation.
> Details here 
> http://lists.xensource.com/archives/html/xen-devel/2011-06/msg00801.html
> Thanks to Tim Deegan and everyone who was involved in the discussion.

I really don't want to trawl through a lengthy xen bug report and write
your changelog for you.

We still have no changelog for this patch.  Please send one.
