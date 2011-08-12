Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175Ab1HLTxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:53:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45319 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab1HLTxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:53:15 -0400
Date: Fri, 12 Aug 2011 21:52:20 +0200
From: Ingo Molnar <mingo@elte.hu>
To: melwyn lobo <linux.melwyn@gmail.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: x86 memcpy performance
Message-ID: <20110812195220.GA29051@elte.hu>
References: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHSGOutFRcXWtn9d2zwLbkQG==kwPEUZh-ZigKS5AnMN6ty2-w@mail.gmail.com>
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


* melwyn lobo <linux.melwyn@gmail.com> wrote:

> Hi All,
> Our Video recorder application uses memcpy for every frame. About 2KB
> data every frame on Intel® Atom™ Z5xx processor.
> With default 2.6.35 kernel we got 19.6 fps. But it seems kernel
> implemented memcpy is suboptimal, because when we replaced
> with an optmized one (using ssse3, exact patches are currently being
> finalized) ew obtained 22fps a gain of 12.2 %.
> C0 residency also reduced from 75% to 67%. This means power benefits too.
> My questions:
> 1. Is kernel memcpy profiled for optimal performance.
> 2. Does the default kernel configuration for i386 include the best
> memcpy implementation (AMD 3DNOW, __builtin_memcpy .... etc)
> 
> Any suggestions, prior experience on this is welcome.

Sounds very interesting - it would be nice to see 'perf record' + 
'perf report' profiles done on that workload, before and after your 
patches.

The thing is, we obviously want to achieve those gains of 12.2% fps 
and while we probably do not want to switch the kernel's memcpy to 
SSE right now (the save/restore costs are significant), we could 
certainly try to optimize the specific codepath that your video 
playback path is hitting.

If it's some bulk memcpy in a key video driver then we could offer a 
bulk-optimized x86 memcpy variant which could be called from that 
driver - and that could use SSE3 as well.

So yes, if the speedup is real then i'm sure we can achieve that 
speedup - but exact profiles and measurements would have to be shown.

Thanks,

	Ingo
