Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab0LUW3e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 17:29:34 -0500
Received: from claw.goop.org ([74.207.240.146]:45466 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab0LUW3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 17:29:33 -0500
Message-ID: <4D112A4B.5000503@goop.org>
Date: Tue, 21 Dec 2010 14:29:31 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 04/10] xen/mmu: For 1-1 mapping, automatically set _PAGE_IOMAP.
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com> <1292967460-15709-5-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1292967460-15709-5-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
> This means that for PFNs (specifically: those in any E820 gaps
> or non-RAM E820 regions) that have 1-1 mapping we set the
> _PAGE_IOMAP flag.
>
> Later on we could remove the _PAGE_IOMAP code handling, but
> for right now lets keep this in to not introduce any bisection
> failures across this patchset.
>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/mmu.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 4ba7e4e..bd02e7d 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -832,6 +832,9 @@ static pteval_t pte_pfn_to_mfn(pteval_t val)
>  		pteval_t flags = val & PTE_FLAGS_MASK;
>  		unsigned long mfn = pfn_to_mfn(pfn);
>  
> +		if (mfn == pfn)
> +			flags |= _PAGE_IOMAP;

Why?  Does it really make sense to set _PAGE_IOMAP if they just happen
to be the same value?

    J
