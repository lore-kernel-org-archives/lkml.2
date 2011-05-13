Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab1EMJqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:46:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:51947 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758162Ab1EMJqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:46:36 -0400
Subject: Re: Sched_autogroup and niced processes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>,
        Carl-Johan Kjellander <carl-johan@klarna.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110513092933.GL13647@elte.hu>
References: <BANLkTimCpH3Nn2XnOJUKnK=dMObj1r8KEg@mail.gmail.com>
	 <BANLkTi=ckPK3BV07n=hmwOeqFUs3mrazFQ@mail.gmail.com>
	 <1305273950.15080.7.camel@marge.simson.net>
	 <20110513082250.GB13647@elte.hu> <1305276066.2561.1.camel@twins>
	 <20110513090537.GH13647@elte.hu> <1305277666.2561.9.camel@twins>
	 <20110513092933.GL13647@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 13 May 2011 11:46:30 +0200
Message-ID: <1305279990.2466.4.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 11:29 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Fri, 2011-05-13 at 11:05 +0200, Ingo Molnar wrote:
> > > Could we somehow automate this:
> > > 
> > >   > echo 19 > /proc/'pid of seti@home'/autogroup
> > > 
> > > and split off nice 19 tasks into separate groups and lower the group's 
> > > priority? 
> > 
> > Well I guess you can stack on all kinds of heuristics, do we want to?
> 
> Well have you seen my non-heuristic suggestion:
> 
>  | Another thing we could do is to lower the priority of a cgroup if it *only* 
>  | runs reniced tasks. I.e. track the 'maximum priority' of cgroups and 
>  | propagate that to their weight.
>  |
>  | This way renicing within cgroups will be more powerful and people do not have 
>  | to muck with cgroup details.
> 
> A cgroup assuming the highest priority of all tasks it contains is a pretty 
> natural definition and extension of priorities and also solves this usecase.

Well, that a heuristic in my book, and it totally destroys the
independence of groups from tasks (resulting in O(n) task nice
behaviour).

I really don't see why we should do this, if people don't want what it
does, don't use it. If you want something else, you can do all these
things from userspace to suit your exact needs.

We have enough knobs to set things up as you want them, no need to make
things more complicated.
