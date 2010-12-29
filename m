Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab0L2XFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 18:05:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60286 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab0L2XFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 18:05:39 -0500
Message-ID: <4D1BBEB7.3010901@zytor.com>
Date: Wed, 29 Dec 2010 15:05:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/6] x86: Change get_max_mapped() to inline
References: <4D0C072D.1040201@kernel.org> <4D19320B.7030007@kernel.org> <4D1933BA.8000508@kernel.org>
In-Reply-To: <4D1933BA.8000508@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2010 04:47 PM, Yinghai Lu wrote:
> 
> Move it into head file. to prepare use it in other files.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/page_types.h |    5 +++++
>  arch/x86/kernel/setup.c           |    9 ---------
>  2 files changed, 5 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/page_types.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/page_types.h
> +++ linux-2.6/arch/x86/include/asm/page_types.h
> @@ -45,6 +45,11 @@ extern int devmem_is_allowed(unsigned lo
>  extern unsigned long max_low_pfn_mapped;
>  extern unsigned long max_pfn_mapped;
>  
> +static inline u64 get_max_mapped(void)
> +{
> +	return (u64)max_pfn_mapped<<PAGE_SHIFT;
> +}
> +
>  extern unsigned long init_memory_mapping(unsigned long start,
>  					 unsigned long end);
>  

This is broken.  <asm/page_types.h> doesn't include <linux/types.h>
which is required for the u64 type -- a simple compile test would have
told you this.  Furthermore, it seems to me that it would make more
sense for this to be phys_addr_t instead of u64; would you agree?

	-hpa
