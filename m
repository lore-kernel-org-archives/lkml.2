Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab2HUPmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:42:04 -0400
Received: from www.linutronix.de ([62.245.132.108]:41631 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2HUPl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:41:57 -0400
Date: Tue, 21 Aug 2012 17:41:46 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Attilio Rao <attilio.rao@citrix.com>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH 2/5] XEN: Remove the base argument from
 x86_init.paging.pagetable_setup_start PVOPS
In-Reply-To: <1345511646-12427-3-git-send-email-attilio.rao@citrix.com>
Message-ID: <alpine.LFD.2.02.1208211740340.2856@ionos>
References: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com> <1345511646-12427-3-git-send-email-attilio.rao@citrix.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Attilio Rao wrote:
> diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
> index 1019156..7999cef 100644
> --- a/arch/x86/mm/init_32.c
> +++ b/arch/x86/mm/init_32.c
> @@ -445,14 +445,17 @@ static inline void permanent_kmaps_init(pgd_t *pgd_base)
>  }
>  #endif /* CONFIG_HIGHMEM */
>  
> -void __init native_pagetable_setup_start(pgd_t *base)
> +void __init native_pagetable_setup_start(void)
>  {
>  	unsigned long pfn, va;
> +	pgd_t *base;
>  	pgd_t *pgd;

	pgd_t *pgd, *base = swapper_pg_dir;

Please. No need to add 5 lines just for this.

Thanks,

	tglx


