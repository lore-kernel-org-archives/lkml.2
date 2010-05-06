Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0EFHEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 03:04:36 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42063 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026Ab0EFHEe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 03:04:34 -0400
Subject: Re: [RFC PATCHSET] sched,perf: unify tracers in sched and move
 perf on top of TP
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tejun Heo <tj@kernel.org>, efault@gmx.de, avi@redhat.com, paulus@samba.org,
       acme@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100506063116.GE1172@elte.hu>
References: <1272994165.1642.203.camel@laptop> <4BE0FB68.7080403@kernel.org>
	 <1273050400.1642.229.camel@laptop> <4BE13B33.3030709@kernel.org>
	 <1273053073.1642.235.camel@laptop> <4BE1406C.2000400@kernel.org>
	 <1273059488.1642.245.camel@laptop> <4BE1648B.1080709@kernel.org>
	 <20100505165532.GC14323@elte.hu> <1273083173.1642.250.camel@laptop>
	 <20100506063116.GE1172@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 06 May 2010 09:04:24 +0200
Message-ID: <1273129464.5605.228.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 08:31 +0200, Ingo Molnar wrote:
> * Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Well, I'd much rather just see a direct call in the code than having to 
> > reverse engineer wth hangs onto that _EVENT() junk.
> 
> Direct calls into code were fine 10 years ago, but since then we got:
> 
>  - preempt notifiers

Are per task an no good for driving perf.

>  - sw events
>  - tracepoints

Are unrelated to the core perf scheduler calls.

> Which add up to a lot more than just a plain call into code.
> 
> Also, with the jump-optimizations we will have tracepoints that are _cheaper_ 
> than a plain function call.

Which can just as easily be used on the core perf hooks.

> > Also, we don't need ABI muck for this.
> 
> we already have an ABIs in place here - this would just properly unify and 
> enumerate it.

I'm not getting it, this is about in-kernel stuff, there are _NO_ in
kernel ABIs.
