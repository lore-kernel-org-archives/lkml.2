Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab0JLQxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 12:53:00 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60547 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab0JLQw7 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 12 Oct 2010 12:52:59 -0400
Date: Tue, 12 Oct 2010 12:52:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: stefano.stabellini@eu.citrix.com, len.brown@intel.com, pavel@ucw.cz,
        rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jeremy@goop.org, Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH v4 5/7] xen: add xen hvm acpi_register_gsi variant
Message-ID: <20101012165207.GA26934@dumpdata.com>
References: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop>
 <1286901289-8156-5-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286901289-8156-5-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Len, Pavel, Rafael,

Stefano forgot to put you guys as CC. Is this patch OK with
you guys? The full link for the patchset is: http://lkml.org/lkml/2010/10/12/246

On Tue, Oct 12, 2010 at 05:34:47PM +0100, stefano.stabellini@eu.citrix.com wrote:
> From: Jeremy Fitzhardinge <jeremy@goop.org>
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/include/asm/acpi.h |    3 +++
>  arch/x86/kernel/acpi/boot.c |    3 ++-
>  arch/x86/pci/xen.c          |    6 ++++++
>  3 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
> index 92091de..55d106b 100644
> --- a/arch/x86/include/asm/acpi.h
> +++ b/arch/x86/include/asm/acpi.h
> @@ -93,6 +93,9 @@ extern u8 acpi_sci_flags;
>  extern int acpi_sci_override_gsi;
>  void acpi_pic_sci_set_trigger(unsigned int, u16);
>  
> +extern int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
> +				  int trigger, int polarity);
> +
>  static inline void disable_acpi(void)
>  {
>  	acpi_disabled = 1;
> diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
> index 031f0c2..71232b9 100644
> --- a/arch/x86/kernel/acpi/boot.c
> +++ b/arch/x86/kernel/acpi/boot.c
> @@ -537,7 +537,8 @@ static int acpi_register_gsi_ioapic(struct device *dev, u32 gsi,
>  	return gsi;
>  }
>  
> -static int (*__acpi_register_gsi)(struct device *dev, u32 gsi, int trigger, int polarity) = acpi_register_gsi_pic;
> +int (*__acpi_register_gsi)(struct device *dev, u32 gsi,
> +			   int trigger, int polarity) = acpi_register_gsi_pic;
>  
>  /*
>   * success: return IRQ number (>=0)
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index e7f897b..ef9b8b2 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -53,6 +53,12 @@ static int xen_hvm_register_pirq(u32 gsi, int triggering)
>  
>  	return irq;
>  }
> +
> +static int acpi_register_gsi_xen_hvm(struct device *dev, u32 gsi,
> +				 int trigger, int polarity)
> +{
> +	return xen_hvm_register_pirq(gsi, trigger);
> +}
>  #endif
>  
>  #if defined(CONFIG_PCI_MSI)
> -- 
> 1.5.6.5
