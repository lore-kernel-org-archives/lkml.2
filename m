Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab0JNVfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 17:35:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47093 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691Ab0JNVfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 17:35:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: stefano.stabellini@eu.citrix.com
Subject: Re: [PATCH v4 5/7] xen: add xen hvm acpi_register_gsi variant
Date: Thu, 14 Oct 2010 23:34:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        jeremy@goop.org, konrad.wilk@oracle.com,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
References: <alpine.DEB.2.00.1010121121160.2423@kaball-desktop> <1286901289-8156-5-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1286901289-8156-5-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201010142334.24177.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 12, 2010, stefano.stabellini@eu.citrix.com wrote:
> From: Jeremy Fitzhardinge <jeremy@goop.org>
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

I'm not really familiar with Xen, but the patch looks reasonable.

Thanks,
Rafael


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
> 

