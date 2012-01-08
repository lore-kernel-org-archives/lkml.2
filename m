Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab2AHIvG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 03:51:06 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43994 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab2AHIvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 03:51:04 -0500
Date: Sun, 8 Jan 2012 09:48:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 0/6 v3] [GIT PULL] x86: Workaround for NMI iret woes
Message-ID: <20120108084844.GA7168@elte.hu>
References: <20111222031357.120841629@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222031357.120841629@goodmis.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Ingo,
> 
> I updated the patches to reflect your comments and ran them through
> all my tests again. Below is the full diff between v2 and v3.
> 
> I renamed nmi_preprocess() and nmi_postprocess() to
> nmi_nesting_preprocess() and nmi_nesting_postprocess() to at least
> note that this has to do with nmi nesting. I also commented the
> fact that i386 may loop back to the preprocess.
> 
> I had to move the debug_usage functions to debugreg.h, because
> smp.h includes processor.h where making the inc/dec inline
> caused include header issues.
> 
> -- Steve
> 
> Please pull the latest tip/x86/core-3 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> tip/x86/core-3
> 
> Head SHA1: 42181186ad4db986fcaa40ca95c6e407e9e79372
> 
> 
> Linus Torvalds (1):
>       x86: Do not schedule while still in NMI context
> 
> Steven Rostedt (5):
>       x86: Document the NMI handler about not using paranoid_exit
>       x86: Add workaround to NMI iret woes
>       x86: Keep current stack in NMI breakpoints
>       x86: Allow NMIs to hit breakpoints in i386
>       x86: Add counter when debug stack is used with interrupts enabled
> 
> ----
>  arch/x86/include/asm/debugreg.h |   22 ++++
>  arch/x86/include/asm/desc.h     |   12 ++
>  arch/x86/kernel/cpu/common.c    |   24 +++++
>  arch/x86/kernel/entry_64.S      |  218 +++++++++++++++++++++++++++++++++------
>  arch/x86/kernel/head_64.S       |    4 +
>  arch/x86/kernel/nmi.c           |  102 ++++++++++++++++++
>  arch/x86/kernel/traps.c         |   20 ++++
>  7 files changed, 369 insertions(+), 33 deletions(-)

Pulled, thanks a lot Steve! I've ran 500 randconfig iterations 
and these bits seem fine.

Thanks,

	Ingo
