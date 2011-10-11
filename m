Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab1JKQ5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 12:57:23 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39796 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754949Ab1JKQ5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 12:57:22 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/pF+lZD3DpkwEWQ2ie24qMhtDvpbkbu3XD5aDeoY
	es1GICDaOOO0+l
Subject: Re: [patch] cpusets, cgroups: disallow attaching kthreadd
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <htejun@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <1318342087.14615.5.camel@twins>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	 <1316788392.6544.33.camel@marge.simson.net>
	 <1318224892.6161.45.camel@marge.simson.net>
	 <1318233815.6527.5.camel@marge.simson.net>
	 <20111010164339.GA8100@google.com>  <1318342087.14615.5.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 18:57:16 +0200
Message-ID: <1318352236.6194.22.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 16:08 +0200, Peter Zijlstra wrote:
> On Mon, 2011-10-10 at 09:43 -0700, Tejun Heo wrote:
> 
> > Yes, I think we need something like this.  wq workers were using
> > PF_THREAD_BOUND to prevent diddling from userland which made some
> > unhappy. 
> 
> But that can be properly fixed.
> 
> >  Maybe we need a flag to properly indicate "don't diddle with
> > this thread from userland"?  But, then, mainline kernel wouldn't need
> > the current PF_THREAD_BOUND at all.  Peter, Steven, what do you think?
> 
> Strict per-cpu affinity that is needed for correctness and disallows
> sched_setaffinity() is something entirely different from not being
> allowed to put something in a cgroup.

Agreed.  The proposed patchlet is purely a practical matter.

> As to not allowing to put in a cgroup thing, is there anything other
> than kthreadd for which we need to enforce that? So far I've mostly
> treated it like: root can do stupid things, this is one of them, don't
> do that then.

Yeah, that's the other side of the coin.  The only thing I can think of
justifying a response other than "well, gee, don't do that" is that Joe
User shouldn't need to know or care about kernel workqueue details.

I don't know of anything other than kthreadd where moving it here, or
over yonder matters one bit.

	-Mike

