Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab2EHJJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 05:09:55 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45658 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab2EHJJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 05:09:52 -0400
Date: Tue, 8 May 2012 11:09:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: joro@8bytes.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH 2/3] irq_remap: fix the UP build failure
Message-ID: <20120508090945.GC27323@gmail.com>
References: <20120508035153.GA30652@gmail.com>
 <1336460934-23592-2-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1336460934-23592-2-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Suresh Siddha <suresh.b.siddha@intel.com> wrote:

> Fix the below UP build failure with CONFIG_IRQ_REMAP enabled.
> 
>  drivers/iommu/intel_irq_remapping.c:955:19: error: ‘struct irq_data’ has no member named ‘affinity’

hm:

> +++ b/drivers/iommu/intel_irq_remapping.c
> +#ifdef CONFIG_SMP
> +#endif
> +#ifdef CONFIG_SMP
> +#endif
> +#ifdef CONFIG_SMP
> +#endif
> +#ifdef CONFIG_SMP
> +#endif

Adding this many #ifdefs is a bit sad. Could we not make the UP 
side have the (supposedly zero length!) affinity cpumask 
instead, or so, and make sure that the SMP functions compile to 
something sensible on UP?

Thanks,

	Ingo
