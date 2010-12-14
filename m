Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab0LNMrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 07:47:39 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:38511 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1758911Ab0LNMri (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 07:47:38 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX196HiVlsud6ijpfcKgTtcBU9C4OnMvY9JL/NKcgAh
	A4l6NJbc98qztA
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: vatsa@linux.vnet.ibm.com
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20101214112655.GB3665@linux.vnet.ibm.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
	 <1292306896.7448.157.camel@marge.simson.net>
	 <20101214102409.GA3665@linux.vnet.ibm.com>
	 <1292324638.7436.29.camel@marge.simson.net>
	 <20101214112655.GB3665@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 14 Dec 2010 13:47:31 +0100
Message-Id: <1292330851.7436.98.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 16:56 +0530, Srivatsa Vaddagiri wrote:
> On Tue, Dec 14, 2010 at 12:03:58PM +0100, Mike Galbraith wrote:
> > On Tue, 2010-12-14 at 15:54 +0530, Srivatsa Vaddagiri wrote:
> > > On Tue, Dec 14, 2010 at 07:08:16AM +0100, Mike Galbraith wrote:
> > 
> > > > That part looks ok, except for the yield cross cpu bit.  Trying to yield
> > > > a resource you don't have doesn't make much sense to me.
> > > 
> > > So another (crazy) idea is to move the "yieldee" task on another cpu over to 
> > > yielding task's cpu, let it run till the end of yielding tasks slice and then
> > > let it go back to the original cpu at the same vruntime position!
> > 
> > Yeah, pulling the intended recipient makes fine sense.  If he doesn't
> > preempt you, you can try to swap vruntimes or whatever makes arithmetic
> > sense and will help.  Dunno how you tell him how long he can keep the
> > cpu though,
> 
> can't we adjust the new task's [prev_]sum_exec_runtime a bit so that it is 
> preempted at the end of yielding task's timeslice?

And dork up accounting.  Why?  Besides, it won't work because you have
no idea who may preempt whom, when, and for how long.

(Why do people keep talking about timeslice?  The only thing that exists
is lag that changes the instant anyone does anything of interest.)

> > and him somehow going back home needs to be a plain old
> > migration, no fancy restoration of ancient history vruntime.
> 
> What is the issue if it gets queued at the old vruntime (assuming fair stick is
> still behind that)? Without that it will hurt fairness for the yieldee (and
> perhaps of the overall VM in this case).

Who all are you placing this task in front of or behind based upon a
non-existent relationship?

Your recipient may well have been preempted, and is now further behind
than the completely irrelevant to the current situation stored vruntime
would indicate, so why would you want to move it rightward?  Certainly
not in the interest of fairness.

	-Mike

