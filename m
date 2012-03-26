Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920Ab2CZQQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:16:37 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59092 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932660Ab2CZQQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:16:36 -0400
Message-ID: <1332778595.6160.84.camel@joe2Laptop>
Subject: Re: [PATCH 19/20 v3] sparc/mm/fault_32.c: Port OOM changes to
 do_sparc_fault
From: Joe Perches <joe@perches.com>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: davem@davemloft.net, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 26 Mar 2012 09:16:35 -0700
In-Reply-To: <1332775946-2162-1-git-send-email-consul.kautuk@gmail.com>
References: <1332775946-2162-1-git-send-email-consul.kautuk@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 11:32 -0400, Kautuk Consul wrote:
[]
> diff --git a/arch/sparc/mm/fault_32.c b/arch/sparc/mm/fault_32.c
> index 8023fd7..6da1818 100644
> --- a/arch/sparc/mm/fault_32.c
> +++ b/arch/sparc/mm/fault_32.c
> @@ -226,6 +226,8 @@ asmlinkage void do_sparc_fault(struct pt_regs *regs, int text_fault, int write,
>  	unsigned long g2;
>  	int from_user = !(regs->psr & PSR_PS);
>  	int fault, code;
> +	unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
> +						  (write ? FAULT_FLAG_WRITE : 0));

David meant that the indentation should be aligned
immediately after the open parenthesis:

+	unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
+			      (write ? FAULT_FLAG_WRITE : 0));

though perhaps this is clearer as:

	unsigned int flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;

	if (write)
		flags |= FAULT_FLAG_WRITE;

or even separate sets.

	if (write)
		flags = foo;
	else
		flags = bar;


