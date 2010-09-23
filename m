Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab0IWWLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:11:53 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51654 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751844Ab0IWWLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:11:43 -0400
Date: Thu, 23 Sep 2010 15:11:39 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: holzheu@linux.vnet.ibm.com, Shailabh Nagar <nagar1234@in.ibm.com>,
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
Subject: Re: [RFC][PATCH 00/10] taskstats: Enhancements for precise
 accounting
Message-ID: <20100923221139.GI23839@count0.beaverton.ibm.com>
References: <1285249681.1837.28.camel@holzheu-laptop>
 <20100923131136.356075f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923131136.356075f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 01:11:36PM -0700, Andrew Morton wrote:
> On Thu, 23 Sep 2010 15:48:01 +0200
> Michael Holzheu <holzheu@linux.vnet.ibm.com> wrote:
> 
> > Currently tools like "top" gather the task information by reading procfs
> > files. This has several disadvantages:
> > 

<snip>

> >      3. A new tool "ptop" (precise top) that uses the libraries
> 
> Talk to me about namespaces, please.  A lot of the new code involves
> PIDs, but PIDs are not system-wide unique.  A PID is relative to a PID
> namespace.  Does everything Just Work?  When userspace sends a PID to
> the kernel, that PID is assumed to be within the sending process's PID
> namespace?  If so, then please spell it all out in the changelogs.  If
> not then that is a problem!

Good point.

The pid ought to be valid in the _receiving_ task's pid namespace. That
can be difficult or impossible if we're talking about netlink broadcasts.
In this regard process events connector is an example of what not to do.

> If I can only observe processes in my PID namespace then is that a
> problem?  Should I be allowed to observe another PID namespace's
> processes?  I assume so, because I might be root.  If so, how is that
> to be done?

I don't think even "root" can see/use pids outside its namespace (without
Eric's setns patches). If you want to see all the tasks then rely on root
being able to do stuff in the initial pid namespace. If you really want
to use/know pids in the child pid namespaces then setns is also a
nice solution.

Cheers,
	-Matt Helsley
