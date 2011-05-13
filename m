Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932841Ab1EMKEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 06:04:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34506 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755989Ab1EMKEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 06:04:21 -0400
Date: Fri, 13 May 2011 12:04:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        Carl-Johan Kjellander <carl-johan@klarna.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Sched_autogroup and niced processes
Message-ID: <20110513100411.GA21022@elte.hu>
References: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
 <BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
 <1305273950.15080.7.camel@marge.simson.net>
 <20110513082250.GB13647@elte.hu>
 <1305276066.2561.1.camel@twins>
 <20110513090537.GH13647@elte.hu>
 <1305277666.2561.9.camel@twins>
 <20110513092933.GL13647@elte.hu>
 <1305279990.2466.4.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305279990.2466.4.camel@twins>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Fri, 2011-05-13 at 11:29 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Fri, 2011-05-13 at 11:05 +0200, Ingo Molnar wrote:
> > > > Could we somehow automate this:
> > > > 
> > > >   > echo 19 > /proc/'pid of seti@home'/autogroup
> > > > 
> > > > and split off nice 19 tasks into separate groups and lower the group's 
> > > > priority? 
> > > 
> > > Well I guess you can stack on all kinds of heuristics, do we want to?
> > 
> > Well have you seen my non-heuristic suggestion:
> > 
> >  | Another thing we could do is to lower the priority of a cgroup if it *only* 
> >  | runs reniced tasks. I.e. track the 'maximum priority' of cgroups and 
> >  | propagate that to their weight.
> >  |
> >  | This way renicing within cgroups will be more powerful and people do not have 
> >  | to muck with cgroup details.
> > 
> > A cgroup assuming the highest priority of all tasks it contains is a pretty 
> > natural definition and extension of priorities and also solves this usecase.
> 
> Well, that a heuristic in my book, and it totally destroys the independence 
> of groups from tasks (resulting in O(n) task nice behaviour).
> 
> I really don't see why we should do this, if people don't want what it does, 
> don't use it. If you want something else, you can do all these things from 
> userspace to suit your exact needs.
> 
> We have enough knobs to set things up as you want them, no need to make 
> things more complicated.

Ok, i guess you are right, propagating priorities does break the clean 
hieararchy we have currently.

Still, the other important problem is that we still seem to have a bug, even 
with the cgroup set to low prio seti@home is sucking up CPU resources ...

Thanks,

	Ingo
