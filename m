Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759781Ab0GAWOm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:14:42 -0400
Received: from shutemov.name ([188.40.19.243]:39480 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932651Ab0GAWOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:14:21 -0400
Date: Fri, 2 Jul 2010 01:14:20 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Anfei Zhou <anfei.zhou@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [patch 071/149] ARM: 6166/1: Proper prefetch abort handling on
 pre-ARMv6
Message-ID: <20100701221420.GA10481@shutemov.name>
References: <20100701175144.GA2116@kroah.com>
 <20100701173212.785441106@clark.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701173212.785441106@clark.site>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 10:31:37AM -0700, Greg KH wrote:
> 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Anfei <anfei.zhou@gmail.com>
> 
> commit 5e27fb78df95e027723af2c90ecc9b4527ae59e9 upstream.
> 
> Instruction faults on pre-ARMv6 CPUs are interpreted as
> a 'translation fault', but do_translation_fault doesn't
> handle well if user mode trying to run instruction above
> TASK_SIZE, and result in the infinite retry of that
> instruction.
 
Actually, this patch helps also on ARMv6+. Probably, better to correct
commit message for stable.

> Signed-off-by: Anfei Zhou <anfei.zhou@gmail.com>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> ---
>  arch/arm/mm/fault.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> --- a/arch/arm/mm/fault.c
> +++ b/arch/arm/mm/fault.c
> @@ -386,6 +386,9 @@ do_translation_fault(unsigned long addr,
>  	if (addr < TASK_SIZE)
>  		return do_page_fault(addr, fsr, regs);
>  
> +	if (user_mode(regs))
> +		goto bad_area;
> +
>  	index = pgd_index(addr);
>  
>  	/*
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Kirill A. Shutemov
