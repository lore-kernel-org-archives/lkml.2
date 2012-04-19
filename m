Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab2DSHpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 03:45:43 -0400
Received: from mga06.intel.com ([134.134.136.21]:29681 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753086Ab2DSHpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 03:45:40 -0400
Subject: Re: [PATCH] xtensa: fix build failure in xtensa/kernel/signal.c
From: Matt Fleming <matt.fleming@intel.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Chris Zankel <chris@zankel.net>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1334782256-351-1-git-send-email-paul.gortmaker@windriver.com>
References: <1334782256-351-1-git-send-email-paul.gortmaker@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Date: Thu, 19 Apr 2012 08:45:25 +0100
Message-ID: <1334821525.26997.39.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 16:50 -0400, Paul Gortmaker wrote:
> Caused by commit 3785006ac3c8941feb63097c416de92114a6bc39
> 
>     "xtensa: don't mask signals if we fail to setup signal stack"
> 
> It assigns a return value to "ret", but there is no such variable
> anywhere in scope.  Create one.
> 
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Chris Zankel <chris@zankel.net>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> 
> diff --git a/arch/xtensa/kernel/signal.c b/arch/xtensa/kernel/signal.c
> index b69b000..d78869a 100644
> --- a/arch/xtensa/kernel/signal.c
> +++ b/arch/xtensa/kernel/signal.c
> @@ -496,6 +496,7 @@ int do_signal(struct pt_regs *regs, sigset_t *oldset)
>  	signr = get_signal_to_deliver(&info, &ka, regs, NULL);
>  
>  	if (signr > 0) {
> +		int ret;
>  
>  		/* Are we from a system call? */
>  

Whoops! Thanks Paul, that's my bad. Looks like I went code-blind after
making the same kinds of changes to lots of different architectures.

I've added Andrew to the Cc list since he picked up the last set of
xtensa signal patches.

