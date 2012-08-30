Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab2H3XWV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 19:22:21 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:10877
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752889Ab2H3XWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 19:22:19 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -11
X-BigFish: VPS-11(zz98dI1818P1432I4015Izz1202hzzz2dh668h839h944hd25hd2bhf0ah107ah1220h1155h)
X-WSS-ID: 0M9LCWZ-01-35H-02
X-M-MSG: 
Date: Thu, 30 Aug 2012 18:22:09 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        <linux-kernel@vger.kernel.org>, <andreas.hermann3@amd.com>,
        <borislav.petkov@amd.com>
Subject: Re: [PATCH 0/8] x86, mm: init_memory_mapping cleanup
Message-ID: <20120830232203.GA15056@jshin-Toonie>
References: <2e8c14cd-b82a-49e6-8d5e-85dbe86da6ca@email.android.com>
 <1346367975-6446-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1346367975-6446-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 04:06:07PM -0700, Yinghai Lu wrote:
> Only create mapping for E820_820 and E820_RESERVED_KERN.
> 
> Also seperate find_early_page_table out with init_memory_mapping.
> 
> Jacob Shin (3):
>   x86: if kernel .text .data .bss are not marked as E820_RAM, complain
>     and fix
>   x86: Fixup code testing if a pfn is direct mapped
>   x86: Only direct map addresses that are marked as E820_RAM
> 
> Yinghai Lu (5):
>   x86, mm: Add global page_size_mask
>   x86, mm: Split out split_mem_range
>   x86, mm: Moving init_memory_mapping calling
>   x86, mm: Revert back good_end setting for 64bit
>   x86, mm: Find early page table only one time
> 
>  arch/x86/include/asm/init.h       |    1 -
>  arch/x86/include/asm/page_types.h |    3 +
>  arch/x86/include/asm/pgtable.h    |    1 +
>  arch/x86/kernel/cpu/amd.c         |    8 +-
>  arch/x86/kernel/setup.c           |   34 ++++---
>  arch/x86/mm/init.c                |  225 ++++++++++++++++++++++++++-----------
>  arch/x86/mm/init_64.c             |    6 +-
>  arch/x86/platform/efi/efi.c       |    8 +-
>  8 files changed, 191 insertions(+), 95 deletions(-)
> 
> -- 
> 1.7.7
> 
> 

I'll be out of office tomorrow, and Monday is a holiday, so I'll test it
on our machines on Tuesday,

Thanks,

-Jacob

