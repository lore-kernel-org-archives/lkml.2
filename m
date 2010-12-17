Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755353Ab0LQTv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:51:56 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:55609 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754497Ab0LQTvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:51:54 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19RVndpYlRRrvd9bdHcLeZUlXFD4/xa93yyMyw1yJ
	5GW/MsGD3FLqDr
Subject: Re: [RFC -v2 PATCH 2/3] sched: add yield_to function
From: Mike Galbraith <efault@gmx.de>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <4D0B7D24.5060207@redhat.com>
References: <20101213224434.7495edb2@annuminas.surriel.com>
	 <20101213224657.7e141746@annuminas.surriel.com>
	 <1292306896.7448.157.camel@marge.simson.net> <4D0A6D34.6070806@redhat.com>
	 <1292569018.7772.75.camel@marge.simson.net>  <4D0B7D24.5060207@redhat.com>
Content-Type: text/plain
Date: Fri, 17 Dec 2010 20:51:49 +0100
Message-Id: <1292615509.7381.81.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 17:09 +0200, Avi Kivity wrote:
> On 12/17/2010 08:56 AM, Mike Galbraith wrote:
> > >  Surely that makes it a reasonable idea to call yield, and
> > >  get one of the other tasks on the current CPU running for
> > >  a bit?
> >
> > There's nothing wrong with trying to give up the cpu.  It's the concept
> > of a cross cpu yield_to() that I find mighty strange.
> 
> What's so strange about it?  From a high level there are N runnable 
> tasks contending for M cpus.  If task X really needs task Y to run, what 
> does it matter if task Y last ran on the same cpu as task X or not?

Task X wants control of when runnable task Y gets the cpu.  Task X
clearly wants to be the scheduler.  This isn't about _yielding_ diddly
spit, it's about individual tasks wanting to make scheduling decisions,
so calling it a yield is high grade horse-pookey.  You're trying to give
the scheduler a hint, the stronger that hint, the happier you'll be.

I can see the problem, and I'm not trying to be Mr. Negative here, I'm
only trying to point out problems I see with what's been proposed.  

If the yielding task had a concrete fee he could pay, that would be
fine, but he does not.

If he did have something, how often do you think it should be possible
for task X to bribe the scheduler into selecting task Y?  Will his
pockets be deep enough to actually solve the problem?  Once he's
yielded, he's out of the picture for a while if he really gave anything
up.  What happens to donated entitlement when the recipient goes to
sleep?  If you try to give it back, what happens if the donor exited?
Where did the entitlement come from if task A running alone on cpu A
tosses some entitlement over the fence to his pal task B on cpu B.. and
keeps on trucking on cpu A?  Where does that leave task C, B's
competition?

> Do I correctly read between the lines that CFS maintains complete 
> fairness only on a cpu, but not globally?

Nothing between the lines about it.  There are N individual engines,
coupled via load balancing.

	-Mike

