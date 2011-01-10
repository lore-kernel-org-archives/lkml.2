Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab1AJTOr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:14:47 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:48217 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1AJTOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:14:45 -0500
Date: Mon, 10 Jan 2011 20:14:30 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 2.6.37] irq: irq and pci_ids patch for Intel DH89xxCC
 DeviceIDs
Message-ID: <20110110201430.7ab599c4@endymion.delvare>
In-Reply-To: <201101101058.13515.seth.heasley@intel.com>
References: <201101101058.13515.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011 10:58:13 -0800, Seth Heasley wrote:
> This patch adds the LPC Controller DeviceIDs for the Intel DH89xxCC PCH.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> 
> --- linux-2.6.37/include/linux/pci_ids.h.orig	2011-01-04 16:50:19.000000000 -0800
> +++ linux-2.6.37/include/linux/pci_ids.h	2011-01-06 14:25:05.000000000 -0800
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
> +++ linux-2.6.37/arch/x86/pci/irq.c	2011-01-06 14:16:00.000000000 -0800
> @@ -611,6 +611,15 @@
>  		r->set = pirq_piix_set;
>  		return 1;
>  	}
> +
> +	if ((device >= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN) &&
> +		(device <= PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX)) {
> +		r->name = "PIIX/ICH";
> +		r->get = pirq_piix_get;
> +		r->set = pirq_piix_set;
> +		return 1;
> +	}
> +

I'm curious why we have separate sections for INTEL_5_3400_SERIES,
INTEL_COUGARPOINT and now INTEL_DH89XXCC? We do the same thing for all
3, so it would make sense to merge the tests to avoid duplicating the
code.

Other than this, the code looks good.

>  	return 0;
>  }


-- 
Jean Delvare
