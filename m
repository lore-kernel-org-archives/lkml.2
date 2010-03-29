Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0C2Wxz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:53:55 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:38487 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab0C2Wxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:53:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CxpnfrzHHGoJrasEkJBl8sgPWKW6ETUdV6Z52sAOmwLTH0RHViuzSe65qhphllivu7
         VOlISlEGvqTMPIWW31FK919Nw0y9FgAsDcV/PheckjFpCZifHZPxndQK7F8lTw+2esbo
         wJpBrOJ0RBgSIJIcz5tI4UiWvj/5wWisnxADU=
Date: Tue, 30 Mar 2010 00:53:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] perf: Use hot regs with software sched
	switch/migrate events
Message-ID: <20100329225354.GD12254@nowhere>
References: <1269753066-17246-1-git-send-regression-fweisbec@gmail.com> <1269753066-17246-3-git-send-regression-fweisbec@gmail.com> <1269852599.12097.159.camel@laptop> <20100329174723.GB5101@nowhere> <1269885938.12097.367.camel@laptop> <20100329224352.GC12254@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329224352.GC12254@nowhere>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 12:43:54AM +0200, Frederic Weisbecker wrote:
> On Mon, Mar 29, 2010 at 08:05:38PM +0200, Peter Zijlstra wrote:
> > On Mon, 2010-03-29 at 19:47 +0200, Frederic Weisbecker wrote:
> > > 
> > > 
> > > I'm going to make a quick fix for perf_fetch_caller_regs() that
> > > passes task_pt_regs if exclude_kernel for perf/urgent,
> > > and I'll do the above cleanups/invasive fixes on perf/core.
> > > 
> > > 
> > ok, sounds sensible, thanks!
> 
> 
> Actually I have doubts about what should be the strict sense
> of exclude_kernel.
> 
> Does that mean we exclude any event that happened in the kernel?
> Or does that mean we exclude the part that happened in the kernel?
> 
> Depending on the case, we do either.
> 
> In perf_swevent_hrtimer(), we simply go back to task_pt_regs()
> if exclude_kernel.
> 
> But in other software events, we don't such fix, we actually
> filter out the event if it is not user_mode().
> 
> So, I'm a bit confused on what to do.
> I'm tempted to adopt the meaning from perf_swevent_hrtimer()
> for software events too, I'm not sure...


I think this is the right thing to do: jump back to user context
instead of filtering out (unless kernel thread).

Otherwise every software events, trace events included, are totally
pointless with exclude_kernel.

