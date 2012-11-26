Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755725Ab2KZTyK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 14:54:10 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:27896 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab2KZTyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 14:54:09 -0500
Date: Mon, 26 Nov 2012 14:54:00 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Mukesh Rathor <mukesh.rathor@oracle.com>
Cc: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]:  PVH: remove FEATURES_PVH macro
Message-ID: <20121126195400.GA8025@phenom.dumpdata.com>
References: <20121114181933.1ffb5f09@mantra.us.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114181933.1ffb5f09@mantra.us.oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 06:19:33PM -0800, Mukesh Rathor wrote:
> PVH: remove macro FEATURES_PVH and put PVH strings in the ELFNOTE line, because there's a null char before FEATURES_PVH and in the FEATURES_PVH strings since this is not C file

ping? Jan had a comment about it to keep the #ifdef at the top
and combine ascii and asiz?

http://lists.xen.org/archives/html/xen-devel/2012-11/msg00676.html

> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> ---
>  arch/x86/xen/xen-head.S |   14 +++++---------
>  1 files changed, 5 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> index 1a6bca1..340fd4e 100644
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -13,14 +13,6 @@
>  #include <xen/interface/elfnote.h>
>  #include <asm/xen/interface.h>
>  
> -#ifdef CONFIG_XEN_X86_PVH
> -#define FEATURES_PVH "|writable_descriptor_tables" \
> -		     "|auto_translated_physmap" \
> -		     "|supervisor_mode_kernel" \
> -		     "|hvm_callback_vector"
> -#else
> -#define FEATURES_PVH /* Not supported */
> -#endif
>  
>  	__INIT
>  ENTRY(startup_xen)
> @@ -104,7 +96,11 @@ NEXT_HYPERCALL(arch_6)
>  #endif
>  	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
>  	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
> -	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb"FEATURES_PVH)
> +#ifdef CONFIG_XEN_X86_PVH
> +        ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb|writable_descriptor_tables|auto_translated_physmap|supervisor_mode_kernel|hvm_callback_vector")
> +#else
> +        ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
> +#endif
>  	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
>  	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
>  	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
> -- 
> 1.7.2.3
