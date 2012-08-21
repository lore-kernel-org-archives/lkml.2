Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab2HULKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 07:10:00 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:6207 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191Ab2HULJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 07:09:58 -0400
X-IronPort-AV: E=Sophos;i="4.77,802,1336348800"; 
   d="scan'208";a="14103823"
Date: Tue, 21 Aug 2012 12:09:36 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Attilio Rao <attilio.rao@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Subject: Re: [PATCH 0/5] X86/XEN: Merge x86_init.paging.pagetable_setup_start
 and x86_init.paging.pagetable_setup_done PVOPS and document the semantic
In-Reply-To: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
Message-ID: <alpine.DEB.2.02.1208211207550.15568@kaball.uk.xensource.com>
References: <1345511646-12427-1-git-send-email-attilio.rao@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Aug 2012, Attilio Rao wrote:
> Currently the definition of x86_init.paging.pagetable_setup_start and
> x86_init.paging.pagetable_setup_done is twisted and not really well
> defined (in terms of prototypes desired). More specifically:
> pagetable_setup_start:
>  * it is a nop on x86_32
>  * it is a nop for the XEN case
>  * cleans up the boot time page table in the x86_64 case

the description is wrong: you swapped x86_32 and x86_64 here


> pagetable_setup_done:
>  * it is a nop on x86_32
>  * sets up accessor functions for pagetable manipulation, for the
>    XEN case
>  * it is a nop on x86_64
> 
> Most of this logic can be skipped by creating a new PVOPS that can handle
> pagetable setup and pre/post operations on it.
> The new PVOPS must be called only once, during boot-time setup and
> after the direct mapping for physical memory is available.
> 
> Attilio Rao (5):
>   XEN: Remove the base argument from
>     x86_init.paging.pagetable_setup_done PVOPS
>   XEN: Remove the base argument from
>     x86_init.paging.pagetable_setup_start PVOPS
>   X86/XEN: Introduce the x86_init.paging.pagetable_init() PVOPS
>   X86/XEN: Retire now unused x86_init.paging.pagetable_setup_start and
>     x86_init.paging.pagetable_setup_done PVOPS
>   X86/XEN: Add few lines explaining simple semantic for
>     x86_init.paging.pagetable_init PVOPS
> 
>  arch/x86/include/asm/pgtable_types.h |    6 ++----
>  arch/x86/include/asm/x86_init.h      |   11 +++++++----
>  arch/x86/kernel/setup.c              |    4 +---
>  arch/x86/kernel/x86_init.c           |    4 +---
>  arch/x86/mm/init_32.c                |   12 ++++++------
>  arch/x86/xen/mmu.c                   |   18 +++++++-----------
>  6 files changed, 24 insertions(+), 31 deletions(-)
> 
> -- 
> 1.7.2.5
> 
