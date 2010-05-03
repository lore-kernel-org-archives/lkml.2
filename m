Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab0ECHiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 03:38:07 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38077 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab0ECHiB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 03:38:01 -0400
Date: Mon, 3 May 2010 09:37:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/5] perf inject + say no to __KERNEL__ only stuff
Message-ID: <20100503073749.GA1694@elte.hu>
References: <1272841142-26029-1-git-send-email-acme@infradead.org>
 <20100503062407.GB15241@elte.hu>
 <4BDE6D5A.6060407@zytor.com>
 <20100503065416.GD15241@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503065416.GD15241@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> 
> * H. Peter Anvin <hpa@zytor.com> wrote:
> 
> > On 05/02/2010 11:24 PM, Ingo Molnar wrote:
> > > 
> > > Pulled, thanks a lot!
> > > 
> > 
> > With this, core/hweight should work properly, I hope.
> 
> Ok, i merged that too - will let you know about any trouble.

It broke half of the non-x86 architectures. For example on Sparc defconfig:

In file included from /home/mingo/tip/include/asm-generic/bitops/hweight.h:4,
                 from /home/mingo/tip/arch/sparc/include/asm/bitops_32.h:103,
                 from /home/mingo/tip/arch/sparc/include/asm/bitops.h:6,
                 from /home/mingo/tip/include/linux/bitops.h:17,
                 from /home/mingo/tip/include/linux/kernel.h:15,
                 from /home/mingo/tip/include/linux/sched.h:54,
                 from /home/mingo/tip/arch/sparc/kernel/asm-offsets.c:13:
/home/mingo/tip/include/asm-generic/bitops/arch_hweight.h: In function '__arch_hweight32':
/home/mingo/tip/include/asm-generic/bitops/arch_hweight.h:8: error: implicit declaration of function '__sw_hweight32'
/home/mingo/tip/include/asm-generic/bitops/arch_hweight.h: In function '__arch_hweight16':
/home/mingo/tip/include/asm-generic/bitops/arch_hweight.h:13: error: implicit declaration of function '__sw_hweight16'
/home/mingo/tip/include/asm-generic/bitops/arch_hweight.h: In function '__arch_hweight8':
/home/mingo/tip/include/asm-generic/bitops/arch_hweight.h:18: error: implicit declaration of function '__sw_hweight8'
/home/mingo/tip/include/asm-generic/bitops/arch_hweight.h: In function '__arch_hweight64':
/home/mingo/tip/include/asm-generic/bitops/arch_hweight.h:23: error: implicit declaration of function '__sw_hweight64'

(the failure on other architectures looks similar)

Thanks,

	Ingo
