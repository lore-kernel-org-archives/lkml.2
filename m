Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab1HKAV6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 20:21:58 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54686 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab1HKAV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 20:21:56 -0400
X-AuditID: b753bd60-9ea82ba000000655-d5-4e4320a09bb8
X-AuditID: b753bd60-9ea82ba000000655-d5-4e4320a09bb8
Message-ID: <4E43209D.7090104@hitachi.com>
Date: Thu, 11 Aug 2011 09:21:49 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH 0/5][RFC] kprobes/ftrace: Have kprobes use ftrace on ftrace
 nops
References: <20110810162222.017387055@goodmis.org>
In-Reply-To: <20110810162222.017387055@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Thanks for this nice feature!

(2011/08/11 1:22), Steven Rostedt wrote:
> Hi All,
>
> I started working on adding the -mfentry switch to ftrace, which
> allows us to remove the frame pointers requirement from function tracing
> as well as makes mcount (fentry) work just better.
>
> But when I did this in another branch, I noticed that I broke kprobes
> in its most common usage. The attaching a probe at the beginning of
> a function to use get to its parameters.
>
> So I started this branch. This branch is to have kprobes use ftrace
> directly when a probe is attached to a ftrace nop. Currently, kprobes
> will just error when that happens. With this patch set, it will hook
> into the ftrace infrastructure and use ftrace instead. This is more
> like an optimized probe as no breakpoints need to be set. A call to
> the function is done directly via the mcount trampoline. If ftrace
> pt_regs is implemented for an arch, kprobes gets this feature for free.

I agreed this idea, this looks good to me too :)
With -fentry, this can improve dynamic trace events very much.

BTW (OT), it seems that current kprobe data structure becomes a bit
fat. Maybe what we need is just a "holder of hooking handler" as
what ftrace provides, not a full storage data structure of copied
instrucutions. Perhaps, we'd better diet the kprobe structure for
transparency of hooking infrastructure.

> The first patch is just a clean up that I need to push out to get rid
> of the annoying compile warning about initialized variables that
> gcc can't tell have been initialized.
>
> The next two patches have ftrace pass both the ftrace_ops structure
> and the pt_regs to the callback function that is registered with ftrace.
>
> The last two patches have kprobes interact with ftrace and use the
> ftrace infrastructure instead.
>
> I only did this for x86_64, and will do it for x86_32 and PPC64 if everyone
> agrees with this approach. Then I could find people to do it for other
> archs :)

OK, I'll review this soon!

Thank you!

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
