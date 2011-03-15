Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159Ab1COQPy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:15:54 -0400
Received: from mout.perfora.net ([74.208.4.195]:49443 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758122Ab1COQPx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:15:53 -0400
Date: Tue, 15 Mar 2011 12:15:30 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 7/20]  7: uprobes: store/restore
	original instruction.
Message-ID: <20110315161530.GA23862@fibrous.localdomain>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6> <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6> <20110314180914.GA18855@fibrous.localdomain> <20110315092247.GW24254@linux.vnet.ibm.com> <1300196879.9910.271.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300196879.9910.271.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:Kcg2Ogwc2AB4qoXN9gnBlWgwJT0Azl2elvGXsNnYCPn
 7qEbflrS08Kh8zvGNo7+F9Y4Pr7NI0xdQdlAUboM7/KGRtKVa6
 p6tCNgSK7+lQrUOMzhvjS/HpzPNh5dwfkjhlRwd/4J8ttjGxyY
 vrPDQc0X5j2Ep3482KTAAI82+9pt+LDfC09gfKEykkZcGGtTuD
 EnT2Yur279PuSDNlVHt9A1hyqOX6CNb3Icyxce90Ls=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 09:47:59AM -0400, Steven Rostedt wrote:
> > 	rcu_read_lock()
> > 	if (mm->owner) {
> > 		get_task_struct(mm->owner)
> > 		tsk = mm->owner;
> > 	}
> > 	rcu_read_unlock()
> > 	if (!tsk)
> > 		return ret;
> > 
> > Agree?
> 
> Or:
> 
> 	rcu_read_lock();
> 	tsk = mm->owner;
> 	if (tsk)
> 		get_task_struct(tsk);
> 	rcu_read_unlock();
> 	if (!tsk)
> 		return ret;
> 
> Probably looks cleaner.

Yes, plus we should do "tsk = rcu_dereference(mm->owner);" and wrap the
whole thing in a static uprobes_get_mm_owner() or similar.


-- 
steve

