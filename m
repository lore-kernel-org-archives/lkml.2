Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab0IXMjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 08:39:22 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:45433 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab0IXMjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 08:39:20 -0400
Subject: Re: [RFC][PATCH 00/10] taskstats: Enhancements for precise
 accounting
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Reply-To: holzheu@linux.vnet.ibm.com
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>,
        John stultz <johnstul@us.ibm.com>,
        containers@lists.linux-foundation.org, linux-s390@vger.kernel.org,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <20100923221139.GI23839@count0.beaverton.ibm.com>
References: <1285249681.1837.28.camel@holzheu-laptop>
	 <20100923131136.356075f4.akpm@linux-foundation.org>
	 <20100923221139.GI23839@count0.beaverton.ibm.com>
Content-Type: text/plain; charset="us-ascii"
Organization: IBM
Date: Fri, 24 Sep 2010 14:39:11 +0200
Message-ID: <1285331951.2179.326.camel@holzheu-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Matt,

On Thu, 2010-09-23 at 15:11 -0700, Matt Helsley wrote:
> > Talk to me about namespaces, please.  A lot of the new code involves
> > PIDs, but PIDs are not system-wide unique.  A PID is relative to a PID
> > namespace.  Does everything Just Work?  When userspace sends a PID to
> > the kernel, that PID is assumed to be within the sending process's PID
> > namespace?  If so, then please spell it all out in the changelogs.  If
> > not then that is a problem!
> 
> Good point.
> 
> The pid ought to be valid in the _receiving_ task's pid namespace. That
> can be difficult or impossible if we're talking about netlink broadcasts.
> In this regard process events connector is an example of what not to do.

I think that the netlink taskstats commands are executed in the context
of the calling process (at least my printk shows me that). The command
collects the process data using "current->nsproxy->pid_ns" and creates a
netlink reply. So everything should be fine here. Shouldn't it?

Hmmm, but for exit events, this might be broken in taskstats. The code
looks to me that every exiting task independent from the namespace is
reported as event via taskstat_exit(). Maybe I am missing something...

Michael



