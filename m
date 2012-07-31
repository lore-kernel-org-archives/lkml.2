Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970Ab2GaN5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:57:47 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:19226 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2GaN5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:57:42 -0400
Date: Tue, 31 Jul 2012 09:48:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        Ian.Campbell@citrix.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH 1/3] xen/mmu/p2m: Check extend_brk for NULL
Message-ID: <20120731134811.GH4789@phenom.dumpdata.com>
References: <1343731376-20658-1-git-send-email-konrad.wilk@oracle.com>
 <1343731376-20658-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343731376-20658-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2012 at 06:42:54AM -0400, Konrad Rzeszutek Wilk wrote:
> Which allows us to be a bit smarter in case we exhaust the reserved
> virtual space.
> 
> [v1: Suggested by Ian Campbell]
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/enlighten.c |    2 ++
>  arch/x86/xen/mmu.c       |    5 ++++-
>  arch/x86/xen/p2m.c       |   35 ++++++++++++++++++++++++-----------
>  3 files changed, 30 insertions(+), 12 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 993e2a5..923d98e 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1519,6 +1519,8 @@ void __ref xen_hvm_init_shared_info(void)
>  	if (!shared_info_page)
>  		shared_info_page = (struct shared_info *)
>  			extend_brk(PAGE_SIZE, PAGE_SIZE);
> +	if (!shared_info_page)
> +		return;
>  	xatp.domid = DOMID_SELF;
>  	xatp.idx = 0;
>  	xatp.space = XENMAPSPACE_shared_info;
> diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
> index 993ba07..d7a2044 100644
> --- a/arch/x86/xen/mmu.c
> +++ b/arch/x86/xen/mmu.c
> @@ -1711,6 +1711,8 @@ static void __init xen_map_identity_early(pmd_t *pmd, unsigned long max_pfn)
>  
>  	level1_ident_pgt = extend_brk(sizeof(pte_t) * LEVEL1_IDENT_ENTRIES,
>  				      PAGE_SIZE);
> +	if (!level_ident_pgt)
> +		goto out;
>  

And this is what I get for posting patches in the wee mornings without coffee..
It obviously should have be level1_ident_pgt.
