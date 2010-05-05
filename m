Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab0EESQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:16:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:32838 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab0EESQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:16:06 -0400
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move
 perf on top of TP
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100505165532.GC14323@elte.hu>
References: <1272976724-14312-1-git-send-email-tj@kernel.org>
	 <1272994165.1642.203.camel@laptop> <4BE0FB68.7080403@kernel.org>
	 <1273050400.1642.229.camel@laptop> <4BE13B33.3030709@kernel.org>
	 <1273053073.1642.235.camel@laptop> <4BE1406C.2000400@kernel.org>
	 <1273059488.1642.245.camel@laptop> <4BE1648B.1080709@kernel.org>
	 <20100505165532.GC14323@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 05 May 2010 20:12:53 +0200
Message-ID: <1273083173.1642.250.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-05 at 18:55 +0200, Ingo Molnar wrote:
> * Tejun Heo <tj@kernel.org> wrote:
> 
> > Hello,
> > 
> > On 05/05/2010 01:38 PM, Peter Zijlstra wrote:
> > > As it stands I'd argue to simply drop this whole idea. The SCHED_EVENT()
> > > thing doesn't look like its worth the obfuscation and I'm very much
> > > opposed to making perf and sched_notifiers rely on tracepoints.
> > 
> > Hmmm... okay.  Well, this thing is born out of Ingo's suggestion that for 
> > more sched notifiers to be added notification mechanisms need to be 
> > consolidated.  As long as I can get those two notifiers needed for cmwq, 
> > it's okay with me.  Ingo, what do you think?
> 
> I'd much rather see the *_EVENT() APIs used - but enhanced to address Peter's 
> objections. One change would be to add a DEFINE_EVENT_ABI() variant, which 
> would be called via trace_abi_*() calls. That way we always know they are 
> 'hardwired' events in the extreme.
> 
> That then would allow the software events to be consolidated.
> 
> Peter?

Well, I'd much rather just see a direct call in the code than having to
reverse engineer wth hangs onto that _EVENT() junk.

Also, we don't need ABI muck for this.

