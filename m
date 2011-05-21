Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396Ab1EUTIg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 15:08:36 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48298 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953Ab1EUTIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 15:08:34 -0400
Date: Sat, 21 May 2011 12:08:30 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        Valdis.Kletnieks@vt.edu, a.p.zijlstra@chello.nl
Subject: Re: [GIT PULL rcu/next] fixes and breakup of
 memory-barrier-decrease patch
Message-ID: <20110521190830.GH2271@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110521140613.GA13062@linux.vnet.ibm.com>
 <20110521142844.GA29813@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110521142844.GA29813@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 21, 2011 at 04:28:44PM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > Hello, Ingo,
> > 
> > This pull requests covers some RCU bug fixes and one patch rework.
> > 
> > The first group breaks up the infamous now-reverted (but ultimately
> > vindicated) "Decrease memory-barrier usage based on semi-formal proof"
> > commit into five commits.  These five commits immediately follow the
> > revert, and the diff across all six of these commits is empty, so that
> > the effect of the five commits is to revert the revert.
> 
> But ... the regression that was observed with that commit needs to be fixed 
> first, or not? In what way was the barrier commit vindicated?

>From what I can see, the hang was fixed by Frederic's patch at
https://lkml.org/lkml/2011/5/19/753.  I was interpreting that as
vindication, perhaps ill-advisedly.

Yinghai said that he was still seeing a delay, adn that he was seeing
it even with the "Decrease memory-barrier usage based on semi-formal
proof" reverted: https://lkml.org/lkml/2011/5/20/427.  This hang seems
to happen when he uses gcc 4.5.0, but not when using gcc 4.5.1, assuming
I understood his sequence of emails.  So I was interpreting that as
meaning that the delay was unlikely to be caused by that commit, probably
by one of the later commits.

I clearly need to figure out what is causing this delay.  I asked Yinghai
to apply c7a378603 (Remove waitqueue usage for cpu, node, and boost kthreads)
from Peter Zijlstra because the long delays that Yinghai is seeing
(93 seconds for memory_dev_init() rather than 3 or 4 seconds) might be
due to my less-efficient method of awakening the RCU kthreads, so that
Peter's approache might help.

If that doesn't speed things up for Yinghai, then I will work out some
tracing to help localize the slowdown that he is seeing.

Of course, if you would rather that I get to the bottom of this before
pulling, fair enough!

							Thanx, Paul
