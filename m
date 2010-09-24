Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757492Ab0IXSvU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:51:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757481Ab0IXSvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:51:17 -0400
Date: Fri, 24 Sep 2010 11:50:02 -0700
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
Message-Id: <20100924115002.fcb4385a.akpm@linux-foundation.org>
In-Reply-To: <1285319415.2179.116.camel@holzheu-laptop>
References: <1285249681.1837.28.camel@holzheu-laptop>
	<20100923131136.356075f4.akpm@linux-foundation.org>
	<1285319415.2179.116.camel@holzheu-laptop>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 11:10:15 +0200
Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:

> Hello Andrew,
> 
> On Thu, 2010-09-23 at 13:11 -0700, Andrew Morton wrote:
> > > GOALS OF THIS PATCH SET
> > > -----------------------
> > > The intention of this patch set is to provide better support for tools like
> > > top. The goal is to:
> > > 
> > > * provide a task snapshot mechanism where we can get a consistent view of
> > >   all running tasks.
> > > * provide a transport mechanism that does not require a lot of system calls
> > >   and that allows implementing low CPU overhead task monitoring.
> > > * provide microsecond CPU time granularity.
> > 
> > This is a big change!  If this is done right then we're heading in the
> > direction of deprecating the longstanding way in which userspace
> > observes the state of Linux processes and we're recommending that the
> > whole world migrate to taskstats.  I think?
> 
> Or it can be used as alternative. Since procfs has its drawbacks (e.g.
> performance) an alternative could be helpful. 

And it can be harmful.  More kernel code to maintain and test, more
userspace code to develop, maintain, etc.  Less user testing than if
there was a single interface.

> 
> > I worry that there's a dependency on CONFIG_NET?  If so then that's a
> > big problem because in N years time, 99% of the world will be using
> > taskstats, but a few embedded losers will be stuck using (and having to
> > support) the old tools.
> 
> Sure, but if we could add the /proc/taskstats approach, this dependency
> would not be there.

So why do we need to present the same info over netlink?

If the info is available via procfs then userspace code should use that
and not netlink, because that userspace code would also be applicable
to CONFIG_NET=n systems.

> 
> > Does this have the potential to save us from the CONFIG_NET=n problem?
> 
> Yes

Let's say that when it's all tested ;)

> Are PIDs over all namespaces unique?

Nope.  The same pid can be present in different namespaces at the same
time.

