Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593Ab0KHVnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 16:43:13 -0500
Received: from smtp.outflux.net ([198.145.64.163]:60124 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755565Ab0KHVnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 16:43:12 -0500
Date: Mon, 8 Nov 2010 13:42:28 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Siarhei Liakh <sliakh.lkml@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Security] proactive defense: using read-only memory, RO/NX
 modules
Message-ID: <20101108214228.GQ5876@outflux.net>
References: <20101107193520.GO5327@outflux.net>
 <20101108061324.GA30540@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108061324.GA30540@elte.hu>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Nov 08, 2010 at 07:13:24AM +0100, Ingo Molnar wrote:
> * Kees Cook <kees.cook@canonical.com> wrote:
> > While Dan Rosenberg is working to make things harder to locate potential targets 
> > in the kernel through fixing kernel address leaks[1], I'd like to approach a 
> > related proactive security measure: enforcing read-only memory for things that 
> > would make good targets.
> 
> Nice! IMHO we need more of that. (If the readonly section gets big enough in 
> practice we could perhaps even mark it large-page in the future. It could serve as 
> an allocator to module code as well - that would probably be a speedup even for 
> modules.)

Well, I can try to extract and send what PaX does, but it seems relatively
incompatible with the existing system that uses set_kernel_text_rw() and
friends.

> > - Modules need to be correctly marked RO/NX. This patch exists[3], but is
> >   not in mainline. It needs to be in mainline.
> [...]
> >
> > [3] http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=commitdiff;h=65187d24fa3ef60f691f847c792e8eaca7e19251
> 
> The reason the RO/NX patch from Siarhei Liakh is not upstream yet is rather mundane: 
> it introduced regressions - it caused boot crashes on one of my testboxes.
> 
> But there is no fundamental reason why it shouldnt be upstream. We can push it 
> upstream if the crashes are resolved and if it gets an Ack from Rusty or Linus for 
> the module bits.

Oh, well, yes, that's a good reason. :) Where was this covered? I'd like to
help get it reproduced and ironed out.

-Kees

-- 
Kees Cook
Ubuntu Security Team
