Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0DWIiK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 04:38:10 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:57866 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0DWIiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 04:38:07 -0400
Date: Fri, 23 Apr 2010 17:37:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Will Deacon <will.deacon@arm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>,
       Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 3/6] hw-breakpoints: Change/Enforce some breakpoints policies
Message-ID: <20100423083752.GB11770@linux-sh.org>
References: <1271999639-23605-1-git-send-regression-fweisbec@gmail.com> <1271999639-23605-4-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1271999639-23605-4-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23, 2010 at 07:13:56AM +0200, Frederic Weisbecker wrote:
> diff --git a/arch/sh/include/asm/hw_breakpoint.h b/arch/sh/include/asm/hw_breakpoint.h
> index 965dd78..c575cf5 100644
> --- a/arch/sh/include/asm/hw_breakpoint.h
> +++ b/arch/sh/include/asm/hw_breakpoint.h
> @@ -47,7 +47,8 @@ struct pmu;
>  #define HBP_NUM		2
>  
>  /* arch/sh/kernel/hw_breakpoint.c */
> -extern int arch_check_va_in_userspace(unsigned long va, u16 hbp_len);
> +extern int arch_check_bp_in_kernelspace(struct perf_event *bp);
> +extern int arch_validate_hwbkpt_settings(struct perf_event *bp);
>  extern int arch_validate_hwbkpt_settings(struct perf_event *bp,
>  					 struct task_struct *tsk);
>  extern int hw_breakpoint_exceptions_notify(struct notifier_block *unused,

You forgot to kill off the existing arch_validate_hwbkpt_settings()
definition, so this part at least breaks the build.
