Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab0KZH0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 02:26:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48696 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab0KZH0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:26:53 -0500
Date: Fri, 26 Nov 2010 08:26:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jason Baron <jbaron@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <mhiramat@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH -tip v4 3/3] kprobes: Support delayed unoptimization
Message-ID: <20101126072621.GB19589@elte.hu>
References: <20101119100925.16882.34772.stgit@ltc236.sdl.hitachi.co.jp>
 <20101119100948.16882.24259.stgit@ltc236.sdl.hitachi.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101119100948.16882.24259.stgit@ltc236.sdl.hitachi.co.jp>
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


* Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> Unoptimization occurs when a probe is unregistered or disabled, and
> is heavy because it recovers instructions by using stop_machine().
> This patch delays unoptimization operations and unoptimize several
> probes at once by using text_poke_smp_batch().
> This can avoid unexpected system slowdown coming from stop_machine().
> 
> Changes in v2:
> - Use dynamic allocated buffers and params.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> 
>  arch/x86/include/asm/kprobes.h |    4 
>  arch/x86/kernel/kprobes.c      |   45 ++++
>  include/linux/kprobes.h        |    2 
>  kernel/kprobes.c               |  434 +++++++++++++++++++++++++++-------------
>  4 files changed, 344 insertions(+), 141 deletions(-)

Hm, this is a scary big patch with non-trivial effects - it should be broken up as 
much as possible, into successive, bisectable steps. The end result looks mostly 
fine - it's just this one huge step of a patch that is dangerous.

Thanks,

	Ingo
