Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032542Ab2CPAvK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:51:10 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59193 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032509Ab2CPAvG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:51:06 -0400
MIME-Version: 1.0
In-Reply-To: <1331833191-25779-1-git-send-email-joerg.roedel@amd.com>
References: <1331833191-25779-1-git-send-email-joerg.roedel@amd.com>
Date: Thu, 15 Mar 2012 17:51:04 -0700
X-Google-Sender-Auth: wWSp-z8r32m00vLKlyb5mjYtBek
Message-ID: <CAE9FiQWPicLVgqEQmw9_8CsVaD9N8P_h6g42z7pUSibZBXLq-Q@mail.gmail.com>
Subject: Re: [RFC PATCH 0/9] Introduce irq_remap_ops to x86
From: Yinghai Lu <yinghai@kernel.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2012 at 10:39 AM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> Hi,
>
> in order to implement interrupt remapping using the AMD IOMMU I did some
> refactoring of the current Intel-specific interrupt remapping code. The
> result is posted for comments in this patch-set.
>
> The patch-set basically removes the Intel-specific calls from the X86
> apic and io-apic code and replaces all of them with helper functions
> that use the irq_remap_ops to hook into an implementation specific
> implementation.
>
> I have done basic testing on this patch-set on a VT-d machine with
> interrupt remapping and found no regression so far. But as usual this
> doesn't mean that there is none ;-)
>
> Anyway, since I am on vacation soon I sent out these patches to receive
> all kinds of comments so that I can start over to add the AMD part when
> I am back.
>
> Thanks,
>
>        Joerg
>
> Diffstat:
>
>  arch/ia64/include/asm/intr_remapping.h |    4 +
>  arch/x86/include/asm/intr_remapping.h  |  101 +++
>  arch/x86/include/asm/irq_remapping.h   |   45 --
>  arch/x86/kernel/apic/apic.c            |   20 +-
>  arch/x86/kernel/apic/io_apic.c         |  276 ++-------
>  drivers/iommu/Makefile                 |    2 +-
>  drivers/iommu/amd_iommu_init.c         |  123 +++--
>  drivers/iommu/dmar.c                   |    1 +
>  drivers/iommu/intel-iommu.c            |    1 +
>  drivers/iommu/intel_intr_remapping.c   | 1065 ++++++++++++++++++++++++++++++++
>  drivers/iommu/intr_remapping.c         |  810 +++----------------------
>  drivers/iommu/intr_remapping.h         |   97 +++-
>  include/linux/amd-iommu.h              |    2 +-
>  include/linux/dmar.h                   |   85 ---
>  14 files changed, 1469 insertions(+), 1163 deletions(-)

Yes, it is good clean up for ioapic.c at least.

Acked-by: Yinghai Lu <yinghai@kernel.org>
