Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760865Ab2EQJjm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 05:39:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:42647 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758158Ab2EQJjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 05:39:40 -0400
Date: Thu, 17 May 2012 10:39:21 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Miller <davem@davemloft.net>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>, Mel Gorman <mel@csn.ul.ie>,
        Nick Piggin <npiggin@kernel.dk>, Russell King <rmk@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC][PATCH 4/6] arm, mm: Convert arm to generic tlb
Message-ID: <20120517093921.GB14666@arm.com>
References: <20110302175928.022902359@chello.nl>
 <20110302180259.109909335@chello.nl>
 <20120517030551.GA11623@linux-sh.org>
 <20120517093022.GA14666@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120517093022.GA14666@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:30:23AM +0100, Catalin Marinas wrote:
> Another minor thing is that on newer ARM processors (Cortex-A15) we
> need the TLB shootdown even on UP systems, so tlb_fast_mode should
> always return 0. Something like below (untested):
> 
> 
> diff --git a/arch/arm/include/asm/tlb.h b/arch/arm/include/asm/tlb.h
> index 37dbce9..8e79689 100644
> --- a/arch/arm/include/asm/tlb.h
> +++ b/arch/arm/include/asm/tlb.h
> @@ -23,6 +23,10 @@
>  
>  #include <linux/pagemap.h>
>  
> +#ifdef CONFIG_CPU_32v7
> +#define tlb_fast_mode	(0)
> +#endif
> +
>  #include <asm-generic/tlb.h>
>  
>  #else /* !CONFIG_MMU */

This hunk should have been a few lines down for the CONFIG_MMU case.

-- 
Catalin
