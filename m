Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934469Ab2HWVLq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:11:46 -0400
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54692 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934412Ab2HWVLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:11:43 -0400
Date: Thu, 23 Aug 2012 23:11:40 +0200
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, joro@8bytes.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH 03/19] x86, io_apic: Introduce x86_io_apic_ops.disable()
Message-ID: <20120823211140.GB7120@breakpoint.cc>
References: <1345470965-24410-1-git-send-email-joerg.roedel@amd.com>
 <1345470965-24410-4-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1345470965-24410-4-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 03:55:49PM +0200, Joerg Roedel wrote:
> This function pointer is used to call a system-specific
> function for disabling the IO-APIC. Currently this is used
> for IRQ remapping which has its own disable routine.

What I miss here is the fact that you extract irq-mapping specific bits from
disable_IO_APIC() and put them in a separate function named
irq_remapping_disable_io_apic(). And having a big if in this function probably
didn't look that sexy so you decided to use function op. Nice move, no
question but not abvious from the description here and it took a while to figure
it out based on the code. Well, maybe it is late…

> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> index 283a43f..f72a5e8 100644
> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -17,6 +21,24 @@ int no_x2apic_optout;
<snip>
> +static void __init irq_remapping_modify_x86_ops(void)

I don't want sound to picky here but the term 'modify' is bad I think. Would
'overwrite' fit better here? Is 'modify' used someplace else in x86 so you
follow a common pattern here? Maybe it is just me.

> +{
> +	x86_io_apic_ops.disable	=	irq_remapping_disable_io_apic;
> +}
> +

Sebastian
