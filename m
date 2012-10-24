Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965109Ab2JXTmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:42:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44254 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934460Ab2JXTm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:42:28 -0400
Date: Wed, 24 Oct 2012 12:41:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dave Jones <davej@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: Re: lots of suspicious RCU traces
Message-ID: <20121024194101.GG2465@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20121017034918.GA13295@redhat.com>
 <20121024164235.GA2467@swordfish>
 <20121024180608.GA22840@redhat.com>
 <20121024182111.GA2340@swordfish>
 <20121024185230.GB5025@redhat.com>
 <20121024191716.GB2340@swordfish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024191716.GB2340@swordfish>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12102419-5806-0000-0000-00001AFE2B28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 12:17:16PM -0700, Sergey Senozhatsky wrote:
> On (10/24/12 20:52), Oleg Nesterov wrote:
> > On 10/24, Sergey Senozhatsky wrote:
> > >
> > > On (10/24/12 20:06), Oleg Nesterov wrote:
> > > > On 10/24, Sergey Senozhatsky wrote:
> > > > >
> > > > > small question,
> > > > >
> > > > > ptrace_notify() and forward calls are able to both indirectly and directly call schedule(),
> > > > > /* direct call from ptrace_stop()*/,
> > > > > should, in this case, rcu_user_enter() be called before tracehook_report_syscall_exit(regs, step)
> > > > > and ptrace chain?
> > > >
> > > > Well, I don't really understand this magic... but why?
> > > >
> > >
> > > My understanding is (I may be wrong)
> > 
> > Oh, I bet I have much more chances to be wrong ;)
> > 
> > > that we can schedule() from ptrace chain to
> > 
> > I don't understand how ptrace chain differs from, say, audit_syscall_exit().
> > There is nothing special in ptrace_stop() in this respect.
> >
> 
> hm.
> 
> > > some arbitrary task, which will continue its execution from the point where RCU assumes
> > > CPU as not idle, while CPU in fact still in idle state -- no one said rcu_idle_exit()
> > 
> > confused... of course it would be wrong if syscall_trace_leave() is
> > called when CPU is considered idle,
> > 
> 
> sorry, I meant idle from RCU point of view:
> 
> int rcu_is_cpu_idle(void)
> {
>          return !rcu_dynticks_nesting;
> }

Hmmm...  This reproduces on UP builds, then?

> > > if so, does the same apply to in_user?
> > 
> > Not sure we understand each other. But I believe that ->in_user should be
> > already false when syscall_trace_leave() is called.
> 
> oh, my apology. I was very wrong about this.

Frederic, thoughts?

							Thanx, Paul

