Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1CPRks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 13:40:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63442 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab1CPRkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 13:40:42 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=Dpgx0ZSdzJoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=ATN7j0xLGzvCgS7kXwIA:9 a=jTZ60x4jsVi1qGjFOrCj161FRqYA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH v2 2.6.38-rc8-tip 7/20]  7: uprobes: store/restore
 original instruction.
From: Steven Rostedt <rostedt@goodmis.org>
To: balbir@linux.vnet.ibm.com
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
In-Reply-To: <20110316055138.GI3410@balbir.in.ibm.com>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6>
	 <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6>
	 <20110314180914.GA18855@fibrous.localdomain>
	 <20110315092247.GW24254@linux.vnet.ibm.com>
	 <1300211862.2203.302.camel@twins> <20110315185841.GH3410@balbir.in.ibm.com>
	 <1300217432.2250.0.camel@laptop>
	 <1300217560.9910.296.camel@gandalf.stny.rr.com>
	 <20110316055138.GI3410@balbir.in.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 16 Mar 2011 13:40:37 -0400
Message-ID: <1300297237.16880.42.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-16 at 11:21 +0530, Balbir Singh wrote:
> * Steven Rostedt <rostedt@goodmis.org> [2011-03-15 15:32:40]:
> 
> > On Tue, 2011-03-15 at 20:30 +0100, Peter Zijlstra wrote:
> > > On Wed, 2011-03-16 at 00:28 +0530, Balbir Singh wrote:
> > 
> > > > I accept the blame and am willing to fix anything incorrect found in
> > > > the code. 
> > > 
> > > :-), ok sounds right, just wasn't entirely obvious when having a quick
> > > look.
> > 
> > Does that mean we should be adding a comment there?
> >
> 
> This is what the current documentation looks like.
> 
> #ifdef CONFIG_MM_OWNER
>         /*
>          * "owner" points to a task that is regarded as the canonical
>          * user/owner of this mm. All of the following must be true in
>          * order for it to be changed:
>          *
>          * current == mm->owner
>          * current->mm != mm
>          * new_owner->mm == mm
>          * new_owner->alloc_lock is held
>          */
>         struct task_struct __rcu *owner;
> #endif
> 
> Do you want me to document the fork/exit case?
>  

Ah, looking at the code, I guess comments are not needed.

Thanks,

-- Steve


