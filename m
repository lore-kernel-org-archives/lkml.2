Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab2BJGLB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 01:11:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37569 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677Ab2BJGLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 01:11:00 -0500
Date: Fri, 10 Feb 2012 07:10:46 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Ahern <dsahern@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org
Subject: Re: Hmm.. WARN_ON_ONCE(cpuc->enabled)
Message-ID: <20120210061046.GA21805@elte.hu>
References: <CA+55aFyXyfYd+_NJ8kLYz-bk7Qt0SLHu4t7RN1PCQptt75RGXQ@mail.gmail.com>
 <4F346111.1040506@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F346111.1040506@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* David Ahern <dsahern@gmail.com> wrote:

> On 02/09/2012 04:46 PM, Linus Torvalds wrote:
> > Ok, so I get the appended on my Core i5 when I did a "perf record -f
> > -e cycles:pp make -j" on the kernel build.
> > 
> > What's up, guys? I haven't tried that particular perf run in a while,
> > so it might have been going on for quite some time.
> 
> Perhaps already fixed by
> https://lkml.org/lkml/2012/2/4/42
> 
> It's not in your tree; but in tip/urgent.

That patch only fixed the symptom - there was an underlying bug 
that is fixed in perf/urgent as well, via:

  f39d47ff819e: perf: Fix double start/stop in x86_pmu_start()

I committed it two days ago - so it narrowly missed -rc3. Note 
that no actual misbehavior is known to be caused by this bug, 
beyond the annoying WARN_ONCE() messages and a potential slight 
mis-measurement.

I'll send those fixes to Linus in a couple of hours.

Thanks,

	Ingo
