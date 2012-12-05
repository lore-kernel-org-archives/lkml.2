Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2LEKEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 05:04:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6917 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753312Ab2LEKEJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 05:04:09 -0500
Date: Wed, 5 Dec 2012 10:29:51 +0100
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>, mosix@mosix.com.au
Cc: Amnon Shiloh <u3557@miso.sublimeip.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, Pedro Alves <palves@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: PTRACE_SYSCALL && vsyscall (Was: arch_check_bp_in_kernelspace:
 fix the range check)
Message-ID: <20121205092951.GA14280@host2.jankratochvil.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <841b7a319f9d22402d269eed23d03835.squirrel@mail.sublimeip.com>
 <20121202193058.GA4264@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Dec 2012 20:30:58 +0100, Oleg Nesterov wrote:
> Yes, that is why I said this needs the new option.

I do not mind new options although personally I do not find them meaningful
for an already deprecated ABI compatibility-only issue.


> If the tracer does PTRACE_SYSCALL the tracee reports syscall exit
> _after_ gettimeofday/etc. The tracer can look at regs->orig_ax == -1
> and detect that this is not syscall but vsyscall, it can look at
> regs->ip then (not with the patch below).

I believe applications just call PTRACE_SYSCALL twice, without checking
orig_eax.  At least strace and its TCB_INSYSCALL looks so.


On Mon, 03 Dec 2012 00:54:58 +0100, u3557@miso.sublimeip.com wrote:
> The beauty of using the x86 debug-registers,

x86 debug registers are already very scarce.  Besides that userland
applications know they have 4 of them available so it would also break them.


Regards,
Jan
