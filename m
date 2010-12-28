Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab0L1Fs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 00:48:28 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:43606 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1750739Ab0L1Fs1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 00:48:27 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/C9Xo83KLCBV0UDy38Sn+NcGDrsPnaA2lKa8Ykg7
	V41NEGk9o3kUuj
Subject: Re: [PATCH] sched: Buggy comparison in check_preempt_tick
From: Mike Galbraith <efault@gmx.de>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Ranjit Manomohan <ranjitm@google.com>
In-Reply-To: <1293348184.6942.72.camel@marge.simson.net>
References: <1293236813-31550-1-git-send-email-venki@google.com>
	 <1293263418.6896.54.camel@marge.simson.net>
	 <AANLkTintN2e-NHB=USQ4RSi1LMrC8TxB7BB0MNpPscSB@mail.gmail.com>
	 <1293348184.6942.72.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 06:48:13 +0100
Message-ID: <1293515293.6930.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-26 at 08:23 +0100, Mike Galbraith wrote:

> But anyway..
> 
> echo NO_WAKEUP_PREEMPT > sched_features
> echo NO_TESTME > sched_features
> two hogs running on isolcpu 3, pid 6890 at nice -2
> 
> while sleep 1; do  grep 'pert.*6890' /proc/sched_debug; done
> 
> runnable tasks:
>             task   PID         tree-key  switches  prio
> -------------------------------------------------------
> R           pert  6890     50201.071851      7453   118
> R           pert  6890     50596.171290      7513   118  +60
> R           pert  6890     50991.265264      7572   118  +59
> R           pert  6890     51383.781965      7631   118  +59
>             pert  6890     51781.463129      7691   118  +60
> 
> echo TESTME > sched_features
>             pert  6890    126881.306733     18977   118
> R           pert  6890    127273.825719     19036   118  +59
> R           pert  6890    127668.928218     19095   118  +59
> R           pert  6890    128064.031372     19154   118  +59
> R           pert  6890    128459.134339     19213   118  +59
> 
> ...with a compute load, the thing should be a noop, and appears to be so
> (with busted compare fixed anyway;).  You have to be well overloaded for
> buddies to kick in these days, so it's probably pretty hard to get
> enough spread for the thing to fire.

I did a bit more testing yesterday with wakeup loads.  There's enough
spread for the test to nudge things a few [0..4] times per second/core.

I'd either fix the comparison, and let it keep on nudging once in a
while, or whack the whole thing.

	-Mike

