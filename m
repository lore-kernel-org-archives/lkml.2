Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395Ab2CWMWP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 08:22:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:64457 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758287Ab2CWMWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 08:22:13 -0400
Date: Fri, 23 Mar 2012 13:22:09 +0100
From: Ingo Molnar <mingo@kernel.org>
To: "he, bo" <bo.he@intel.com>
Cc: akpm@linux-foudation.org, mingo@elte.hu, a.p.zijlstra@chello.nl,
        rusty@rustcorp.com.au, william.douglas@intel.com,
        linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com
Subject: Re: [PATCH 2/2] enable dumpstack() to printk log level
Message-ID: <20120323122208.GB13920@gmail.com>
References: <1332493027.2359.5.camel@hebo>
 <1332493269.2359.9.camel@hebo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332493269.2359.9.camel@hebo>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* he, bo <bo.he@intel.com> wrote:

> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -177,20 +177,29 @@ void show_stack(struct task_struct *task, unsigned long *sp)
>  }
>  
>  /*
> - * The architecture-independent dump_stack generator
> + * The architecture-independent dump_stack_log_lvl generator

I guess it wants to say "architecture-dependent"?

> +	show_trace_log_lvl(NULL, NULL, &stack, bp, log_lvl);
> +}
> +EXPORT_SYMBOL(dump_stack_log_lvl);

this should be a _GPL export.

> +}
> +EXPORT_SYMBOL(dump_stack_log_lvl);

Ditto.

Looks useful otherwise.

Thanks,

	Ingo
