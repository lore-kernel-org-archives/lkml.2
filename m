Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab0KHGNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 01:13:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:40509 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab0KHGNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 01:13:39 -0500
Date: Mon, 8 Nov 2010 07:13:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <kees.cook@canonical.com>, Siarhei Liakh <sliakh.lkml@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Security] proactive defense: using read-only memory, RO/NX
 modules
Message-ID: <20101108061324.GA30540@elte.hu>
References: <20101107193520.GO5327@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107193520.GO5327@outflux.net>
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


* Kees Cook <kees.cook@canonical.com> wrote:

> Hi,
> 
> While Dan Rosenberg is working to make things harder to locate potential targets 
> in the kernel through fixing kernel address leaks[1], I'd like to approach a 
> related proactive security measure: enforcing read-only memory for things that 
> would make good targets.

Nice! IMHO we need more of that. (If the readonly section gets big enough in 
practice we could perhaps even mark it large-page in the future. It could serve as 
an allocator to module code as well - that would probably be a speedup even for 
modules.)

> [...]
>
> The proposal is simple: as much of the kernel should be read-only as possible, 
> most especially function pointers and other execution control points, which are 
> the easiest target to exploit when an arbitrary kernel memory write becomes 
> available[2] to an attacker. There has been past work to "const"ify function 
> pointer tables, and this should continue. However, there are a few things that 
> need further attention:
> 
> - Modules need to be correctly marked RO/NX. This patch exists[3], but is
>   not in mainline. It needs to be in mainline.
[...]
>
> [3] http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=65187d24fa3ef60f691f847c792e8eaca7e19251

The reason the RO/NX patch from Siarhei Liakh is not upstream yet is rather mundane: 
it introduced regressions - it caused boot crashes on one of my testboxes.

But there is no fundamental reason why it shouldnt be upstream. We can push it 
upstream if the crashes are resolved and if it gets an Ack from Rusty or Linus for 
the module bits.

Siarhei, what's the status of your RO/NX changes?

Thanks,

	Ingo
