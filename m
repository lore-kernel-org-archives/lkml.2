Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626Ab1G0NIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 09:08:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48414 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab1G0NIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 09:08:13 -0400
Date: Wed, 27 Jul 2011 09:06:04 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andy Lutomirski <luto@mit.edu>
Cc: x86@kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jeremy@goop.org, keir.xen@gmail.com, xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 4/5] x86-64/xen: Enable the vvar mapping
Message-ID: <20110727130604.GD6713@dumpdata.com>
References: <cover.1311736366.git.luto@mit.edu>
 <b6598d164fbe64eeea37c0369b64dd6ceaeeb504.1311736366.git.luto@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6598d164fbe64eeea37c0369b64dd6ceaeeb504.1311736366.git.luto@mit.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4E300D46.01AA:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 11:20:38PM -0400, Andy Lutomirski wrote:
> Xen needs special treatment for fixmaps.

The description needs a bit more, for example:

"Xen needs to handle the newly introduced VVAR_PAGE introduced by
git commit 9fd67b4ed0714ab718f1f9bd14c344af336a6df7
"x86-64: Give vvars their own page"

Otherwise we die during bootup with this:

<and include snippets of the boot message crash>
"

With that included it looks good to me.

> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> Reported-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/mmu.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index f987bde..8cce339 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1916,6 +1916,7 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
>  # endif
>  #else
>  	case VSYSCALL_LAST_PAGE ... VSYSCALL_FIRST_PAGE:
> +	case VVAR_PAGE:
>  #endif
>  	case FIX_TEXT_POKE0:
>  	case FIX_TEXT_POKE1:
> @@ -1956,7 +1957,8 @@ static void xen_set_fixmap(unsigned idx, phys_addr_t phys, pgprot_t prot)
>  #ifdef CONFIG_X86_64
>  	/* Replicate changes to map the vsyscall page into the user
>  	   pagetable vsyscall mapping. */
> -	if (idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) {
> +	if ((idx >= VSYSCALL_LAST_PAGE && idx <= VSYSCALL_FIRST_PAGE) ||
> +	    idx == VVAR_PAGE) {
>  		unsigned long vaddr = __fix_to_virt(idx);
>  		set_pte_vaddr_pud(level3_user_vsyscall, vaddr, pte);
>  	}
> -- 
> 1.7.6
