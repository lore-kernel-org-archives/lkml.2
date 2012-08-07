Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab2HGUYX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:24:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50506 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab2HGUYV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 16:24:21 -0400
Message-ID: <5021795A.6030902@zytor.com>
Date: Tue, 07 Aug 2012 13:23:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 0/4] ftrace: Add use of -mfentry for x86_64
References: <20120807193845.146666357@goodmis.org>
In-Reply-To: <20120807193845.146666357@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 12:38 PM, Steven Rostedt wrote:
>
> This is an RFC patch set that makes gcc use the -mfentry option with
> -pg. This will set the ftrace 'hook' to the beginning of the function
> and also remove the requirement that -pg enables frame pointers.
>
> This has a couple of benefits (and probably more).
>
> 1) removal of the frame pointer requirement makes for smaller and faster code.
>
> 2) Having the function trace hook at the beginning of the function instead
>   of after the frame is set up, gives the function tracing callbacks access
>   to the parameters. This means that kprobes can take advantage of this.
>   When a kprobe is set on top of a ftrace hook (nop), it will automatically
>   use the function tracing callback. This makes it into an 'optimized' probe
>   as there's no need to hit a breakpoint and trigger the probe that way.
>   The function tracing code can do the work for it. Note, optimized probes
>   are only allowed with !PREEMPT, but a ftrace optimize probe is allowed
>   in any context (another benefit).
>
> This only implements fentry for x86_64.
>

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

