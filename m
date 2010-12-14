Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0LNL1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 06:27:03 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44048 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845Ab0LNL1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 06:27:01 -0500
Date: Tue, 14 Dec 2010 16:56:55 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Avi Kiviti <avi@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
Message-ID: <20101214112655.GB3665@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20101213224434.7495edb2@annuminas.surriel.com>
 <20101213224657.7e141746@annuminas.surriel.com>
 <1292306896.7448.157.camel@marge.simson.net>
 <20101214102409.GA3665@linux.vnet.ibm.com>
 <1292324638.7436.29.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292324638.7436.29.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 12:03:58PM +0100, Mike Galbraith wrote:
> On Tue, 2010-12-14 at 15:54 +0530, Srivatsa Vaddagiri wrote:
> > On Tue, Dec 14, 2010 at 07:08:16AM +0100, Mike Galbraith wrote:
> 
> > > That part looks ok, except for the yield cross cpu bit.  Trying to yield
> > > a resource you don't have doesn't make much sense to me.
> > 
> > So another (crazy) idea is to move the "yieldee" task on another cpu over to 
> > yielding task's cpu, let it run till the end of yielding tasks slice and then
> > let it go back to the original cpu at the same vruntime position!
> 
> Yeah, pulling the intended recipient makes fine sense.  If he doesn't
> preempt you, you can try to swap vruntimes or whatever makes arithmetic
> sense and will help.  Dunno how you tell him how long he can keep the
> cpu though,

can't we adjust the new task's [prev_]sum_exec_runtime a bit so that it is 
preempted at the end of yielding task's timeslice?

> and him somehow going back home needs to be a plain old
> migration, no fancy restoration of ancient history vruntime.

What is the issue if it gets queued at the old vruntime (assuming fair stick is
still behind that)? Without that it will hurt fairness for the yieldee (and
perhaps of the overall VM in this case).

- vatsa
