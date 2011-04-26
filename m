Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757828Ab1DZHYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 03:24:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51547 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757557Ab1DZHYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 03:24:09 -0400
Date: Tue, 26 Apr 2011 09:23:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@linux.intel.com>
Cc: Vince Weaver <vweaver1@eecs.utk.edu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, torvalds@linux-foundation.org
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
Message-ID: <20110426072350.GA30630@elte.hu>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
 <1303407662-15564-2-git-send-email-acme@infradead.org>
 <20110422063429.GA16643@elte.hu>
 <20110422080604.GA22611@elte.hu>
 <alpine.DEB.2.00.1104251307010.12389@cl320.eecs.utk.edu>
 <20110425175444.GC28239@elte.hu>
 <alpine.DEB.2.00.1104251736220.12389@cl320.eecs.utk.edu>
 <20110425221258.GA21442@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110425221258.GA21442@tassilo.jf.intel.com>
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


* Andi Kleen <ak@linux.intel.com> wrote:

> > Now it has been disabled for unclear reasons.
> 
> Also unfortunately only partial. Previously you could at least write the MSR 
> from user space through /dev/cpu/*/msr, but now the kernel randomly rewrites 
> it if anyone else uses cache events.

Ugh, that's an unbelievable hack - if you hack an active PMU via writing to it 
via /dev/cpu/*/msr and it breaks you really get to keep the pieces. There's a 
reason why those devices are root only - it's as if you wrote to a filesystem 
that is already mounted!

If your user-space twiddling scripts go bad who knows what state the CPU gets 
into and you might be reporting bogus bugs. I think writing to those msrs 
directly should probably taint the kernel: i'll prepare a patch for that.

> It's very sad we have to go through this.

Not really, it took Peter 10 minutes to come up with an RFC patch to extend the 
cache events in a meaningful way - and that was actually more useful to users 
than all prior offcore patches combined. So the kernel already won from this 
episode.

We are not at all interested in hiding PMU functionality and keeping it 
unstructured, and just passing through some opaque raw ABI to user-space.

Thanks,

	Ingo
