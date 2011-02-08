Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab1BHVKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 16:10:20 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:51371 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754047Ab1BHVKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 16:10:19 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=L1o0UYLFHobJXLne2/l/6El2H98qdcyBrqVtfJT2pLhgv1fOpMCUOXiWiZxT+TDS9cZOi2lZsayts6JGT61FT0bnxLXh9VRtebkbQObroK5vWjAbOS9TCInwHBmo9lnj;
Date: Tue, 8 Feb 2011 13:10:15 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        khali@linux-fr.org
Subject: Re: [PATCH 2.6.37] lpc: irq and pci_ids patch for Intel DH89xxCC
 DeviceIDs
Message-ID: <20110208131015.7345a4df@jbarnes-desktop>
In-Reply-To: <201101101308.37805.seth.heasley@intel.com>
References: <201101101308.37805.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.174.193.198 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Jan 2011 13:08:37 -0800
Seth Heasley <seth.heasley@intel.com> wrote:

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

Applied to linux-next, thanks.

It would be cool if you could figure out a way to avoid having to
continually send these sorts of patches for new chipsets as they come
out.  Maybe for stuff newer than a certain date we can just assume PIIX
style interfaces?  Or maybe there's a way to refactor this even more
cleanly?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
