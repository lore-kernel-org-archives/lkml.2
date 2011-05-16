Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047Ab1EPQZW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:25:22 -0400
Received: from www.linutronix.de ([62.245.132.108]:60812 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab1EPQZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:25:21 -0400
Date: Mon, 16 May 2011 18:25:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Andy Lutomirski <luto@MIT.EDU>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
In-Reply-To: <20110516160943.GC25898@one.firstfloor.org>
Message-ID: <alpine.LFD.2.02.1105161817120.3078@ionos>
References: <cover.1305560561.git.luto@mit.edu> <20110516160943.GC25898@one.firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 May 2011, Andi Kleen wrote:

> >  - Don't turn off frame pointers in vDSO code.
> 
> Why? Note frame pointers are costly on some CPUs, like Atom.

That's the least worry on ATOM.

> Also unlike the primitive state of the kernel the user space debuggers
> are usually advanced enough to support dwarf2 unwinding.

And unless you or someone else changes the primitive state of the
kernel, framepointers are going to stay simply because removing them
breaks profiling backtraces when the hit is inside vread().

Thanks,

	tglx
