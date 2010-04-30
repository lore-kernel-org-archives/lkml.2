Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab0D3U4M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 16:56:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39788 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753609Ab0D3U4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 16:56:07 -0400
Message-ID: <4BDB43CD.3040505@zytor.com>
Date: Fri, 30 Apr 2010 13:55:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Subject: Re: [PATCH] Fix NULL pointer for Xen guests
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
In-Reply-To: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This looks like it should be tagged stable for 2.6.33.  Is that correct?

	-hpa

On 04/27/2010 08:24 AM, Prarit Bhargava wrote:
> Upstream PV guests fail to boot because of a NULL pointer.  It is possible that
> xen guests have irq_desc->chip_data = NULL.
> 
> Test for NULL chip_data pointer before attempting to complete an irq move.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> 
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 127b871..eb2789c 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -2545,6 +2545,9 @@ void irq_force_complete_move(int irq)
>  	struct irq_desc *desc = irq_to_desc(irq);
>  	struct irq_cfg *cfg = desc->chip_data;
>  
> +	if (!cfg)
> +		return;
> +
>  	__irq_complete_move(&desc, cfg->vector);
>  }
>  #else
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

