Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950Ab2CZQb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:31:26 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40605 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932561Ab2CZQbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:31:25 -0400
Message-ID: <1332779484.6160.95.camel@joe2Laptop>
Subject: Re: [PATCH 20/20 v3] sparc/mm/fault_64.c: Port OOM changes to
 do_sparc64_fault
From: Joe Perches <joe@perches.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: davem@davemloft.net, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Mar 2012 09:31:24 -0700
In-Reply-To: <1332775997-2197-1-git-send-email-consul.kautuk@gmail.com>
References: <1332775997-2197-1-git-send-email-consul.kautuk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 11:33 -0400, Kautuk Consul wrote:
> diff --git a/arch/sparc/mm/fault_64.c b/arch/sparc/mm/fault_64.c
> index 504c062..8322962 100644
> --- a/arch/sparc/mm/fault_64.c
> +++ b/arch/sparc/mm/fault_64.c
> @@ -279,6 +279,7 @@ asmlinkage void __kprobes do_sparc64_fault(struct pt_regs *regs)
>  	unsigned int insn = 0;
>  	int si_code, fault_code, fault;
>  	unsigned long address, mm_rss;
> +	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
>  
>  	fault_code = get_thread_fault_code();
>  
[]
> @@ -423,7 +426,13 @@ good_area:
>  			goto bad_area;
>  	}
>  
> -	fault = handle_mm_fault(mm, vma, address, (fault_code & FAULT_CODE_WRITE) ? FAULT_FLAG_WRITE : 0);
> +	fault = handle_mm_fault(mm, vma, address,
> +							flags | ((fault_code & FAULT_CODE_WRITE) ?
> +									 FAULT_FLAG_WRITE : 0);

A bit redundant and very poor style argument alignment
Make sure your tab indentation is set to 8.

	fault = handle_mm_fault(mm, vma, address,
				flags | (fault_code & FAULT_CODE_WRITE));

though perhaps fault_code could be unsigned and
perhaps you could use the same style initializer
for fault_code as patch 19/20.


