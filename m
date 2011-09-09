Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab1IIMbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 08:31:25 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35201 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757198Ab1IIMbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 08:31:24 -0400
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Date: Fri, 09 Sep 2011 14:31:02 +0200
In-Reply-To: <20110908151433.GB6587@linux.vnet.ibm.com>
References: <20110607154542.GA2991@linux.vnet.ibm.com>
	 <1307529966.4928.8.camel@dhcp-10-30-22-158.sw.ru>
	 <20110608163234.GA23031@linux.vnet.ibm.com>
	 <BANLkTim7a9uhH_K6sw4YdqWB6frT+HUqqQ@mail.gmail.com>
	 <20110610181719.GA30330@linux.vnet.ibm.com>
	 <BANLkTimE1b8HP-q4jgsv5jPD5S-dRoUi_g@mail.gmail.com>
	 <20110615053716.GA390@linux.vnet.ibm.com>
	 <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
	 <20110907152009.GA3868@linux.vnet.ibm.com>
	 <1315423342.11101.25.camel@twins>
	 <20110908151433.GB6587@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315571462.26517.9.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-08 at 20:45 +0530, Srivatsa Vaddagiri wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2011-09-07 21:22:22]:
> 
> > On Wed, 2011-09-07 at 20:50 +0530, Srivatsa Vaddagiri wrote:
> > > 
> > > Fix excessive idle time reported when cgroups are capped. 
> > 
> > Where from? The whole idea of bandwidth caps is to introduce idle time,
> > so what's excessive and where does it come from?
> 
> We have setup cgroups and their hard limits so that in theory they should
> consume the entire capacity available on machine, leading to 0% idle time.
> That's not what we see. A more detailed description of the setup and the problem
> is here:
> 
> https://lkml.org/lkml/2011/6/7/352

That's frigging irrelevant isn't it? A patch should contain its own
justification.

> Machine : 16-cpus (2 Quad-core w/ HT enabled)
> Cgroups : 5 in number (C1-C5), each having {2, 2, 4, 8, 16} tasks respectively.
>           Further, each task is placed in its own (sub-)cgroup with 
>           a capped usage of 50% CPU.

So that's loads: {512,512}, {512,512}, {256,256,256,256}, {128,..} and {64,..}

And you expect that to be balanced perfectly when a bandwidth cap is
introduced, I think you need some expectation adjustments.


> From what I could find out, the "excess" idle time crops up because
> load-balancer is not perfect. For example, there are instances when a
> CPU has just 1 task on its runqueue (rather then the ideal number of 2
> tasks/cpu). When that lone task exceeds its 50% limit, cpu is forced to
> become idle.

So try and cure that instead of frobbing crap like this.

> > >  The patch introduces the notion of "steal" 
> > 
> > The virt folks already claimed steal-time and have it mean something
> > entirely different. You get to pick a new name.
> 
> grace time?

Well, ideally this frobbing of symptoms instead of fixing of causes
isn't going to happen at all, its just retarded. And it most certainly
shouldn't be the first approach to any problem. 


> > Ok, so this is a solution to an unstated problem. Why is it a good
> > solution?
> 
> I am not sure if there are any "good" solutions to this problem! 

Good, so then we're not going to do it, full stop.

> One
> possibility is to make the idle load balancer become aggressive in
> pulling tasks across sched-domain boundaries i.e when a CPU becomes idle
> (after a task got throttled) and invokes the idle load balancer, it
> should try "harder" at pulling a task from far-off cpus (across
> package/node boundaries)?

How about we just live with it? You set up a nearly impossible
(non-scalable) problem and then complain we don't do well. Tough fscking
luck, don't do that.

I mean, I'm all for improving things, but your frobbing here is just not
going to happen, most certainly not without very _very_ good
justification, and your patch frankly didn't have any.

Furthermore your patch frobs the bandwidth accounting but doesn't spend
a single word explaining how, if at all, it keeps the accounting a 0-sum
game.

Seriously, you suck, you patch sucks and your method sucks. Go away.

