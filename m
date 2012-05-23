Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab2EWUUT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 16:20:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45799 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754166Ab2EWUUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 16:20:16 -0400
Date: Wed, 23 May 2012 22:20:10 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Josh Boyer <jwboyer@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] perf fix
Message-ID: <20120523202010.GA29094@gmail.com>
References: <20120523185054.GA17700@gmail.com>
 <CA+5PVA5m5U67mt8mXH_i_2Zu7OuVWiHfR82kBwqJm5ey4R26sg@mail.gmail.com>
 <20120523200451.GA19288@gmail.com>
 <CA+5PVA5gK0bPYbzMQxf3M+X=vuU0510Zechxa6UWcYJot_sP5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA5gK0bPYbzMQxf3M+X=vuU0510Zechxa6UWcYJot_sP5g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Josh Boyer <jwboyer@gmail.com> wrote:

> > This pull request you replied to is the v3.4 era fixes tree, 
> > with one remaining fix in it.
> 
> I see.  The forest of tip trees apparently confuses me still.  
> I'll figure it out eventually.

The topic tree layout for single-topic trees is pretty simple 
and straightforward - but the situation you met here was 
arguably a weird corner case:

 X/urgent are the fixes that go to Linus
 X/core   are the development patches for the next merge window

Where 'X' can be one of: perf, sched, timer, irq - the main 
subsystem trees we maintain. (x86 is a multi-topic tree, with 
intuitively named topic trees, such as x86/reboot, x86/asm or 
x86/mm.)

All of them are test-merged into tip:master - this is the one 
that you will typically use, the topic layout is for maintainers 
and for power-contributors/submaintaners who are sending Git 
pull requests to us.

at the beginning of a merge window (i.e. right now) there might 
be fixes pending in perf/urgent that did not make it to v3.4. 
Instead of merging them into perf/core I tend to send them to 
Linus as a standalone tree.

The rest of perf/core, once the initial one or two sets of 
commits get pulled by Linus, morphs into perf/urgent, fairly 
early in the merge window.

Thus there's a new perf/urgent and an empty perf/core, and the 
cycle starts again.

You met this cycle switch period to the day (the chance is only 
1:90 for that, consider yourself lucky ;-), which created the 
impression of a confusing fixes workflow.

Thanks,

	Ingo
