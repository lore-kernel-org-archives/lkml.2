Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab1EQH44 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 03:56:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41138 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab1EQH4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 03:56:54 -0400
Date: Tue, 17 May 2011 09:56:35 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@MIT.EDU>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
Message-ID: <20110517075635.GA22093@elte.hu>
References: <cover.1305560561.git.luto@mit.edu>
 <20110516160943.GC25898@one.firstfloor.org>
 <alpine.LFD.2.02.1105161817120.3078@ionos>
 <20110516164939.GD25898@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516164939.GD25898@one.firstfloor.org>
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


* Andi Kleen <andi@firstfloor.org> wrote:

> > And unless you or someone else changes the primitive state of the
> > kernel, framepointers are going to stay simply because removing them
> > breaks profiling backtraces when the hit is inside vread().
> 
> This doesn't work anyways because the glibc stub code calling vgettimeofday 
> normally doesn't set up a frame pointer frame.

But we at least get a callchain back to that point.

Also, Thomas's point remains: you can whine about framepointers and you can try 
to slowly sabotage proper backtraces (nasty and sleazy tactic you are using 
there btw), or you can help out bring sane dwarf support to the kernel.

Thanks,

	Ingo
