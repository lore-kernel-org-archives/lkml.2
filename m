Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab0LIWch (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:32:37 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45833 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754996Ab0LIWcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:32:36 -0500
Date: Thu, 9 Dec 2010 14:32:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        sam@ravnborg.org, eric.dumazet@gmail.com, linux-arch@vger.kernel.org
Subject: Re: [patch 3/3]use new macros for x86 percpu readmostly section
Message-Id: <20101209143201.6ab0a49d.akpm@linux-foundation.org>
In-Reply-To: <1291255350.12777.117.camel@sli10-conroe>
References: <1291255350.12777.117.camel@sli10-conroe>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Dec 2010 10:02:30 +0800
Shaohua Li <shaohua.li@intel.com> wrote:

> Use the new macros to correctly align percpu readmostly data.
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> ---
>  arch/x86/kernel/vmlinux.lds.S |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> Index: linux/arch/x86/kernel/vmlinux.lds.S
> ===================================================================
> --- linux.orig/arch/x86/kernel/vmlinux.lds.S	2010-12-02 09:48:44.000000000 +0800
> +++ linux/arch/x86/kernel/vmlinux.lds.S	2010-12-02 09:54:24.000000000 +0800
> @@ -226,7 +226,7 @@ SECTIONS
>  	 * output PHDR, so the next output section - .init.text - should
>  	 * start another segment - init.
>  	 */
> -	PERCPU_VADDR(0, :percpu)
> +	PERCPU_VADDR_CACHEALIGNED(0, :percpu, INTERNODE_CACHE_BYTES)
>  #endif
>  
>  	INIT_TEXT_SECTION(PAGE_SIZE)
> @@ -301,7 +301,7 @@ SECTIONS
>  	}
>  
>  #if !defined(CONFIG_X86_64) || !defined(CONFIG_SMP)
> -	PERCPU(THREAD_SIZE)
> +	PERCPU_CACHEALIGNED(THREAD_SIZE, INTERNODE_CACHE_BYTES)
>  #endif
>  
>  	. = ALIGN(PAGE_SIZE);
> 

So what is the situation now with all other architectures?  Should they
be changed to correctly align their read-mostly percpu areas?

If so, what should the arch maintainers do to achieve this?
