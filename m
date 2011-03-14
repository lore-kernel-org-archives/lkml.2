Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab1CNJzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 05:55:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:32996 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754818Ab1CNJzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 05:55:45 -0400
Date: Mon, 14 Mar 2011 10:55:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jan Beulich <JBeulich@novell.com>
Cc: "H.J. Lu" <hjl.tools@gmail.com>, amodra@gmail.com, binutils@sourceware.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: PATCH: Add --size-check=[error|warning]
Message-ID: <20110314095534.GB18058@elte.hu>
References: <20110311165802.GA3508@intel.com>
 <4D7A64670200007800035F4C@vpn.id2.novell.com>
 <AANLkTikG8wa1Em0bEUddbYpYs2TzFFTDb95qWFJ3xSbv@mail.gmail.com>
 <4D7DE39302000078000362E6@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D7DE39302000078000362E6@vpn.id2.novell.com>
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


(H.J. Lu, did you drop me from the Cc: line?)

* Jan Beulich <JBeulich@novell.com> wrote:

> >> Please make it so that it'll be a warning by default, and an error
> >> upon programmer request. Otherwise, for the very purpose of
> > 
> > I disagree. It should be error by default since the input is bogus,
> > Otherwise, those assembly bugs, benign or not, may not get
> > fixed.
> > 
> >> bisection, it won't help much as you would have to override
> >> compiler/assembler flags during that process.
> >>
> > 
> > They can use a wrapper to pass --size-check=warning to
> > assembler.  I think it is a small price to pay for those mistakes.
> 
> "Small" being relative here - it could be dozens if not hundreds of
> people having to learn that this is necessary, many of them
> possibly rather unfamiliar with gas and its command line options.
>
> Also, using a wrapper gets further complicated by the fact that
> you may have to pass an extra -B to the compiler (not everyone
> has full control over the file system of all the machines used to
> do development), making sure this doesn't have any other
> unwanted side effects.

Correct. In reality if the kernel does not build or boot then most people just wont 
continue with the bisection. So this change actively degrades debuggability, for no 
good reason.

The thing is, it is absolutely, breath-takingy incompetent for the new binutils 
version to break the Linux kernel build for 4 years of Linux kernel history 
retroactively (130,000 commits), just to 'warn' about a size bug in a few debug 
symbols that has no functional effects whatsoever and which few people care about.

The correct solution is to turn it into a warning as me and others have suggested.

No argument was offered *why* the build must be aborted. A warning serves the 
purpose of informing the developer just as much - and does not inconvenience the 
tester.

Thanks,

	Ingo
