Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2GFJU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 05:20:58 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50664 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072Ab2GFJUz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 05:20:55 -0400
Date: Fri, 6 Jul 2012 10:50:36 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH 03/28] x86/irq: Use irq_remap specific print_IO_APIC
 paths only on Intel
Message-ID: <20120706085036.GB24449@gmail.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
 <1341491808-23083-4-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341491808-23083-4-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joerg.roedel@amd.com> wrote:

> The VT-d IOMMU requires a special setup of the IO-APIC to
> remap its interrupts. Therefore the print_IO_APIC routine
> has seperate code paths to accout for that and print out the
> special setup. This is not required on AMD IOMMU systems, so
> make these path really Intel specific.
> 
> Cc: x86@kernel.org
> Cc: Yinghai Lu <yinghai@kernel.org>
> Cc: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> ---
>  arch/x86/include/asm/irq_remapping.h |    2 ++
>  arch/x86/kernel/apic/io_apic.c       |    4 ++--
>  drivers/iommu/intel_irq_remapping.c  |    2 ++
>  drivers/iommu/irq_remapping.c        |    1 +
>  4 files changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
> index 5fb9bbb..228d5e5 100644
> --- a/arch/x86/include/asm/irq_remapping.h
> +++ b/arch/x86/include/asm/irq_remapping.h
> @@ -27,6 +27,7 @@
>  #ifdef CONFIG_IRQ_REMAP
>  
>  extern int irq_remapping_enabled;
> +extern int intel_irq_remap_debug;

Sigh.

Instead of yet another set of global flags thrown around the 
kernel please properly factor out this code, its data structures 
and methods: introduce a single descriptor structure that 
describes this piece of hardware, with debugging flags part of 
this structure - with operations function pointer structure and 
such.

This code came from the "we have a single, known type of system 
global IOMMU" world - and we now want to transform this into 
something that is properly abstracted out and made flexible, as 
we extend its capabilities .

Thanks,

	Ingo
