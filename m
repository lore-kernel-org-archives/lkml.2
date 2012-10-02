Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab2JBKoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 06:44:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:55454 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2JBKoW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 06:44:22 -0400
Message-ID: <1349174644.7780.23.camel@twins>
Subject: Re: [PATCH] perf x86_64: Fix rsp register for system call fast path
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Date: Tue, 02 Oct 2012 12:44:04 +0200
In-Reply-To: <1349112712-2590-1-git-send-email-jolsa@redhat.com>
References: <1349112712-2590-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-01 at 19:31 +0200, Jiri Olsa wrote:
> @@ -696,7 +696,7 @@ struct perf_branch_stack {
>  
>  struct perf_regs_user {
>         __u64           abi;
> -       struct pt_regs  *regs;
> +       struct pt_regs  regs;
>  };

That's somewhat unfortunate but unavoidable I guess, can't go modify pt_regs. 


> +               if (uregs->abi)
> +                       stack_size = perf_sample_ustack_size(sample_stack_user,
> +                                                            header->size,
> +    

just a style nit, please add {} for all multi-line single stmt
constructs like that, even though not strictly required.

It reduces the possible confusion between multi-line and multi-statement
and reads easier.
