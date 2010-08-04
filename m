Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932667Ab0HDMGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 08:06:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38266 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932647Ab0HDMGn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 08:06:43 -0400
Subject: Re: [PATCHv9 2.6.35-rc4-tip 2/13]  uprobes: Breakpoint
 insertion/removal in user space applications.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
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
In-Reply-To: <20100720072202.GB19375@linux.vnet.ibm.com>
References: <20100712103214.27491.15142.sendpatchset@localhost6.localdomain6>
	 <20100712103235.27491.293.sendpatchset@localhost6.localdomain6>
	 <20100720042814.GA13624@infradead.org>
	 <20100720072202.GB19375@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 04 Aug 2010 14:05:28 +0200
Message-ID: <1280923528.1923.1058.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-07-20 at 12:52 +0530, Srikar Dronamraju wrote:
> > Just wondering why these are function pointers.  Do we exepect an
> > architecture to provide different versions of these for say 32 vs 64-bit
> > binaries?  If not just making these arch provided helpers might be a lot
> > simpler.  Especially in the current version where only very few of these
> > are overriden by the architecture at all.
> > 
> > > +unsigned long uprobes_read_vm(struct task_struct *tsk, void __user *vaddr,
> > > +                                   void *kbuf, unsigned long nbytes)
> 
> 
> Some of these functions are purely optional example being
> validate_address. 
> 
> Some of these functions need not be defined by the architecture in
> which case we default to the functions defined in common code. 
> examples being: read_opcode, set_bkpt, and set_orig_insn.
> 
> Some of these functions are architecture mode specific, for example 
> there is a architecture specific pre_xol needed for x86_64. However
> generic pre_xol for x86_32 would suffice for x86_32.
> 
> Some of these functions need to be mandatorily defined by the
> architecture. example being set_ip and analyze_insn.
> 
> Apart from the above flexibilities and enforcements that we can make
> when we use function pointers, its would be handy to incorporate
> more enhancements like return probes and booster. 

Still not sure why you're using this vector though, why not use weak
function for optionals and defaults and no implementation for mandatory
functions (and if the implementations fails to provide it, that will
result in a link error).

Are there likely to be multiple different versions of this method vector
around on a running kernel?
