Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0CVNFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 09:05:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48431 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab0CVNFs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 09:05:48 -0400
Date: Mon, 22 Mar 2010 14:05:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, yinghai@kernel.org,
       benh@kernel.crashing.org, tglx@linutronix.de, hpa@zytor.com,
       jbarnes@virtuousgeek.org, ebiederm@xmission.com,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.c
Message-ID: <20100322130530.GC12475@elte.hu>
References: <4BA6EA62.1030603@kernel.org>
 <20100321.210023.209981130.davem@davemloft.net>
 <4BA6F1F6.3070102@kernel.org>
 <20100321.213350.176660494.davem@davemloft.net>
 <20100322092809.GA20607@elte.hu>
 <20100322113026.GA11526@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100322113026.GA11526@brick.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> And I don't see the point of moving the x86 e820 stuff into the kernel 
> directory. [...]

I dont see the point of that either - that is a mistake. e820 is an x86 bios 
call and we shouldnt name a generic mechanism after that. e820 is absolutely 
messy and has no place anywhere beyond x86.

The main technical argument i see is 'early_res versus LMB'. Even there i'd 
prefer LMB from a technical quality POV.

> Well I personally don't mind if x86 uses early_res or whatever other code in 
> arch/x86 to handle the problems that arise from deficient firmware.  I just 
> don't see any value in converting powerpc or sparc64 over to using ~2000 
> lines of early_res/fw_memmap code where the existing ~500 lines of lmb code 
> is working just fine.

Lets put it this way then: do you see any point in PowerPC making use of a 10+ 
million lines of code kernel that is being mainly (80%+) financed, developed, 
tested and deployed by people who care about x86 mostly?

If yes then it seems like a pretty damn good deal to me for PowerPC to go 
beyond its narrow short-term self-interest and work towards generalizations 
more actively, and even consider touching its 500 lines of lmb code ...

I dont know how many times we've accomodated for non-x86 architectures in 
various pieces of kernel code.

Obviously if there's bloat affecting PowerPC then that can be addressed via 
technical measures. But we really shouldnt leave the slightly incompatible 
early allocators in place. (we shouldnt have let them get created in the first 
place, but that is water down the bridge.)

Thanks,

	Ingo
