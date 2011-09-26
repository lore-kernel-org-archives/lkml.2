Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab1IZLDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 07:03:40 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:54769 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1IZLDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 07:03:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 26 Sep 2011 20:02:47 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Glauber Costa <glommer@parallels.com>
Cc: Greg Thelen <gthelen@google.com>, <linux-kernel@vger.kernel.org>,
        <paul@paulmenage.org>, <lizf@cn.fujitsu.com>, <ebiederm@xmission.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <linux-mm@kvack.org>,
        <kirill@shutemov.name>
Subject: Re: [PATCH v3 6/7] tcp buffer limitation: per-cgroup limit
Message-Id: <20110926200247.c80f7e47.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4E7DDB82.3030802@parallels.com>
References: <1316393805-3005-1-git-send-email-glommer@parallels.com>
	<1316393805-3005-7-git-send-email-glommer@parallels.com>
	<CAHH2K0Yuji2_2pMdzEaMvRx0KE7OOaoEGT+OK4gJgTcOPKuT9g@mail.gmail.com>
	<4E7DDB82.3030802@parallels.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Sep 2011 10:30:42 -0300
Glauber Costa <glommer@parallels.com> wrote:

> On 09/22/2011 03:01 AM, Greg Thelen wrote:
> > On Sun, Sep 18, 2011 at 5:56 PM, Glauber Costa<glommer@parallels.com>  wrote:
> >> +static inline bool mem_cgroup_is_root(struct mem_cgroup *mem)
> >> +{
> >> +       return (mem == root_mem_cgroup);
> >> +}
> >> +
> >
> > Why are you adding a copy of mem_cgroup_is_root().  I see one already
> > in v3.0.  Was it deleted in a previous patch?
> 
> Already answered by another good samaritan.
> 
> >> +static int tcp_write_maxmem(struct cgroup *cgrp, struct cftype *cft, u64 val)
> >> +{
> >> +       struct mem_cgroup *sg = mem_cgroup_from_cont(cgrp);
> >> +       struct mem_cgroup *parent = parent_mem_cgroup(sg);
> >> +       struct net *net = current->nsproxy->net_ns;
> >> +       int i;
> >> +
> >> +       if (!cgroup_lock_live_group(cgrp))
> >> +               return -ENODEV;
> >
> > Why is cgroup_lock_live_cgroup() needed here?  Does it protect updates
> > to sg->tcp_prot_mem[*]?
> >
> >> +static u64 tcp_read_maxmem(struct cgroup *cgrp, struct cftype *cft)
> >> +{
> >> +       struct mem_cgroup *sg = mem_cgroup_from_cont(cgrp);
> >> +       u64 ret;
> >> +
> >> +       if (!cgroup_lock_live_group(cgrp))
> >> +               return -ENODEV;
> >
> > Why is cgroup_lock_live_cgroup() needed here?  Does it protect updates
> > to sg->tcp_max_memory?
> 
> No, that is not my understanding. My understanding is this lock is 
> needed to protect against the cgroup just disappearing under our nose.
> 

Hm. reference count of dentry for cgroup isn't enough ?

Thanks,
-Kame

