Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754981Ab1AJWeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 17:34:16 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:14529 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab1AJWeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 17:34:13 -0500
Date: Mon, 10 Jan 2011 23:34:03 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.37] lpc: irq and pci_ids patch for Intel DH89xxCC
 DeviceIDs
Message-ID: <20110110233403.18264e01@endymion.delvare>
In-Reply-To: <201101101308.37805.seth.heasley@intel.com>
References: <201101101308.37805.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011 13:08:37 -0800, Seth Heasley wrote:
> This patch adds the LPC Controller DeviceIDs for the Intel DH89xxCC PCH.
> 
> The code for capturing ranges of LPC Controller DeviceIDs has also been updated.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.37/include/linux/pci_ids.h.orig	2011-01-04 16:50:19.000000000 -0800
> +++ linux-2.6.37/include/linux/pci_ids.h	2011-01-10 11:23:19.000000000 -0800
> @@ -2469,6 +2469,9 @@
>  #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_SMBUS	0x1d22
>  #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC	0x1d40
> +#define PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN	0x2310
> +#define PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX	0x231f
> +#define PCI_DEVICE_ID_INTEL_DH89XXCC_SMBUS	0x2330
>  #define PCI_DEVICE_ID_INTEL_82801AA_0	0x2410
>  #define PCI_DEVICE_ID_INTEL_82801AA_1	0x2411
>  #define PCI_DEVICE_ID_INTEL_82801AA_3	0x2413
> --- linux-2.6.37/arch/x86/pci/irq.c.orig	2011-01-04 16:50:19.000000000 -0800
> +++ linux-2.6.37/arch/x86/pci/irq.c	2011-01-10 11:31:02.000000000 -0800
> @@ -596,21 +596,18 @@
>  		return 1;
>  	}
>  
> -	if ((device >= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MIN) && 
> -		(device <= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MAX)) {
> +	if ((device >= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MIN && 
> +	     device <= PCI_DEVICE_ID_INTEL_5_3400_SERIES_LPC_MAX) 
> +	||  (device >= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN && 
> +	     device <= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX)
> +	||  (device >= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN &&
> +	     device <= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX)) {
>  		r->name = "PIIX/ICH";
>  		r->get = pirq_piix_get;
>  		r->set = pirq_piix_set;
>  		return 1;
>  	}
>  
> -	if ((device >= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN) && 
> -		(device <= PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX)) {
> -		r->name = "PIIX/ICH";
> -		r->get = pirq_piix_get;
> -		r->set = pirq_piix_set;
> -		return 1;
> -	}
>  	return 0;
>  }
>  

Looks good.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
