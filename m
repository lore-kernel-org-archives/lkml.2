Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759839Ab1D3U6d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:58:33 -0400
Received: from aspirin.dii.utk.edu ([160.36.0.81]:35574 "EHLO
	aspirin.dii.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab1D3U6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:58:32 -0400
Date: Sat, 30 Apr 2011 16:58:11 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: re-enable Nehalem raw Offcore-Events support
In-Reply-To: <alpine.DEB.2.00.1104292149480.9459@cl320.eecs.utk.edu>
Message-ID: <alpine.DEB.2.00.1104301653310.7288@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu> <20110429164227.GA25491@elte.hu> <alpine.DEB.2.00.1104292149480.9459@cl320.eecs.utk.edu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011, Vince Weaver wrote:

> >    https://lkml.org/lkml/2011/4/22/281
> > 
> 
> So here's my review:
>  NACK

so a slightly more useful review on slightly more sleep.

You are doing things backwards with your "generalization first" policy.

The right way to do things is enable raw event support first.

Then you can have users experiment with the feature.  Try various events 
using their favorite userspace utility (be it libpfm4, PAPI, perf).  This 
is easy, as choosing a new event is a simple matter of changing the 
command line option for your measurement.  Once a good event is found for 
generalization, *THEN* you add a generalized event that is well tested.

Your way is difficult.  Fine, Peter picks some arbitrary event he thinks 
work well.  I have to download a git kernel and reboot my machine (a 
process that takes an hour at best assuming I have root access).  Then if 
I want to try a new event, since RAW access is blocked, I have to patch 
the kernel, recompile, reboot.  So at least an hour between tests.

This assumes I can even do that.  My only Nehalem machine is at work and 
has only a fragile wireless network connection that requires manual 
intervention to get going.  so I *can't* review a change in general events 
with a remove access when it lives in the kernel, yet if it was in user 
space like it *should be* I could test away all day no problem.

See the problem here?  Going general event first makes it seriously 
inconvenient to test and so noone is going to do it for you because it's 
such a pain.  RAW first is the way to go.

Vince
