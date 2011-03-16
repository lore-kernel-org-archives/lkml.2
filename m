Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751489Ab1CPFvz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 01:51:55 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:52147 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1CPFvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 01:51:49 -0400
Date: Wed, 16 Mar 2011 11:21:39 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20110316055138.GI3410@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6>
 <20110314180914.GA18855@fibrous.localdomain>
 <20110315092247.GW24254@linux.vnet.ibm.com>
 <1300211862.2203.302.camel@twins>
 <20110315185841.GH3410@balbir.in.ibm.com>
 <1300217432.2250.0.camel@laptop>
 <1300217560.9910.296.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1300217560.9910.296.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt <rostedt@goodmis.org> [2011-03-15 15:32:40]:

> On Tue, 2011-03-15 at 20:30 +0100, Peter Zijlstra wrote:
> > On Wed, 2011-03-16 at 00:28 +0530, Balbir Singh wrote:
> 
> > > I accept the blame and am willing to fix anything incorrect found in
> > > the code. 
> > 
> > :-), ok sounds right, just wasn't entirely obvious when having a quick
> > look.
> 
> Does that mean we should be adding a comment there?
>

This is what the current documentation looks like.

#ifdef CONFIG_MM_OWNER
        /*
         * "owner" points to a task that is regarded as the canonical
         * user/owner of this mm. All of the following must be true in
         * order for it to be changed:
         *
         * current == mm->owner
         * current->mm != mm
         * new_owner->mm == mm
         * new_owner->alloc_lock is held
         */
        struct task_struct __rcu *owner;
#endif

Do you want me to document the fork/exit case?
 

-- 
	Three Cheers,
	Balbir
