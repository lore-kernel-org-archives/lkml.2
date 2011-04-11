Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755969Ab1DKVCk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 17:02:40 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48440 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689Ab1DKVCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 17:02:38 -0400
Date: Mon, 11 Apr 2011 14:02:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Michal Marek <mmarek@suse.cz>,
        Jan Beulich <JBeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sam Ravnborg <sam@ravnborg.org>, David Howells <dhowells@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 4/5] RCU: Add TASK_RCU_OFFSET
Message-ID: <20110411210223.GB2226@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4D9CDACB.9050705@linux.intel.com>
 <20110407003041.GD2265@linux.vnet.ibm.com>
 <4D9D507F.2040006@cn.fujitsu.com>
 <20110407154737.GF2262@linux.vnet.ibm.com>
 <20110407162600.GA24227@linux.vnet.ibm.com>
 <4D9E6438.5030206@cn.fujitsu.com>
 <20110408051359.GA2318@linux.vnet.ibm.com>
 <4DA2709E.50902@cn.fujitsu.com>
 <20110411051241.GB18415@linux.vnet.ibm.com>
 <4DA2BC4E.4010000@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA2BC4E.4010000@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 04:31:10PM +0800, Lai Jiangshan wrote:
> On 04/11/2011 01:12 PM, Paul E. McKenney wrote:
> 
> > -static inline struct task_struct *next_thread(const struct task_struct *p)
> > -{
> > -	return list_entry_rcu(p->thread_group.next,
> > -			      struct task_struct, thread_group);
> > -}
> > +/* Avoid #include hell for inlining rcu_read_lock(). */
> > +#define next_thread(p) \
> > +	list_entry_rcu((p)->thread_group.next, struct task_struct, thread_group)
> >  
> 
> 
> It is strange for me.
> The user of the API "next_thread(p)" must has two headers included, sched.h and rculist.h
> 
> I know this is a very popular pattern of user space code, is it OK for kernel?
> I think a file(even a header file) uses API(Marco), it should includes the the corresponding
> headers, it reduces surprises(example, the name of "next_thread()" has no "rcu",
> it is not expected that rcuxxxx.h is required).
> 
> I admit the work will become very much simpler if this pattern is allowed.

The guy who maintains much of sched.h suggested it.  ;-)

							Thanx, Paul

> man fcntl:
>        #include <unistd.h>
>        #include <fcntl.h>
> 
>        int fcntl(int fd, int cmd, ... /* arg */ );
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
