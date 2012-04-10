Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687Ab2DJX1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 19:27:13 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:40051 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676Ab2DJX1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 19:27:11 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 2/2] irq_domain: fix formatting of chip data pointer in virq_debug_show()
To: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, benh@kernel.crashing.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>
In-Reply-To: <1334060743-7901-2-git-send-email-mika.westerberg@linux.intel.com>
References: <1334060743-7901-1-git-send-email-mika.westerberg@linux.intel.com> <1334060743-7901-2-git-send-email-mika.westerberg@linux.intel.com>
Date: Tue, 10 Apr 2012 17:27:08 -0600
Message-Id: <20120410232708.CAC3D3E079B@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012 15:25:43 +0300, Mika Westerberg <mika.westerberg@linux.intel.com> wrote:
> On 32-bit machines reading the /sys/kernel/debug/irq_domain_mapping file
> outputs following:
> 
> virq   hwirq    chip name        chip data           domain name
>     9  0x00000  IO-APIC          0x        c175a0f8  none
>    10  0x00000  IO-APIC          0x        c175a108  none
>    11  0x00000  IO-APIC          0x        c175a118  none
> ...
> 
> which looks a bit funny. Fix that with filling the gap with zeroes instead
> of spaces.
> 
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>

Applied, thanks.

g.

> ---
>  kernel/irq/irqdomain.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
> index 3601f3f..d350c72 100644
> --- a/kernel/irq/irqdomain.c
> +++ b/kernel/irq/irqdomain.c
> @@ -666,7 +666,7 @@ static int virq_debug_show(struct seq_file *m, void *private)
>  			seq_printf(m, "%-15s  ", p);
>  
>  			data = irq_desc_get_chip_data(desc);
> -			seq_printf(m, "0x%16p  ", data);
> +			seq_printf(m, "0x%016lx  ", (unsigned long)data);
>  
>  			if (desc->irq_data.domain && desc->irq_data.domain->of_node)
>  				p = desc->irq_data.domain->of_node->full_name;
> -- 
> 1.7.9.1
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
