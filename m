Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934291Ab1CXUvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:51:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37249 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934262Ab1CXUvB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:51:01 -0400
Date: Thu, 24 Mar 2011 21:50:38 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Jack Steiner <steiner@sgi.com>, Jan Beulich <JBeulich@novell.com>,
        Borislav Petkov <bp@amd64.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Nick Piggin <npiggin@kernel.dk>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, tee@sgi.com,
        Nikanth Karthikesan <knikanth@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH RFC] x86: avoid atomic operation in test_and_set_bit_lock
 if possible
Message-ID: <20110324205038.GA2393@elte.hu>
References: <201103241026.01624.knikanth@suse.de>
 <20110324085647.GI30812@elte.hu>
 <20110324145221.GC31194@aftab>
 <4D8B83DA02000078000381DE@vpn.id2.novell.com>
 <20110324173020.GA26761@sgi.com>
 <20110324200010.GB7957@elte.hu>
 <m2sjucl0a6.fsf@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m2sjucl0a6.fsf@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andi Kleen <andi@firstfloor.org> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> >
> > One good way to see cache bounces is to run a misses/accesses ratio profile:
> >
> >    perf top -e cache-misses -e cache-references --count-filter 10
> >
> > Note the two events: this runs a 'weighted' profile, you'll see (LLC) 
> > cache-misses of a function relative to cache-references it does, a 
> > misses/references ratio in essence.
> 
> If anyone does this on a Nehalem please only use 2.6.39-rc*+ which
> includes the offcore patches. Anything before that will get you complete
> bogus numbers.

In that case the second example i quoted can be used:

  perf top -e L1-dcache-store-misses -e L1-dcache-stores --count-filter 10

Or:

  perf top -e L1-dcache-load-misses -e L1-dcache-loads --count-filter 10

Thanks,

	Ingo
