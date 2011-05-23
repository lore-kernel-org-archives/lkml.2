Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1EWRBq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 13:01:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42955 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932123Ab1EWRBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 13:01:45 -0400
Date: Mon, 23 May 2011 19:01:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [bloat] Measuring header file bloat effects on kernel build
 performance: a more than 2x slowdown ...
Message-ID: <20110523170126.GA14407@elte.hu>
References: <20110520161210.81bbef3a.sfr@canb.auug.org.au>
 <BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
 <20110523090918.GA5474@elte.hu>
 <BANLkTim_pWfU0=ck8=F1kt_bwjtdGRDgdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTim_pWfU0=ck8=F1kt_bwjtdGRDgdQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Mon, May 23, 2011 at 2:09 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > I've attached a totally hacky patch that removes all the big #include's from
> > kernel/pid.c and includes all structure and API definitions explicitly.
> 
> Hmm.
> 
> A less hacky patch might be to split up "sched.h" into multiple
> smaller things and at least get *part* of the way.
> 

Yeah, absolutely - Peter already raised that a couple of days ago in a sched.h 
discussion so it's on the radar.

The hacky patch was really just a throw-away attempt to see where we stand - we 
only had vague impressions about the level of problems we have, now we know 
some numbers.

> A lot of things want "struct task_struct" (and in some cases thread_info, but 
> that's already split).
> 
> Much fewer care about the signal stuff.
> 
> And many things probably don't even need the task_struct definition, and 
> might be perfectly happy with just function calls rather than having intimate 
> knowledge of the structure layout and an inline function.

Yeah.

Thanks,

	Ingo
