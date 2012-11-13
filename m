Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2KMQx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 11:53:26 -0500
Received: from smtp.citrix.com ([66.165.176.89]:58943 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755282Ab2KMQxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 11:53:24 -0500
X-IronPort-AV: E=Sophos;i="4.80,768,1344211200"; 
   d="scan'208";a="44442869"
Date: Tue, 13 Nov 2012 16:38:55 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 28/46] x86, mm: Add pointer about Xen mmu requirement
 for alloc_low_pages
In-Reply-To: <1352755122-25660-29-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1211131638060.28049@kaball.uk.xensource.com>
References: <20121112193044.GA11615@phenom.dumpdata.com> <1352755122-25660-1-git-send-email-yinghai@kernel.org> <1352755122-25660-29-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012, Yinghai Lu wrote:
> From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> Add link to commit 279b706 for more information
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

ah, here it is, OK then

>  arch/x86/mm/init.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
> index f5e0120..a7939ed 100644
> --- a/arch/x86/mm/init.c
> +++ b/arch/x86/mm/init.c
> @@ -25,6 +25,11 @@ unsigned long __meminitdata pgt_buf_top;
>  
>  static unsigned long min_pfn_mapped;
>  
> +/*
> + * Pages returned are already directly mapped.
> + *
> + * Changing that is likely to break Xen, see commit 279b706 for detail info.
                                                                    ^detailed

> + */
>  __ref void *alloc_low_pages(unsigned int num)
>  {
>  	unsigned long pfn;
> -- 
> 1.7.7
> 
