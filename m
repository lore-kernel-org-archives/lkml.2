Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1EVImr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 04:42:47 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40260 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab1EVIml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 04:42:41 -0400
Date: Sun, 22 May 2011 10:42:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [GIT PULL] Namespace file descriptors for 2.6.40
Message-ID: <20110522084224.GA12279@elte.hu>
References: <m11uzrvd26.fsf@fess.ebiederm.org>
 <BANLkTim4q5dK6nOb=pVKbk1c8b-Nh_hBfA@mail.gmail.com>
 <m1boyvpo9r.fsf@fess.ebiederm.org>
 <1306048393.4092.8.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306048393.4092.8.camel@mulgrave.site>
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


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> Traditionally, the arch trees tend to go a bit later because they wait to see 
> if there's any fallout from x86; [...]

Not really - most of the arch trees 'traditionally' went late even when the x86 
tree itself was monolithic and was itself sent late in the merge window (with 
the notable exception of the powerpc tree).

> [...] but this time, I think it looks OK, [...]

That's not really a surprise, there hasn't been a serious 'problem' with the 
x86 tree for a long time, roughly since we switched to the finegrained Git 
topical split-up maintenance model about two years ago.

[ That split-up also means that there is no 'x86 tree' anymore as such: if you 
  check lkml we send roughly 20-30 independent trees in the merge window and 
  have done that for the past ~10 kernel cycles. ]

In fact exactly *because* there's few problems with the x86 topic trees can we 
push them so soon: if problems were frequent then 1) we would not be able to be 
ready on time and 2) i suspect we'd be pulled in later in the window as well as 
a maintainer generally wants to pull low risk items first, high risk items 
last, to maximize the utilization of testing capacity.

I agree with Linus's notion in this thread though, a core kernel change should 
generally not worry about hooking up rare-arch system calls (concentrate on the 
architectures that get tested most) - those are better enabled gradually 
anyway.

Also, system call table conflicts are trivial to resolve. Merging in net-next 
to avoid such a conflict is like cracking a nut with a sledgehammer.

Thanks,

	Ingo
