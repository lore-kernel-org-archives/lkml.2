Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2HMImz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 04:42:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:34364 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2HMImx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 04:42:53 -0400
Date: Mon, 13 Aug 2012 10:42:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC PATCH 0/4] ftrace: Add use of -mfentry for x86_64
Message-ID: <20120813084245.GA3417@gmail.com>
References: <20120807193845.146666357@goodmis.org>
 <5021795A.6030902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5021795A.6030902@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 08/07/2012 12:38 PM, Steven Rostedt wrote:
> >
> >This is an RFC patch set that makes gcc use the -mfentry option with
> >-pg. This will set the ftrace 'hook' to the beginning of the function
> >and also remove the requirement that -pg enables frame pointers.
> >
> >This has a couple of benefits (and probably more).
> >
> >1) removal of the frame pointer requirement makes for smaller and faster code.
> >
> >2) Having the function trace hook at the beginning of the function instead
> >  of after the frame is set up, gives the function tracing callbacks access
> >  to the parameters. This means that kprobes can take advantage of this.
> >  When a kprobe is set on top of a ftrace hook (nop), it will automatically
> >  use the function tracing callback. This makes it into an 'optimized' probe
> >  as there's no need to hit a breakpoint and trigger the probe that way.
> >  The function tracing code can do the work for it. Note, optimized probes
> >  are only allowed with !PREEMPT, but a ftrace optimize probe is allowed
> >  in any context (another benefit).
> >
> >This only implements fentry for x86_64.
> >
> 
> Acked-by: H. Peter Anvin <hpa@linux.intel.com>

Acked-by: Ingo Molnar <mingo@kernel.org>

Nice feature!

Thanks,

	Ingo
