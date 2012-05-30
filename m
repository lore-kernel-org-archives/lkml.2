Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab2E3HWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:22:32 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54904 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756943Ab2E3HWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:22:30 -0400
Date: Wed, 30 May 2012 12:52:02 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC PATCH -tip  8/9] kprobes: introduce ftrace based
	optiomization
Message-ID: <20120530072202.GA29068@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120529124833.9191.23007.stgit@localhost.localdomain> <20120529124944.9191.81924.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529124944.9191.81924.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053007-3270-0000-0000-000006BFA984
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 09:49:45PM +0900, Masami Hiramatsu wrote:
> Introduce function trace based kprobes optimization.
> 
> With using ftrace optimization, kprobes on the mcount calling
> address, use ftrace's mcount call instead of breakpoint.
> Farthermore, this optimization works with preemptive kernel
> not like as current jump-based optimization. Of cource,
> this feature is limited only if the probe on mcount call.

The above paragraph doesn't parse correctly for me. Do you mean to say
if the probe is on the mcount calling address, use the jump based
approach instead of the breakpoint one? Could you please rephrase?

...

> +static void __kprobes kprobe_ftrace_init(void)
> +{
> +	int ret;
> +
> +	ret = register_ftrace_function(&kprobe_ftrace_ops);
> +	WARN(ret < 0, "Failed to init kprobe-ftrace (%d)\n", ret);
> +
> +	kprobe_ftrace_enabled = 1;

Hmm.. is this right? kprobe_ftrace_enabled is 1 even if the init failed.

Ananth

