Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161157Ab2KNLTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 06:19:42 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:28220 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161052Ab2KNLTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 06:19:41 -0500
X-IronPort-AV: E=Sophos;i="4.83,250,1352073600"; 
   d="scan'208";a="214453599"
Date: Wed, 14 Nov 2012 11:19:06 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Yinghai Lu <yinghai@kernel.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 26/46] x86, mm, Xen: Remove mapping_pagetable_reserve()
In-Reply-To: <CAE9FiQUc0Jz0g+oZXye95dNCV0W4YMr-WMroUR_HaUmh-qZwoA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1211141117140.28049@kaball.uk.xensource.com>
References: <20121112193044.GA11615@phenom.dumpdata.com> <1352755122-25660-1-git-send-email-yinghai@kernel.org> <1352755122-25660-27-git-send-email-yinghai@kernel.org> <alpine.DEB.2.02.1211131629230.28049@kaball.uk.xensource.com>
 <CAE9FiQUc0Jz0g+oZXye95dNCV0W4YMr-WMroUR_HaUmh-qZwoA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012, Yinghai Lu wrote:
> On Tue, Nov 13, 2012 at 8:36 AM, Stefano Stabellini
> <stefano.stabellini@eu.citrix.com> wrote:
> > On Mon, 12 Nov 2012, Yinghai Lu wrote:
> >> Page table area are pre-mapped now after
> >>       x86, mm: setup page table in top-down
> >>       x86, mm: Remove early_memremap workaround for page table accessing on 64bit
> >>
> >> mapping_pagetable_reserve is not used anymore, so remove it.
> >
> > You should mention in the description of the patch that you are
> > removing mask_rw_pte too.
> >
> > The reason why you can do that safely is that you previously modified
> > allow_low_page to always return pages that are already mapped, moreover
> > xen_alloc_pte_init, xen_alloc_pmd_init, etc, will mark the page RO
> > before hooking it into the pagetable automatically.
> 
> updated change log:
> ---
> x86, mm, Xen: Remove mapping_pagetable_reserve()
> 
> Page table area are pre-mapped now after
>         x86, mm: setup page table in top-down
>         x86, mm: Remove early_memremap workaround for page table
> accessing on 64bit
> 
> mapping_pagetable_reserve is not used anymore, so remove it.
> 
> Also remove operation in mask_rw_pte(), as modified allow_low_page
> always return pages that are already mapped, moreover
> xen_alloc_pte_init, xen_alloc_pmd_init, etc, will mark the page RO
> before hooking it into the pagetable automatically.
> 
> -v2: add changelog about mask_rw_pte() from Stefano.

Thanks

 
> >
> > [ ... ]
> >
> > you should just get rid of mask_rw_pte completely
> 
> then how about 32bit mask_rw_pte? Maybe you can clean up that later?

Yes, I can clean it up later.

However it is trivial: mask_rw_pte is only called by xen_set_pte_init
and in the 32bit case it already returns pte without modifications.

I would just remove the call to mask_rw_pte in xen_set_pte_init.
