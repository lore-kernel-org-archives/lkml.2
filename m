Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133Ab1EFGOS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 02:14:18 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56791 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839Ab1EFGOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 02:14:17 -0400
Date: Fri, 6 May 2011 08:13:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: LKML <linux-kernel@vger.kernel.org>, LPPC <linuxppc-dev@lists.ozlabs.org>,
        Prasad <prasad@linux.vnet.ibm.com>, "v2.6.33.." <stable@kernel.org>
Subject: Re: [PATCH] powerpc, hw_breakpoints: Fix CONFIG_HAVE_HW_BREAKPOINT
 off-case in ptrace_set_debugreg
Message-ID: <20110506061353.GA21742@elte.hu>
References: <1304639598-4707-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304639598-4707-1-git-send-email-fweisbec@gmail.com>
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> We make use of ptrace_get_breakpoints() / ptrace_put_breakpoints()
> to protect ptrace_set_debugreg() even if CONFIG_HAVE_HW_BREAKPOINT
> if off. However in this case, these APIs are not implemented.
> 
> To fix this, push the protection down inside the relevant ifdef.
> Best would be to export the code inside CONFIG_HAVE_HW_BREAKPOINT
> into a standalone function to cleanup the ifdefury there and call
> the breakpoint ref API inside. But as it is more invasive, this
> should be rather made in an -rc1.
> 
> Fixes:
> 
> arch/powerpc/kernel/ptrace.c:1594: error: implicit declaration of function 'ptrace_get_breakpoints'
> make[2]: *** [arch/powerpc/kernel/ptrace.o] Error 1
> make[1]: *** [arch/powerpc/kernel] Error 2
> make: *** [sub-make] Error 2

Thanks.

I'll need a PowerPC ack for this. Note: it's dependent on hw-breakpoint fixes 
in tip:perf/urgent so the commit will want to go there too.

Thanks,

	Ingo
