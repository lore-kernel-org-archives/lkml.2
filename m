Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2CYT15 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 15:27:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44174 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756795Ab2CYT14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 15:27:56 -0400
Message-ID: <4F6F719B.5020806@zytor.com>
Date: Sun, 25 Mar 2012 12:27:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Jan Beulich <JBeulich@suse.com>
Subject: Re: [GIT PULL] x86, microcode fixes for 3.2
References: <20111128204311.GA2814@aftab> <20111202194658.GF15204@aftab> <20111205092612.GB29641@elte.hu> <20111205151016.GC7834@aftab>
In-Reply-To: <20111205151016.GC7834@aftab>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 07:10 AM, Borislav Petkov wrote:
> 
> diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
> index 084ef95..95203d4 100644
> --- a/arch/x86/include/asm/msr.h
> +++ b/arch/x86/include/asm/msr.h
> @@ -169,7 +169,14 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
>  	return native_write_msr_safe(msr, low, high);
>  }
>  
> -/* rdmsr with exception handling */
> +/*
> + * rdmsr with exception handling.
> + *
> + * Please note that the exception handling works only after we've
> + * switched to the "smart" #GP handler in trap_init() which knows about
> + * exception tables - using this macro earlier than that causes machine
> + * hangs on boxes which do not implement the @msr in the first argument.
> + */
>  #define rdmsr_safe(msr, p1, p2)					\
>  ({								\
>  	int __err;						\

I keep wondering if we couldn't have the early-static trap handlers be
aware of exception tables, too; they wouldn't have to worry about
modules and so it would be reasonably easy.

	-hpa
