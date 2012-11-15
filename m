Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756793Ab2KOJzJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 04:55:09 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:44386 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab2KOJzH convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 15 Nov 2012 04:55:07 -0500
Message-Id: <50A4CA0702000078000A8C21@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Thu, 15 Nov 2012 09:55:03 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Mukesh Rathor" <mukesh.rathor@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH]:  PVH: remove FEATURES_PVH macro
References: <20121114181933.1ffb5f09@mantra.us.oracle.com>
In-Reply-To: <20121114181933.1ffb5f09@mantra.us.oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 15.11.12 at 03:19, Mukesh Rathor <mukesh.rathor@oracle.com> wrote:
> PVH: remove macro FEATURES_PVH and put PVH strings in the ELFNOTE line, 
> because there's a null char before FEATURES_PVH and in the FEATURES_PVH 
> strings since this is not C file
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
> -	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz 
> "!writable_page_tables|pae_pgdir_above_4gb"FEATURES_PVH)
> +#ifdef CONFIG_XEN_X86_PVH
> +        ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz 
> "!writable_page_tables|pae_pgdir_above_4gb|writable_descriptor_tables|auto_tr
> anslated_physmap|supervisor_mode_kernel|hvm_callback_vector")
> +#else
> +        ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz 
> "!writable_page_tables|pae_pgdir_above_4gb")
> +#endif

Ugly. Can't you do this with a combination of .ascii and .asciz,
keeping the macro above?

Jan

>  	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
>  	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
>  	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
> -- 
> 1.7.2.3
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org 
> http://lists.xen.org/xen-devel 



