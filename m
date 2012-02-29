Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030874Ab2B2Hqf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:46:35 -0500
Received: from mail.southpole.se ([193.12.106.18]:36161 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966122Ab2B2Hqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:46:34 -0500
Message-ID: <1330501592.2964.1.camel@crucifix>
Subject: Re: [PATCH 1/2] OpenRISC: Fix audit_syscall_exit() usage
From: Jonas Bonn <jonas@southpole.se>
To: Richard Weinberger <richard@nod.at>
Cc: arnd@arndb.de, linux@openrisc.net, linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 08:46:32 +0100
In-Reply-To: <1330476393-14264-1-git-send-email-richard@nod.at>
References: <1330476393-14264-1-git-send-email-richard@nod.at>
Organization: South Pole AB
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu3 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 01591-02891
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Thanks, Richard.  There is, however, already a patch in linux-next that
provides this fix.

/Jonas

On Wed, 2012-02-29 at 01:46 +0100, Richard Weinberger wrote:
> Commit d7e7528 (Audit: push audit success and retcode into arch ptrace.h)
> changed audit_syscall_exit().
> 
> Fixes:
>   CC      arch/openrisc/kernel/ptrace.o
> arch/openrisc/kernel/ptrace.c: In function ‘do_syscall_trace_leave’:
> arch/openrisc/kernel/ptrace.c:206:21: error: macro "audit_syscall_exit" passed 2 arguments, but takes just 1
> arch/openrisc/kernel/ptrace.c:205:3: error: ‘audit_syscall_exit’ undeclared (first use in this function)
> arch/openrisc/kernel/ptrace.c:205:3: note: each undeclared identifier is reported only once for each function it appears in
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  arch/openrisc/kernel/ptrace.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/openrisc/kernel/ptrace.c b/arch/openrisc/kernel/ptrace.c
> index 656b94b..fa381b2 100644
> --- a/arch/openrisc/kernel/ptrace.c
> +++ b/arch/openrisc/kernel/ptrace.c
> @@ -202,8 +202,7 @@ asmlinkage void do_syscall_trace_leave(struct pt_regs *regs)
>  	int step;
>  
>  	if (unlikely(current->audit_context))
> -		audit_syscall_exit(AUDITSC_RESULT(regs->gpr[11]),
> -				   regs->gpr[11]);
> +		audit_syscall_exit(regs);
>  
>  	step = test_thread_flag(TIF_SINGLESTEP);
>  	if (step || test_thread_flag(TIF_SYSCALL_TRACE))


