Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab1GDC2t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 22:28:49 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:46572 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690Ab1GDC2r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 22:28:47 -0400
Subject: Re: [PATCH v2 1/1] asm-generic: add MMU variants of io.h functions
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Jonas Bonn <jonas@southpole.se>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        vapier@gentoo.org, liqin.chen@sunplusct.com
In-Reply-To: <1309628168-3413-1-git-send-email-jonas@southpole.se>
References: <CAMjpGUeMqVzcAWKpAojZVbj9ywH+4HmW4Hx-8D1WQmTqPSNqQA@mail.gmail.com>
	 <1309628168-3413-1-git-send-email-jonas@southpole.se>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Mon, 04 Jul 2011 10:28:17 +0800
Message-ID: <1309746497.2291.3.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's very good to me, thanks.

Guan Xuetao

On Sat, 2011-07-02 at 19:36 +0200, Jonas Bonn wrote:
> Some of the implementations, in particular the ioremap variants, in
> asm-generic/io.h are for systems without an MMU.  In order to be able to
> use the generic header file for systems with an MMU, this patch wraps
> these implementations in checks for CONFIG_MMU.
> 
> Tested on OpenRISC.
> 
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> Cc: vapier@gentoo.org
> Cc: liqin.chen@sunplusct.com
> Cc: gxt@mprc.pku.edu.cn
> ---
>  include/asm-generic/io.h |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-generic/io.h b/include/asm-generic/io.h
> index e0ffa3d..a1caf2d 100644
> --- a/include/asm-generic/io.h
> +++ b/include/asm-generic/io.h
> @@ -307,7 +307,11 @@ static inline void *phys_to_virt(unsigned long address)
>  
>  /*
>   * Change "struct page" to physical address.
> + *
> + * This implementation is for the no-MMU case only... if you have an MMU
> + * you'll need to provide your own definitions.
>   */
> +#ifndef CONFIG_MMU
>  static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
>  {
>  	return (void __iomem*) (unsigned long)offset;
> @@ -326,6 +330,7 @@ static inline void __iomem *ioremap(phys_addr_t offset, unsigned long size)
>  static inline void iounmap(void *addr)
>  {
>  }
> +#endif /* CONFIG_MMU */
>  
>  #ifndef CONFIG_GENERIC_IOMAP
>  static inline void __iomem *ioport_map(unsigned long port, unsigned int nr)
> @@ -342,7 +347,7 @@ extern void ioport_unmap(void __iomem *p);
>  #endif /* CONFIG_GENERIC_IOMAP */
>  
>  #define xlate_dev_kmem_ptr(p)	p
> -#define xlate_dev_mem_ptr(p)	((void *) (p))
> +#define xlate_dev_mem_ptr(p)	__va(p)
>  
>  #ifndef virt_to_bus
>  static inline unsigned long virt_to_bus(volatile void *address)


