Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757998Ab2EUR36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 13:29:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36510 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757356Ab2EUR35 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 13:29:57 -0400
Message-ID: <1337621394.13812.2.camel@joe2Laptop>
Subject: Re: [tip:x86/urgent] x86, printk: Add missing KERN_CONT to NMI
 selftest
From: Joe Perches <joe@perches.com>
To: mingo@kernel.org, hpa@zytor.com, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Date: Mon, 21 May 2012 10:29:54 -0700
In-Reply-To: <tip-29d679ffd850ea37a303bb930142be14982611e4@git.kernel.org>
References: <1336492573-17530-3-git-send-email-levinsasha928@gmail.com>
	 <tip-29d679ffd850ea37a303bb930142be14982611e4@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 10:25 -0700, tip-bot for Sasha Levin wrote:
> Commit-ID:  29d679ffd850ea37a303bb930142be14982611e4
> Gitweb:     http://git.kernel.org/tip/29d679ffd850ea37a303bb930142be14982611e4
> Author:     Sasha Levin <levinsasha928@gmail.com>
> AuthorDate: Tue, 8 May 2012 17:56:12 +0200
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Mon, 21 May 2012 10:13:04 -0700
> 
> x86, printk: Add missing KERN_CONT to NMI selftest
> 
> Fix this behaviour:
> 
> ----------------
> | NMI testsuite:
> --------------------
>   remote IPI:
>   ok  |
> 
>    local IPI:
>   ok  |
> 
> Revealed due to a new modification to printk().
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> Link: http://lkml.kernel.org/r/1336492573-17530-3-git-send-email-levinsasha928@gmail.com
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>
> ---
>  arch/x86/kernel/nmi_selftest.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/nmi_selftest.c b/arch/x86/kernel/nmi_selftest.c
> index 2c39dcd..9f11dd3 100644
> --- a/arch/x86/kernel/nmi_selftest.c
> +++ b/arch/x86/kernel/nmi_selftest.c
> @@ -117,15 +117,15 @@ static void __init dotest(void (*testcase_fn)(void), int expected)
>  		unexpected_testcase_failures++;
>  
>  		if (nmi_fail == FAILURE)
> -			printk("FAILED |");
> +			printk(KERN_CONT "FAILED |");
>  		else if (nmi_fail == TIMEOUT)
> -			printk("TIMEOUT|");
> +			printk(KERN_CONT "TIMEOUT|");
>  		else
> -			printk("ERROR  |");
> +			printk(KERN_CONT "ERROR  |");
>  		dump_stack();
>  	} else {
>  		testcase_successes++;
> -		printk("  ok  |");
> +		printk(KERN_CONT "  ok  |");
>  	}
>  	testcase_total++;
>  
> @@ -150,10 +150,10 @@ void __init nmi_selftest(void)
>  
>  	print_testname("remote IPI");
>  	dotest(remote_ipi, SUCCESS);
> -	printk("\n");
> +	printk(KERN_CONT "\n");
>  	print_testname("local IPI");
>  	dotest(local_ipi, SUCCESS);
> -	printk("\n");
> +	printk(KERN_CONT "\n");
>  
>  	cleanup_nmi_testsuite();

I believe this change is no longer required.
Kay's printk modifications have been updated.

It's somewhat useful, but the commit message
but not the commit subject is untrue.


