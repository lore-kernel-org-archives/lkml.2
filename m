Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032462Ab2CPANC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 20:13:02 -0400
Received: from mga14.intel.com ([143.182.124.37]:57542 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1032236Ab2CPAM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 20:12:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="78159963"
Subject: Re: [PATCH] Added separate apic_id_valid() functions for selected
 apic drivers
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Steffen Persvold <sp@numascale.com>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Yinghai Lu <yinghai@kernel.org>, Jack Steiner <steiner@sgi.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Date: Thu, 15 Mar 2012 17:13:47 -0700
In-Reply-To: <1331856461-5804-1-git-send-email-sp@numascale.com>
References: <1331852692.16101.30.camel@sbsiddha-desk.sc.intel.com>
	 <1331856461-5804-1-git-send-email-sp@numascale.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1331856827.16101.33.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-16 at 01:07 +0100, Steffen Persvold wrote:
> diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
> index 1c1c4f4..7efd0c6 100644
> --- a/arch/x86/mm/srat.c
> +++ b/arch/x86/mm/srat.c
> @@ -69,12 +69,6 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
>  	if ((pa->flags & ACPI_SRAT_CPU_ENABLED) == 0)
>  		return;
>  	pxm = pa->proximity_domain;
> -	apic_id = pa->apic_id;
> -	if (!cpu_has_x2apic && (apic_id >= 0xff)) {

not sure why you removed this. Shouldn't this be replaced with
apic->apic_id_valid() check?

thanks.

> -		printk(KERN_INFO "SRAT: PXM %u -> X2APIC 0x%04x ignored\n",
> -			 pxm, apic_id);
> -		return;
> -	}
>  	node = setup_node(pxm);
>  	if (node < 0) {
>  		printk(KERN_ERR "SRAT: Too many proximity domains %x\n", pxm);
> @@ -82,6 +76,7 @@ acpi_numa_x2apic_affinity_init(struct acpi_srat_x2apic_cpu_affinity *pa)
>  		return;
>  	}
>  
> +	apic_id = pa->apic_id;
>  	if (apic_id >= MAX_LOCAL_APIC) {
>  		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
>  		return;


