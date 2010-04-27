Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0D0RAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:00:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49430 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0D0RAI (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 27 Apr 2010 13:00:08 -0400
Date: Tue, 27 Apr 2010 12:58:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Subject: Re: [LKML] [PATCH] Fix NULL pointer for Xen guests
Message-ID: <20100427165816.GA24707@phenom.dumpdata.com>
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BD717D8.00D4:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 11:24:42AM -0400, Prarit Bhargava wrote:
> Upstream PV guests fail to boot because of a NULL pointer.  It is possible that
> xen guests have irq_desc->chip_data = NULL.

Can you provide a short example of test scenario? As in what I should do
to reproduce this problem?
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
