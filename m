Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934650Ab2J3VOc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 17:14:32 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:37952 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934577Ab2J3VOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 17:14:31 -0400
Date: Tue, 30 Oct 2012 17:01:59 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, tony.luck@intel.com, fenghua.yu@intel.com,
        len.brown@intel.com, rjw@sisk.pl, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 1/2] ACPI, x86: export acpi_[un]register_gsi()
Message-ID: <20121030210159.GB21481@phenom.dumpdata.com>
References: <1351502792-13221-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351502792-13221-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 11:26:31AM +0200, Mika Westerberg wrote:
> From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> 
> These functions might be called from modules as well so make sure they are
> exported. In addition we implement empty version of acpi_unregister_gsi() and
> remove the one from pci_irq.c.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
> Although there are no modules that use this currently, we are working on
> ACPI 5 device enumeration support that is going to use these functions and
> some of that code can be compiled as a module.
> 
>  arch/x86/kernel/acpi/boot.c | 6 ++++++
>  drivers/acpi/pci_irq.c      | 5 -----
>  2 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index e651f7a..2616d2b 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -574,6 +574,12 @@ int acpi_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
>  
>  	return irq;
>  }
> +EXPORT_SYMBOL(acpi_register_gsi);

_GPL ?
> +
> +void acpi_unregister_gsi(u32 gsi)
> +{
> +}
> +EXPORT_SYMBOL(acpi_unregister_gsi);
>  
>  void __init acpi_set_irq_model_pic(void)
>  {
> diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
> index 0eefa12..1be25a5 100644
> --- a/drivers/acpi/pci_irq.c
> +++ b/drivers/acpi/pci_irq.c
> @@ -495,11 +495,6 @@ int acpi_pci_irq_enable(struct pci_dev *dev)
>  	return 0;
>  }
>  
> -/* FIXME: implement x86/x86_64 version */
> -void __attribute__ ((weak)) acpi_unregister_gsi(u32 i)
> -{
> -}
> -
>  void acpi_pci_irq_disable(struct pci_dev *dev)
>  {
>  	struct acpi_prt_entry *entry;
> -- 
> 1.7.12.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
