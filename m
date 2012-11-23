Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825Ab2KWQdI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 11:33:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40045 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755631Ab2KWQdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 11:33:06 -0500
Date: Fri, 23 Nov 2012 17:33:20 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Amnon Shiloh <u3557@miso.sublimeip.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: arch_check_bp_in_kernelspace: fix the range check
Message-ID: <20121123163320.GA32716@redhat.com>
References: <20121122161238.GA27078@redhat.com> <20121123091453.016B0592076@miso.sublimeip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123091453.016B0592076@miso.sublimeip.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Amnon,

I am a bit confused,

On 11/23, Amnon Shiloh wrote:
>
> What I discovered now, is that PTRACE_SYSCALL (also PTRACE_SINGLESTEP)
> does not work within the vsyscall page, so I cannot trap the kernel-calls
> there (this is very simple to verify using "gdb" or "strace").

Sure, but we alredy discussed this?

Once again, PTRACE_SYSCALL should work in the NATIVE mode. Obviously it
won't work in EMULATE mode but we can change emulate_vsyscall() to report
TRAP_VSYSCALL or even introduce PTRACE_EVENT_VSYSCALL.

> The necessary patch was already discussed and is very simple.

Do you mean TRAP_VSYSCALL/PTRACE_EVENT_VSYSCALL above or additional
in_gate_area_no_mm() check to allow the hw bp?

> Or, there is an alternative: if only I (the ptracer or the traced process)
> was allowed to munmap the vsyscall page,

It is not possible to unmap it. The kernel (swapper_pg_dir) has this
mapping, not the process. Unlike vdso. IOW, you can only "unmap" it
globally and obviously you can't do this from the userspace.

Oleg.

