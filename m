Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab1FHJLW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:11:22 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58675 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754498Ab1FHJLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:11:21 -0400
Date: Wed, 8 Jun 2011 11:11:20 +0200
From: Andi Kleen <andi@firstfloor.org>
To: pageexec@freemail.hu
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Lutomirski <luto@mit.edu>,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Jesper Juhl <jj@chaosbits.net>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Jan Beulich <JBeulich@novell.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Mikael Pettersson <mikpe@it.uu.se>, Andi Kleen <andi@firstfloor.org>,
        Brian Gerst <brgerst@gmail.com>,
        Louis Rilling <Louis.Rilling@kerlabs.com>, Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v5 8/9] x86-64: Emulate legacy vsyscalls
Message-ID: <20110608091120.GI27166@one.firstfloor.org>
References: <20110608064857.GA6747@elte.hu> <4DEF3A93.8871.1BF773E2@pageexec.freemail.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEF3A93.8871.1BF773E2@pageexec.freemail.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There's clear evidence that any kind of exception in gettimeofday()/time()
is too slow. A few years ago gtod() had CPUID which lead to intercepts
with many hypervisors. This turned out to be a unacceptable slowdown,
so it was fixed,

A pagefault is a bit faster than a virtualization intercept, but not
much and therefore too slow.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
