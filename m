Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933981Ab1D2WQ4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:16:56 -0400
Received: from mail.skyhub.de ([78.46.96.112]:46501 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933950Ab1D2WQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:16:47 -0400
Date: Sat, 30 Apr 2011 00:16:42 +0200
From: Borislav Petkov <bp@alien8.de>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Ingo Molnar <mingo@elte.hu>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: re-enable Nehalem raw Offcore-Events support
Message-ID: <20110429221642.GA10751@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Vince Weaver <vweaver1@eecs.utk.edu>, Ingo Molnar <mingo@elte.hu>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Stephane Eranian <eranian@gmail.com>,
	Andi Kleen <ak@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <alpine.DEB.2.00.1104291056220.22212@cl320.eecs.utk.edu>
 <20110429164227.GA25491@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20110429164227.GA25491@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 06:42:27PM +0200, Ingo Molnar wrote:

[..]

> Basically without proper generalization people get sloppy and go the fast path 
> and export very low level, opaque, unstructured PMU interfaces to user-space 
> and repeat the Oprofile and perfmon tooling mistakes again and again.
> 
>  "Thinking is hard, lets go shopping^W exporting raw ABIs."
> 
> So the perf events policy has always been that while we tolerate raw events 
> (there's nothing bad with offering them once generic events have crystallized 
> out), we only accept them if the *useful* events are first abstracted and 
> generalized out.
> 
> We put structure, proper abstractions and easy tooling *ahead* of the interests 
> of a small group of people who'd rather prefer a lowlevel, opaque hardware 
> channel so that they do not have to *think* about generalization and also 
> perhaps so they do not have to share their selection of events and analysis 
> methods with others ...

Yep, absolutely. Excuse my french but even kernel developers who
can understand perf code don't need to know f*cking magical hex
constants in order to trace a little. And yes, we talk about perf
and say how cool it is but users want to see more examples like on
http://perf.wiki.kernel.org - they want to get to use it first _and_
_then_ maybe look at code/more involved scenarios. Other kernel
developers don't give a rat's ass about the possibility for shooting
themselves in the foot - they want to use this thing without reading
code and CPU documentation for a day first. And I believe I speak for
the majority when I say so.

We're always bitching about Linux usability and now when it comes down
to yet another case where this can be done right for a change, and perf
people are trying to do something productive, you come waving hands
loudly at Linus with revert requests instead of helping. This is as
productive as trying to shoot yourself in the foot.

-- 
Regards/Gruss,
    Boris.
