Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767Ab1EPVxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 17:53:16 -0400
Received: from www.linutronix.de ([62.245.132.108]:58009 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756555Ab1EPVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 17:53:11 -0400
Date: Mon, 16 May 2011 23:53:04 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: Andrew Lutomirski <luto@mit.edu>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
In-Reply-To: <m2fwoeo0pf.fsf@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1105162345110.3078@ionos>
References: <cover.1305560561.git.luto@mit.edu> <20110516160943.GC25898@one.firstfloor.org> <alpine.LFD.2.02.1105161817120.3078@ionos> <20110516164939.GD25898@one.firstfloor.org> <BANLkTintkmnkN3kW06oa+TjT7W0Q1yQQGA@mail.gmail.com>
 <m2fwoeo0pf.fsf@firstfloor.org>
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
> Andrew Lutomirski <luto@mit.edu> writes:
> > Longer term, it would be nice to mark the vsyscall page NX.  That
> > involves a few things:
> 
> Why NX? What would make sense is to call the VDSO from it.
> The problem is that the vDSO is randomized and there's no good memory
> location to store the pointer to it.
> 
> The real reason for all this dance is to have some less non randomized
> code around. What I implemented back then was instead code to patch out
> the SYSCALL in there if not needed to lower the attack surface (not sure
> if that still works though, but that was the idea). For most cases
> (TSC/HPET read) it's not needed.
> 
> Checking: someone removed the code meanwhile.

For a damned good reason.
 
> > And we won't have a
> > syscall instruction sitting at a predictable address.
> 
> The easy way to fix this is to just re-add the patching.

If you can address _all_ reasons why it was removed then we might
revisit that issue, but that's going to be an interesting patch.

Thanks,

	tglx
