Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300Ab1COQYA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 12:24:00 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34514 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab1COQX6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 12:23:58 -0400
Date: Tue, 15 Mar 2011 21:47:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: Steven Rostedt <rostedt@goodmis.org>,
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
Message-ID: <20110315161752.GA6791@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
 <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6>
 <20110314180914.GA18855@fibrous.localdomain>
 <20110315092247.GW24254@linux.vnet.ibm.com>
 <1300196879.9910.271.camel@gandalf.stny.rr.com>
 <20110315161530.GA23862@fibrous.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20110315161530.GA23862@fibrous.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > 	rcu_read_lock();
> > 	tsk = mm->owner;
> > 	if (tsk)
> > 		get_task_struct(tsk);
> > 	rcu_read_unlock();
> > 	if (!tsk)
> > 		return ret;
> > 
> > Probably looks cleaner.
> 
> Yes, plus we should do "tsk = rcu_dereference(mm->owner);" and wrap the
> whole thing in a static uprobes_get_mm_owner() or similar.
> 

Okay, will do that.

-- 
Thanks and Regards
Srikar
