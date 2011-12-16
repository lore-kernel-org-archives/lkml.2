Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644Ab1LPIzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 03:55:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:33572 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760670Ab1LPIy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 03:54:59 -0500
Date: Fri, 16 Dec 2011 09:53:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Beulich <JBeulich@suse.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] x86: Use -m-omit-leaf-frame-pointer to shrink text size
Message-ID: <20111216085259.GA2338@elte.hu>
References: <20111216081915.GA28288@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216081915.GA28288@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> [...]
> 
> The call-chains are still intact for quality backtraces and 
> for call-chain profiling (perf record -g), as the backtrace 
> walker can deduct the full backtrace from the RIP of a leaf 
> function and the parent chain.

Hm, noticed one complication while looking at annotated assembly 
code in perf top. Code doing function calls from within asm() is 
incorrectly marked 'leaf' by GCC:

ffffffff812b82d8 <arch_local_save_flags>:
ffffffff812b82d8:       ff 14 25 00 d9 c1 81    callq  *0xffffffff81c1d900
ffffffff812b82df:       c3                      retq   

So all the paravirt details will have to be fixed, so that GCC 
is able to see that there's a real function call done inside. 
Jeremy, Konrad?

Thanks,

	Ingo
