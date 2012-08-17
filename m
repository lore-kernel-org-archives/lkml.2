Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601Ab2HQRaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:30:06 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:27577 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758608Ab2HQR3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:29:51 -0400
X-IronPort-AV: E=Sophos;i="4.77,785,1336348800"; 
   d="scan'208";a="14064774"
Date: Fri, 17 Aug 2012 18:29:32 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [Xen-devel] [PATCH 01/11] xen/p2m: Fix the comment describing
 the P2M tree.
In-Reply-To: <1345133009-21941-2-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1208171829230.15568@kaball.uk.xensource.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com> <1345133009-21941-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Aug 2012, Konrad Rzeszutek Wilk wrote:
> It mixed up the p2m_mid_missing with p2m_missing. Also
> remove some extra spaces.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>


Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

>  arch/x86/xen/p2m.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 64effdc..e4adbfb 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -22,7 +22,7 @@
>   *
>   * P2M_PER_PAGE depends on the architecture, as a mfn is always
>   * unsigned long (8 bytes on 64-bit, 4 bytes on 32), leading to
> - * 512 and 1024 entries respectively. 
> + * 512 and 1024 entries respectively.
>   *
>   * In short, these structures contain the Machine Frame Number (MFN) of the PFN.
>   *
> @@ -139,11 +139,11 @@
>   *      /    | ~0, ~0, ....  |
>   *     |     \---------------/
>   *     |
> - *     p2m_missing             p2m_missing
> - * /------------------\     /------------\
> - * | [p2m_mid_missing]+---->| ~0, ~0, ~0 |
> - * | [p2m_mid_missing]+---->| ..., ~0    |
> - * \------------------/     \------------/
> + *   p2m_mid_missing           p2m_missing
> + * /-----------------\     /------------\
> + * | [p2m_missing]   +---->| ~0, ~0, ~0 |
> + * | [p2m_missing]   +---->| ..., ~0    |
> + * \-----------------/     \------------/
>   *
>   * where ~0 is INVALID_P2M_ENTRY. IDENTITY is (PFN | IDENTITY_BIT)
>   */
> @@ -423,7 +423,7 @@ static void free_p2m_page(void *p)
>  	free_page((unsigned long)p);
>  }
>  
> -/* 
> +/*
>   * Fully allocate the p2m structure for a given pfn.  We need to check
>   * that both the top and mid levels are allocated, and make sure the
>   * parallel mfn tree is kept in sync.  We may race with other cpus, so
> -- 
> 1.7.7.6
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
