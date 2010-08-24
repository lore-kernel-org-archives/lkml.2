Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485Ab0HYAD4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 20:03:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42007 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab0HYADw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 20:03:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 25 Aug 2010 08:58:43 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-mm@kvack.org,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com, "menage@google.com" <menage@google.com>
Subject: Re: [PATCH 1/5] cgroup: ID notification call back
Message-Id: <20100825085843.54277f3c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4C738B34.6070602@cn.fujitsu.com>
References: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
	<20100820185816.1dbcd53a.kamezawa.hiroyu@jp.fujitsu.com>
	<4C738B34.6070602@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010 17:04:52 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > CC'ed to Paul Menage and Li Zefan.
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > When cgroup subsystem use ID (ss->use_id==1), each css's ID is assigned
> > after successful call of ->create(). css_ID is tightly coupled with
> > css struct itself but it is allocated by ->create() call, IOW,
> > per-subsystem special allocations.
> > 
> > To know css_id before creation, this patch adds id_attached() callback.
> > after css_ID allocation. This will be used by memory cgroup's quick lookup
> > routine.
> > 
> > Maybe you can think of other implementations as
> > 	- pass ID to ->create()
> > 	or
> > 	- add post_create()
> > 	etc...
> > But when considering dirtiness of codes, this straightforward patch seems
> > good to me. If someone wants post_create(), this patch can be replaced.
> > 
> > Changelog: 20100820
> >  - new approarch.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> ...
> >  
> > Index: mmotm-0811/include/linux/cgroup.h
> > ===================================================================
> > --- mmotm-0811.orig/include/linux/cgroup.h
> > +++ mmotm-0811/include/linux/cgroup.h
> > @@ -475,6 +475,7 @@ struct cgroup_subsys {
> >  			struct cgroup *cgrp);
> >  	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
> >  	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
> > +	void (*id_attached)(struct cgroup_subsys *ss, struct cgroup *cgrp);
> 
> Maybe pass the id number to id_attached() is better.
> 
ok.

> And actually the @ss argument is not necessary, because the memcg's
> id_attached() handler of course knows it's dealing with the memory
> cgroup subsystem.
> 
> So I suspect we can just remove all the @ss from all the callbacks..
> 

I agree. But could you write "remove ss" patch later ?
It seems an design change. I leave "ss" as this for now.

Thanks
-Kame


