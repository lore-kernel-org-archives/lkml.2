Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758688Ab1DYRZb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:25:31 -0400
Received: from leopard.mail.utk.edu ([160.36.0.85]:51485 "EHLO
	leopard.mail.utk.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758551Ab1DYRZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:25:29 -0400
X-Greylist: delayed 756 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Apr 2011 13:25:29 EDT
Date: Mon, 25 Apr 2011 13:12:15 -0400 (EDT)
From: Vince Weaver <vweaver1@eecs.utk.edu>
To: Ingo Molnar <mingo@elte.hu>
cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
In-Reply-To: <20110422080604.GA22611@elte.hu>
Message-ID: <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org> <1303407662-15564-2-git-send-email-acme@infradead.org> <20110422063429.GA16643@elte.hu> <20110422080604.GA22611@elte.hu>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


sorry for the late reply on this thread, it happened inconveniently over 
the long weekend.


On Fri, 22 Apr 2011, Ingo Molnar wrote:

> But this kind of usability is absolutely unacceptable - users should not
> be expected to type in magic, CPU and model specific incantations to get
> access to useful hardware functionality.

That's why people use libpfm4.  or PAPI.  And they do.

Current PAPI snapshots support offcore response on recent git kernels.
With full names, no hex values, thanks to libpfm4.

All the world is not perf.

> The proper solution is to expose useful offcore functionality via
> generalized events - that way users do not have to care which specific
> CPU model they are using, they can use the conceptual event and not some
> model specific quirky hexa number.

No no no no.

Blocking access to raw events is the wrong idea.  If anything, the whole 
"generic events" thing in the kernel should be ditched.  Wrong events are 
used at times (see AMD branch events a few releases back, now Nehalem 
cache events).  This all belongs in userspace, as was pointed out at the 
start.  The kernel has no business telling users which perf events are 
interesting, or limiting them!  What is this, windows?

If you do block access to any raw events, we're going to have to start 
recommending people ditch perf_events and start patching the kernel with 
perfctr again.  We already do for P4/netburst users, as Pentium 4 support 
is currently hosed due to NMI event conflicts.

Also with perfctr it's much easier to get low-latency access to the 
counters.  See:
  http://web.eecs.utk.edu/~vweaver1/projects/papi-cost/

Vince
