Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1ALIs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 03:48:26 -0500
Received: from ozlabs.org ([203.10.76.45]:35490 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754660Ab1ALIsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 03:48:24 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] module: fix build when DEBUGP is defined
Date: Wed, 12 Jan 2011 19:18:20 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-24-generic; KDE/4.5.1; i686; ; )
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
References: <20110111172153.e43e03b8.randy.dunlap@oracle.com>
In-Reply-To: <20110111172153.e43e03b8.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101121918.21079.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Jan 2011 11:51:53 am Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix module loader build when DEBUGP is defined.
> Fixes build error & warning:
> 
> kernel/module.c:1910: error: 'name' undeclared (first use in this function)
> kernel/module.c:2567: warning: format '%lx' expects type 'long unsigned int', but argument 2 has type 'Elf64_Addr'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  kernel/module.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-next-20110111.orig/kernel/module.c
> +++ linux-next-20110111/kernel/module.c
> @@ -1907,7 +1907,7 @@ static void layout_sections(struct modul
>  			    || strstarts(sname, ".init"))
>  				continue;
>  			s->sh_entsize = get_offset(mod, &mod->core_size, s, i);
> -			DEBUGP("\t%s\n", name);
> +			DEBUGP("\t%s\n", sname);
>  		}
>  		switch (m) {
>  		case 0: /* executable */
> @@ -2563,7 +2563,7 @@ static int move_module(struct module *mo
>  			memcpy(dest, (void *)shdr->sh_addr, shdr->sh_size);
>  		/* Update sh_addr to point to copy in image. */
>  		shdr->sh_addr = (unsigned long)dest;
> -		DEBUGP("\t0x%lx %s\n",
> +		DEBUGP("\t0x%llx %s\n",
>  		       shdr->sh_addr, info->secstrings + shdr->sh_name);

This will break on 32-bit.  We really need a cast to long here :(

Thanks,
Rusty.
