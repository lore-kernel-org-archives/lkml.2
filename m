Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753927Ab0KBWSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 18:18:21 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:13296 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761Ab0KBWST (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 18:18:19 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EALoq0EyrRN+K/2dsb2JhbACDHp4+caJZii6RYIEigzBzBIRXhX4
X-IronPort-AV: E=Sophos;i="4.58,285,1286150400"; 
   d="scan'208";a="376854509"
From: Tom Lyon <pugs@cisco.com>
Organization: Cisco Systems, Inc.
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio: Extended capability fixes
Date: Tue, 2 Nov 2010 15:18:48 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.3-desktop; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org
References: <20101102050835.2963.63375.stgit@s20.home>
In-Reply-To: <20101102050835.2963.63375.stgit@s20.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201011021518.48756.pugs@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied. Thanks!

On Monday, November 01, 2010 10:08:35 pm Alex Williamson wrote:
> - Virtual channel position gets truncated as a u8
>  - Print the ecap that's unknown, not the last cap we saw
>  - Print actual config offset, which provides enough info to make
>    some sense of the error.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  drivers/vfio/vfio_pci_config.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_pci_config.c
> b/drivers/vfio/vfio_pci_config.c index 8af995d..8304316 100644
> --- a/drivers/vfio/vfio_pci_config.c
> +++ b/drivers/vfio/vfio_pci_config.c
> @@ -410,7 +410,7 @@ static int vfio_msi_cap_len(struct vfio_dev *vdev, u8
> pos) * Determine extended capability length for VC (2 & 9) and
>   * MFVC capabilities
>   */
> -static int vfio_vc_cap_len(struct vfio_dev *vdev, u8 pos)
> +static int vfio_vc_cap_len(struct vfio_dev *vdev, u16 pos)
>  {
>  	struct pci_dev *pdev = vdev->pdev;
>  	u32 dw;
> @@ -580,7 +580,7 @@ int vfio_build_config_map(struct vfio_dev *vdev)
>  				printk(KERN_WARNING
>  					"%s: pci config conflict at %x, "
>  					"caps %x %x\n",
> -					__func__, i, map[pos+i], cap);
> +					__func__, pos+i, map[pos+i], cap);
>  			map[pos+i] = cap;
>  		}
>  		ret = pci_read_config_byte(pdev, pos + PCI_CAP_LIST_NEXT, &pos);
> @@ -683,7 +683,7 @@ int vfio_build_config_map(struct vfio_dev *vdev)
>  		if (len == 0 || len == 0xFF) {
>  			printk(KERN_WARNING
>  				"%s: unknown length for pci ext cap %x\n",
> -				__func__, cap);
> +				__func__, ecap);
>  			len = PCI_CAP_SIZEOF;
>  		}
>  		for (i = 0; i < len; i++) {
> @@ -691,7 +691,7 @@ int vfio_build_config_map(struct vfio_dev *vdev)
>  				printk(KERN_WARNING
>  					"%s: pci config conflict at %x, "
>  					"caps %x %x\n",
> -					__func__, i, map[epos+i], ecap);
> +					__func__, epos+i, map[epos+i], ecap);
>  			map[epos+i] = ecap;
>  		}
