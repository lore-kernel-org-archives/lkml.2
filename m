Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878Ab1DKVZH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:25:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:60392 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1DKVZG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:25:06 -0400
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20110411210223.GB2226@linux.vnet.ibm.com>
References: <4D9CDACB.9050705@linux.intel.com>
	 <20110407003041.GD2265@linux.vnet.ibm.com>
	 <4D9D507F.2040006@cn.fujitsu.com>
	 <20110407154737.GF2262@linux.vnet.ibm.com>
	 <20110407162600.GA24227@linux.vnet.ibm.com>
	 <4D9E6438.5030206@cn.fujitsu.com>
	 <20110408051359.GA2318@linux.vnet.ibm.com> <4DA2709E.50902@cn.fujitsu.com>
	 <20110411051241.GB18415@linux.vnet.ibm.com>
	 <4DA2BC4E.4010000@cn.fujitsu.com>
	 <20110411210223.GB2226@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Apr 2011 23:24:34 +0200
Message-ID: <1302557074.2388.108.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-11 at 14:02 -0700, Paul E. McKenney wrote:
> On Mon, Apr 11, 2011 at 04:31:10PM +0800, Lai Jiangshan wrote:
> > On 04/11/2011 01:12 PM, Paul E. McKenney wrote:
> > 
> > > -static inline struct task_struct *next_thread(const struct task_struct *p)
> > > -{
> > > -	return list_entry_rcu(p->thread_group.next,
> > > -			      struct task_struct, thread_group);
> > > -}
> > > +/* Avoid #include hell for inlining rcu_read_lock(). */
> > > +#define next_thread(p) \
> > > +	list_entry_rcu((p)->thread_group.next, struct task_struct, thread_group)
> > >  

> > I admit the work will become very much simpler if this pattern is allowed.
> 
> The guy who maintains much of sched.h suggested it.  ;-)

While its not the nicest thing its something that's on more than one
occasion there's an existing site in sched.h and there's on in key.h and
iirc there's another one that's relevant.

A nice solution would be to move a lot of things out of sched.h into
something like process.h, a header that deals with task groups and
processes.

But until that time, I see no problem with using this.
