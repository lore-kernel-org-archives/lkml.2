Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758963Ab0EELiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 07:38:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:47882 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463Ab0EELiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 07:38:12 -0400
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move
 perf on top of TP
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: mingo@elte.hu, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <4BE1406C.2000400@kernel.org>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
	 <1272994165.1642.203.camel@laptop>  <4BE0FB68.7080403@kernel.org>
	 <1273050400.1642.229.camel@laptop>  <4BE13B33.3030709@kernel.org>
	 <1273053073.1642.235.camel@laptop>  <4BE1406C.2000400@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 13:38:08 +0200
Message-ID: <1273059488.1642.245.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 11:54 +0200, Tejun Heo wrote:
> Hello,
> 
> On 05/05/2010 11:51 AM, Peter Zijlstra wrote:
> >> I was wondering the other way around - ie. the possibility to make
> >> perf optional and maybe even as a module which depends on TPs, which
> >> would be nicer than the current situation and make the code less
> >> cluttered too. 
> > 
> > I really really hate making perf rely on tracepoints.
> 
> Hmmm.... may I ask why? 

Because it will bloat the kernel for no reason. And I don't like the
endless indirections either.

Like said, I already really dislike x86 won't even build without
CONFIG_PERF_EVENTS, adding a hard requirement on TRACEEVENTS will only
make the whole thing even worse.

Sure, most distro configs will include both perf and tracepoints, but I
don't want to burden everybody who wants to use perf with the tracepoint
overhead.

As it stands I'd argue to simply drop this whole idea. The SCHED_EVENT()
thing doesn't look like its worth the obfuscation and I'm very much
opposed to making perf and sched_notifiers rely on tracepoints.

I don't see the few direct functions calls we have now as a big problem
and it sure as hell is a lot easier to read than the whole tracepoint
indirection mess.

If you care about the call overhead of the perf hooks, we can do the
same immediate value optimization to them as would be done to the
tracepoints.


