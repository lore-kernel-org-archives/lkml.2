Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932848Ab0I0JS4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 05:18:56 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:38725 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807Ab0I0JSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 05:18:54 -0400
Subject: Re: [RFC][PATCH 00/10] taskstats: Enhancements for precise
 accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shailabh Nagar <nagar1234@in.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Oleg Nesterov <oleg@redhat.com>, John stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
        containers@lists.linux-foundation.org
In-Reply-To: <20100924115002.fcb4385a.akpm@linux-foundation.org>
References: <1285249681.1837.28.camel@holzheu-laptop>
	 <20100923131136.356075f4.akpm@linux-foundation.org>
	 <1285319415.2179.116.camel@holzheu-laptop>
	 <20100924115002.fcb4385a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Mon, 27 Sep 2010 11:18:47 +0200
Message-ID: <1285579127.2116.62.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

On Fri, 2010-09-24 at 11:50 -0700, Andrew Morton wrote:
> > > This is a big change!  If this is done right then we're heading in the
> > > direction of deprecating the longstanding way in which userspace
> > > observes the state of Linux processes and we're recommending that the
> > > whole world migrate to taskstats.  I think?
> > 
> > Or it can be used as alternative. Since procfs has its drawbacks (e.g.
> > performance) an alternative could be helpful. 
> 
> And it can be harmful.  More kernel code to maintain and test, more
> userspace code to develop, maintain, etc.  Less user testing than if
> there was a single interface.

Sure, the value has to be big enough to justify the effort.

But as I said, with taskstats and procfs we already have two interfaces
for getting task information. Currently in procfs there is information
than you can't find in taskstats. But also the other way round in the
taskstats structure there is very useful information that you can't get
under proc. E.g. the task delay times, IO accounting, etc. So currently
tools have to use both interfaces to get all information, which is not
optimal.

> > 
> > > I worry that there's a dependency on CONFIG_NET?  If so then that's a
> > > big problem because in N years time, 99% of the world will be using
> > > taskstats, but a few embedded losers will be stuck using (and having to
> > > support) the old tools.
> > 
> > Sure, but if we could add the /proc/taskstats approach, this dependency
> > would not be there.
> 
> So why do we need to present the same info over netlink?

Good point. It is not really necessary. I started development using the
netlink code. Therefore I first added the new command in the netlink
code. I also thought, it would be a good idea to provide all netlink
commands over the procfs interface to be consistent.

> If the info is available via procfs then userspace code should use that
> and not netlink, because that userspace code would also be applicable
> to CONFIG_NET=n systems.
> 
> > 
> > > Does this have the potential to save us from the CONFIG_NET=n problem?
> > 
> > Yes
> 
> Let's say that when it's all tested ;)

That was more a theoretical statement :-)

I probably still have to ensure that the kernel config options
dependencies are done correctly.

Michael

