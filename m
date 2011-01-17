Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab1AQVBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 16:01:24 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:63436 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1AQVBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 16:01:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=JtxpJGjHSagmb67H/KNsNhuAKrrAFywU394mmd5YNBGRqpCyNmUVNi4ZvfGK6wLvHL
         eRc8JWJ3doej/aP8V7Ar352uS9IhNhWgVHrvDZNZ8Xhh3SKIp2HXk9iLdQ+z8kUuCLuS
         TIJENkLZwnGil/eyX1SldfgeyD47Fcr7QBxUc=
Date: Mon, 17 Jan 2011 22:01:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Oleg Nesterov <oleg@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && task->ptrace_bps[]
Message-ID: <20110117210115.GC16856@nowhere>
References: <20101108145647.GA3426@redhat.com>
 <20110117203459.GA32700@redhat.com>
 <1295297576.30950.382.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295297576.30950.382.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 09:52:56PM +0100, Peter Zijlstra wrote:
> On Mon, 2011-01-17 at 21:34 +0100, Oleg Nesterov wrote:
> > On 11/08, Oleg Nesterov wrote:
> > >
> > > I am trying to understand the usage of hw-breakpoints in arch_ptrace().
> > > ptrace_set_debugreg() and related code looks obviously racy. Nothing
> > > protects us against flush_ptrace_hw_breakpoint() called by the dying
> > > tracee. Afaics we can leak perf_event or use the already freed memory
> > > or both.
> > >
> > > Am I missed something?
> > >
> > > Looking into the git history, I don't even know which patch should be
> > > blamed (if I am right), there were too many changes. I noticed that
> > > 2ebd4ffb6d0cb877787b1e42be8485820158857e "perf events: Split out task
> > > search into helper" moved the PF_EXITING check from find_get_context().
> > > This check coould help if sys_ptrace() races with SIGKILL, but it was
> > > racy anyway.
> > 
> > Ping.
> > 
> > Any idea how to fix this cleanly? May be we can reuse perf_event_mutex,
> > but this looks soooo ugly. And do_exit()->flush_ptrace_hw_breakpoint()
> > has the strange "FIXME:" comment which doesn't help me to understand
> > what can we do.
> > 
> > Probably the best fix is to change this code so that the tracer owns
> > ->ptrace_bps[], not the tracee. But this is not trivial, and needs a
> > lot of changes in ptrace code.
> 
> Wasn't this sorted by: 8882135bcd332f294df5455747ea43ba9e6f77ad?
> 
> Or is this purely related to the ptrace muck? in which case I guess
> Frederic is you man, I never looked at the hw_breakpoint stuff in
> general and the ptrace bits in particular.

Yeah sorry I lost track on this and left it unanswered in the middle.
Just lemme rewalk the thread and I'm back :)
