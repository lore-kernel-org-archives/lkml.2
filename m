Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156Ab0I0UEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:04:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755947Ab0I0UEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:04:14 -0400
Date: Mon, 27 Sep 2010 13:02:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: holzheu@linux.vnet.ibm.com
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
Subject: Re: [RFC][PATCH 00/10] taskstats: Enhancements for precise
 accounting
Message-Id: <20100927130256.5d9a3db8.akpm@linux-foundation.org>
In-Reply-To: <1285579127.2116.62.camel@holzheu-laptop>
References: <1285249681.1837.28.camel@holzheu-laptop>
	<20100923131136.356075f4.akpm@linux-foundation.org>
	<1285319415.2179.116.camel@holzheu-laptop>
	<20100924115002.fcb4385a.akpm@linux-foundation.org>
	<1285579127.2116.62.camel@holzheu-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010 11:18:47 +0200
Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:

> Hello Andrew,
> 
> On Fri, 2010-09-24 at 11:50 -0700, Andrew Morton wrote:
> > > > This is a big change!  If this is done right then we're heading in the
> > > > direction of deprecating the longstanding way in which userspace
> > > > observes the state of Linux processes and we're recommending that the
> > > > whole world migrate to taskstats.  I think?
> > > 
> > > Or it can be used as alternative. Since procfs has its drawbacks (e.g.
> > > performance) an alternative could be helpful. 
> > 
> > And it can be harmful.  More kernel code to maintain and test, more
> > userspace code to develop, maintain, etc.  Less user testing than if
> > there was a single interface.
> 
> Sure, the value has to be big enough to justify the effort.
> 
> But as I said, with taskstats and procfs we already have two interfaces
> for getting task information.

That doesn't mean it was the right thing to do!  For the reasons I
outline above, it can be the wrong thing to do and strengthening one of
the alternatives worsens the problem.

> Currently in procfs there is information
> than you can't find in taskstats. But also the other way round in the
> taskstats structure there is very useful information that you can't get
> under proc. E.g. the task delay times, IO accounting, etc.

Sounds like a big screwup ;)

Look at it this way: if you were going to sit down and start to design
a new operating system from scratch, would you design the task status
reporting system as it currently stands in Linux?  Don't think so!

> So currently
> tools have to use both interfaces to get all information, which is not
> optimal.
> 
> > > 
> > > > I worry that there's a dependency on CONFIG_NET?  If so then that's a
> > > > big problem because in N years time, 99% of the world will be using
> > > > taskstats, but a few embedded losers will be stuck using (and having to
> > > > support) the old tools.
> > > 
> > > Sure, but if we could add the /proc/taskstats approach, this dependency
> > > would not be there.
> > 
> > So why do we need to present the same info over netlink?
> 
> Good point. It is not really necessary. I started development using the
> netlink code. Therefore I first added the new command in the netlink
> code. I also thought, it would be a good idea to provide all netlink
> commands over the procfs interface to be consistent.

Maybe we should have delivered taskstats over procfs from day one.

