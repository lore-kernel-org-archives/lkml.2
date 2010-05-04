Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab0EDPD1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:03:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25754 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199Ab0EDPDX (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 4 May 2010 11:03:23 -0400
Date: Tue, 4 May 2010 11:02:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com, tglx@linutronix.de, prarit@redhat.com
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [LKML] [tip:x86/urgent] x86: Fix NULL pointer access in
	irq_force_complete_move() for Xen guests
Message-ID: <20100504150259.GB5667@phenom.dumpdata.com>
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com> <tip-bbd391a15d82e14efe9d69ba64cadb855b061dba@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-bbd391a15d82e14efe9d69ba64cadb855b061dba@git.kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090206.4BE0372E.004E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 30, 2010 at 09:36:42PM +0000, tip-bot for Prarit Bhargava wrote:
> Commit-ID:  bbd391a15d82e14efe9d69ba64cadb855b061dba
> Gitweb:     http://git.kernel.org/tip/bbd391a15d82e14efe9d69ba64cadb855b061dba
> Author:     Prarit Bhargava <prarit@redhat.com>
> AuthorDate: Tue, 27 Apr 2010 11:24:42 -0400
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Fri, 30 Apr 2010 14:31:38 -0700
> 
> x86: Fix NULL pointer access in irq_force_complete_move() for Xen guests
> 
> Upstream PV guests fail to boot because of a NULL pointer in
> irq_force_complete_move().  It is possible that xen guests have
> irq_desc->chip_data = NULL.
> 
> Test for NULL chip_data pointer before attempting to complete an irq move.
> 
> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
> LKML-Reference: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com>
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

> Cc: <stable@kernel.org> [2.6.33]
> ---
>  arch/x86/kernel/apic/io_apic.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
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
