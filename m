Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760589Ab2D0PaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:30:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760484Ab2D0PaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:30:07 -0400
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 6/6][RFC] kprobes: Allow probe on ftrace reserved text (but move it)
References: <20120426022922.683707508@goodmis.org>
	<20120426023708.577576476@goodmis.org> <4F991F99.8050301@hitachi.com>
	<1335535294.28106.206.camel@gandalf.stny.rr.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Fri, 27 Apr 2012 11:29:56 -0400
In-Reply-To: <1335535294.28106.206.camel@gandalf.stny.rr.com> (Steven Rostedt's message of "Fri, 27 Apr 2012 10:01:34 -0400")
Message-ID: <y0mk411mbuz.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:

> [...]
> What do you think of this patch?
> [...]
> +	/*
> +	 * If the address is located on a ftrace nop, set the
> +	 * breakpoint to the following instruction.
> +	 */
> +	ftrace_addr = ftrace_location((unsigned long)addr);
> +	if (unlikely(ftrace_addr)) {
> +		addr = (kprobe_opcode_t *)(ftrace_addr + MCOUNT_INSN_SIZE);
> +		p->flags |= KPROBE_FLAG_MOVED;
> +	}
> [...]

I suspect Masami intended that this flag is later used during int3
processing to subtract MCOUNT_INSN_SIZE back out from the pt_regs->ip
during kprobe_handler() if this flag was set.

- FChE
