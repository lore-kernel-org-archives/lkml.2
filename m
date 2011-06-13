Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab1FMExX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 00:53:23 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:33044 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab1FMExT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 00:53:19 -0400
Date: Sun, 12 Jun 2011 21:23:40 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Cui, Dexuan" <dexuan.cui@intel.com>
Cc: "'Mathieu Desnoyers'" <mathieu.desnoyers@efficios.com>,
        "ltt-dev@lists.casi.polymtl.ca" <ltt-dev@lists.casi.polymtl.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rp@svcs.cs.pdx.edu" <rp@svcs.cs.pdx.edu>
Subject: Re: [ltt-dev] [RELEASE] Userspace RCU 0.6.0
Message-ID: <20110613042340.GH2212@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110611011417.GA8722@Krystal>
 <1865303E0DED764181A9D882DEF65FB699650124A2@shsmsx502.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1865303E0DED764181A9D882DEF65FB699650124A2@shsmsx502.ccr.corp.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 10:06:09AM +0800, Cui, Dexuan wrote:
> Mathieu Desnoyers wrote:
> > liburcu is a LGPLv2.1 userspace RCU (read-copy-update) library. This
> > data synchronization library provides read-side access which scales
> > linearly with the number of cores. It does so by allowing multiples
> > copies of a given data structure to live at the same time, and by
> > monitoring the data structure accesses to detect grace periods after
> > which memory reclamation is possible.
> > 
> > Changelog:
> > 
> > - Added call_rcu() support, graciously contributed by Paul E.
> > McKenney. 
> > - Added urcu/cds.h and merged all "Concurrent Data Containers" (CDS)
> >   into a single .so: liburcu-cds.so to have a single header/shared
> >   object holding all concurrency-aware data containers. It provides
> >   support for RCU lists, queues and stacks at the moment.
> > - liburcu 0.6.0 now allows linking a single application with multiple
> >   flavors of RCU. This required a library API change which is
> >   incompatible with older 0.5.x liburcu. The .so version number
> >   is therefore bumped from 0 to 1 (e.g. liburcu.so.1).
> > - Added "atfork" handling API, documented in README. Only useful for
> >   processes using fork() without following exec().
> > - Renaming the following files, keeping the old files (producing a
> >   compiler warning):
> >     urcu/uatomic_arch.h -> urcu/uatomic.h
> >     urcu/urcu-futex.h -> urcu/futex.h
> >     urcu/urcu_ref.h -> urcu/ref.h
> > 
> > Project website: http://lttng.org/urcu
> > Download link: http://www.lttng.org/files/urcu/
> 
> Hi Mathieu,
> The release can't build in my side:
> 
> $ tar -jxf userspace-rcu-0.6.0.tar.bz2 && cd userspace-rcu-0.6.0 && ./configure && make
> 
> make  all-recursive
> make[1]: Entering directory `/home/dcui/userspace-rcu-0.6.0'
> Making all in .
> make[2]: Entering directory `/home/dcui/userspace-rcu-0.6.0'
>   CC     wfqueue.lo
>   CC     wfstack.lo
>   CC     rculfqueue.lo
>   CC     rculfstack.lo
>   CCLD   liburcu-cds.la
>   CC     urcu.lo
> urcu.c:438:32: error: urcu-call-rcu-impl.h: No such file or directory
> urcu.c:439:29: error: urcu-defer-impl.h: No such file or directory
> make[2]: *** [urcu.lo] Error 1
> make[2]: Leaving directory `/home/dcui/userspace-rcu-0.6.0'
> make[1]: *** [all-recursive] Error 1
> make[1]: Leaving directory `/home/dcui/userspace-rcu-0.6.0'
> make: *** [all] Error 2
> 
> Can you please have a look?

I get the same thing from the tarball.  But the git tree works just fine,
so my guess is that the tarball creation left out a couple of files.

							Thanx, Paul
