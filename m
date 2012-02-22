Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2BVOVQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 09:21:16 -0500
Received: from mail.openrapids.net ([64.15.138.104]:37967 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752736Ab2BVOVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 09:21:04 -0500
Date: Wed, 22 Feb 2012 09:20:56 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Jason Baron <jbaron@redhat.com>, a.p.zijlstra@chello.nl,
        davem@davemloft.net, ddaney.cavm@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 00/10] jump label: introduce very_[un]likely + cleanups
	+ docs
Message-ID: <20120222142056.GA20040@Krystal>
References: <20120222065016.GA16923@elte.hu> <4F44934B.2000808@zytor.com> <20120222072538.GA17291@elte.hu> <4F449ACF.3040807@zytor.com> <20120222074839.GA24890@elte.hu> <efc1cd8f-7114-460b-a704-a3e533d48d02@email.android.com> <20120222080659.GA25318@elte.hu> <1329916920.25686.79.camel@gandalf.stny.rr.com> <20120222133404.GA14085@elte.hu> <1329918881.25686.92.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329918881.25686.92.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:15:23 up 455 days, 19:18,  1 user,  load average: 0.08, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
[...]
> Actually, I was partly under the impression that we didn't care if it
> was in the fast path. Maybe we need three versions. Let me explain.
> 
> We have cases where we want it default disabled and the code called when
> enabled should be as out of line as possible. Tracing definitely falls
> in this pattern. But we could push a "unlikely(static_branch())" for
> such a case (or keep it as very_unlikely()).
> 
> Then we have cases where it is default enabled, where we can insert the
> code in the fast path. Or do we even care how the compiler places it?
> Because this leads us to the third use...
> 
> The third use is the case were we don't know the branch should be taken
> or not until boot. We don't want the compiler to optimize the paths at
> all. This example is for things like CPU features or types (as HPA
> explained the "if (very_unlikely(cpu_vendor_amd))". This is the category
> that we want to have an efficient system for the running hardware. We
> can't bias one way or the other at compile time because frankly, we
> don't know the answer until run time. This could also be used by modules
> that are drivers for several types of hardware, and it can dynamically
> change itself to suit the hardware it is driving.
> 
[...]
One possible naming that might be a good fit:

- read_always_likely()
- read_always_unlikely()
- read_always_branch()

I think it is important to convey both that it is expected to be always
read, pretty much never updated, and the bias, or absence of bias.

I also _like_ to have a relatively long name here, because the update
cost is so high that someone should really think before using this
facility. In my opinion, it's not "just" a stronger likely/unlikely.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
