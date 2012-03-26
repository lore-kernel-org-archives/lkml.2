Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921Ab2CZQgx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 12:36:53 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:11592 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932809Ab2CZQgw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 12:36:52 -0400
Date: Mon, 26 Mar 2012 18:36:44 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: davem@davemloft.net, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ingo Molnar <mingo@elte.hu>, Joe Perches <joe@perches.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 19/20 v3] sparc/mm/fault_32.c: Port OOM changes to
	do_sparc_fault
Message-ID: <20120326163644.GA23176@merkur.ravnborg.org>
References: <1332775946-2162-1-git-send-email-consul.kautuk@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332775946-2162-1-git-send-email-consul.kautuk@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 11:32:26AM -0400, Kautuk Consul wrote:
> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
> (mm: retry page fault when blocking on disk transfer) and
> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
> (x86,mm: make pagefault killable)
> 
> The above commits introduced changes into the x86 pagefault handler
> for making the page fault handler retryable as well as killable.
> 
> These changes reduce the mmap_sem hold time, which is crucial
> during OOM killer invocation.
> 
> Port these changes to 32-bit sparc.
> 
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> ---
>  arch/sparc/mm/fault_32.c |   37 ++++++++++++++++++++++++++++++-------
>  1 files changed, 30 insertions(+), 7 deletions(-)
> 
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
Hi Kautuk.

The indention still look like shit.
It looks like this (tabs converted to spaces):
        unsigned int flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
                                          (write ? FAULT_FLAG_WRITE : 0));


	Sam

