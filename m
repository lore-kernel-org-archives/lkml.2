Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932748Ab0HDMvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:51:19 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50414 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932619Ab0HDMvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:51:18 -0400
Date: Wed, 4 Aug 2010 18:18:22 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCHv9 2.6.35-rc4-tip 2/13]  uprobes: Breakpoint
 insertion/removal in user space applications.
Message-ID: <20100804124822.GC28212@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
 <20100712103235.27491.293.sendpatchset@localhost6.localdomain6>
 <20100720042814.GA13624@infradead.org>
 <20100720072202.GB19375@linux.vnet.ibm.com>
 <1280923528.1923.1058.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1280923528.1923.1058.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2010-08-04 14:05:28]:

> On Tue, 2010-07-20 at 12:52 +0530, Srikar Dronamraju wrote:
> > > Just wondering why these are function pointers.  Do we exepect an
> > > architecture to provide different versions of these for say 32 vs 64-bit
> > > binaries?  If not just making these arch provided helpers might be a lot
> > > simpler.  Especially in the current version where only very few of these
> > > are overriden by the architecture at all.
> > > 
> > 
> > Some of these functions are purely optional example being
> > validate_address. 
> > 
> > Some of these functions need not be defined by the architecture in
> > which case we default to the functions defined in common code. 
> > examples being: read_opcode, set_bkpt, and set_orig_insn.
> > 
> > Some of these functions are architecture mode specific, for example 
> > there is a architecture specific pre_xol needed for x86_64. However
> > generic pre_xol for x86_32 would suffice for x86_32.
> > 
> > Some of these functions need to be mandatorily defined by the
> > architecture. example being set_ip and analyze_insn.
> > 
> > Apart from the above flexibilities and enforcements that we can make
> > when we use function pointers, its would be handy to incorporate
> > more enhancements like return probes and booster. 
> 
> Still not sure why you're using this vector though, why not use weak
> function for optionals and defaults and no implementation for mandatory
> functions (and if the implementations fails to provide it, that will
> result in a link error).

Yes, we can certainly use weak functions instead of pointers. 
One another reason why we had these as function pointers in a
structure was that it would easy be  for a person porting uprobes to a
new architecture. i.e person porting to a new architecture knows in one
place(structure) which all functions need to be provided. 

However I would go with your suggestion and make the changes to use weak
functions in the next version of the patchset. 

> 
> Are there likely to be multiple different versions of this method vector
> around on a running kernel?

No for a running kernel, there will be only one method vector.

Also wanted to check with if you had tried perf probes and had
comments/suggestions on any of the other patches in the patchset.

--
Thanks and Regards
Srikar
