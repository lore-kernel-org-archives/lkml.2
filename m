Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab1GGK6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 06:58:44 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57405 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755513Ab1GGK6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 06:58:43 -0400
Date: Thu, 7 Jul 2011 12:58:22 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: Re: [git pull] IOMMU updates for 3.1
Message-ID: <20110707105822.GA8227@elte.hu>
References: <20110707085359.GC1956@amd.com>
 <20110707094558.GB15058@elte.hu>
 <20110707105204.GE1956@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110707105204.GE1956@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roedel, Joerg <Joerg.Roedel@amd.com> wrote:

> On Thu, Jul 07, 2011 at 05:45:58AM -0400, Ingo Molnar wrote:
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git iommu-3.1
> > Fails to build with INTR_REMAP=y && CONFIG_DMAR=n:
> > 
> >  arch/x86/built-in.o: In function `lapic_resume':
> >  apic.c:(.text+0x16329): undefined reference to `intr_remapping_enabled'
> >  apic.c:(.text+0x1651d): undefined reference to `intr_remapping_enabled'
> >  apic.c:(.text+0x1652b): undefined reference to `reenable_intr_remapping'
> >  [...]
> 
> Fixed with:
> 
> commit 6b385b46ee17d7e1a68d3411b8cdb2342e0f0445
> Author: Joerg Roedel <joerg.roedel@amd.com>
> Date:   Thu Jul 7 12:18:48 2011 +0200
> 
>     iommu/core: Fix build with INTR_REMAP=y && CONFIG_DMAR=n
>     
>     IOMMU_API is not selected when no DMA remapping driver is
>     selected, but the whole drivers/iommu/ directory is only
>     built with IOMMU_API=y. Fixed with this patch by including
>     the directory with IOMMU_SUPPORT instead.
>     
>     Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Next time around please add a Reported-by line ...

Anyway, i pulled it and started testing it.

Thanks,

	Ingo
