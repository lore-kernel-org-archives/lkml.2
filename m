Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab2HZSDb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 14:03:31 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:60817 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751087Ab2HZSDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 14:03:30 -0400
Date: Sun, 26 Aug 2012 20:03:23 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 04/19] x86, io_apic: Introduce
 x86_io_apic_ops.print_entries for debugging
Message-ID: <20120826180323.GA3690@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-5-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345470965-24410-5-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:55:50PM +0200, Joerg Roedel wrote:
> This call-back is used to dump IO-APIC entries for debugging
> purposes into the kernel log. VT-d needs a special routine
> for this and will overwrite the default.

Okay, again: code basically does what it did, it has been shifted around and
is now called directly.

> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> index e0b18f3..321db1a 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -617,6 +617,10 @@ static int __init intel_enable_irq_remapping(void)
>  		goto error;
>  
>  	irq_remapping_enabled = 1;
> +
> +	/* VT-d needs a special routine to print IO-APIC entries */
Seriously? That that's why you overwrite it with a different function :)

> +	x86_io_apic_ops.print_entries = intel_ir_io_apic_print_entries;
> +
>  	pr_info("Enabled IRQ remapping in %s mode\n", eim ? "x2apic" : "xapic");
>  
>  	return eim ? IRQ_REMAP_X2APIC_MODE : IRQ_REMAP_XAPIC_MODE;

Sebastian
