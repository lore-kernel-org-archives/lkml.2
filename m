Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329Ab2DYBnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 21:43:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:4549 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab2DYBm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 21:42:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92766390"
Subject: Re: [PATCH v2 1/1] x86: Use x2apic physical mode based on FADT
 setting
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Greg Pearson <greg.pearson@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Date: Tue, 24 Apr 2012 18:45:45 -0700
In-Reply-To: <1335313436-32020-1-git-send-email-greg.pearson@hp.com>
References: <1335313436-32020-1-git-send-email-greg.pearson@hp.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1335318345.28674.268.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-24 at 18:23 -0600, Greg Pearson wrote:
> Provide systems that do not support x2apic cluster mode
> a mechanism to select x2apic physical mode using the
> FADT FORCE_APIC_PHYSICAL_DESTINATION_MODE bit.
> 
> Changes from v1: (based on Suresh's comments)
> - removed #ifdef CONFIG_ACPI
> - removed #include <linux/acpi.h>
> 
> Signed-off-by: Greg Pearson <greg.pearson@hp.com>
> ---
>  arch/x86/kernel/apic/x2apic_phys.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/apic/x2apic_phys.c b/arch/x86/kernel/apic/x2apic_phys.c
> index 8a778db..991e315 100644
> --- a/arch/x86/kernel/apic/x2apic_phys.c
> +++ b/arch/x86/kernel/apic/x2apic_phys.c
> @@ -24,6 +24,12 @@ static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
>  {
>  	if (x2apic_phys)
>  		return x2apic_enabled();
> +	else if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
> +		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL) &&
> +		x2apic_enabled()) {
> +		printk(KERN_DEBUG "System requires x2apic physical mode\n");
> +		return 1;
> +	}
>  	else
>  		return 0;
>  }

Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

