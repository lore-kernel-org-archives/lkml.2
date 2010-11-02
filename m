Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970Ab0KBTLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 15:11:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54842 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752399Ab0KBTLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 15:11:34 -0400
Date: Tue, 2 Nov 2010 21:11:08 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: pugs@cisco.com, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] vfio: Extended capability fixes
Message-ID: <20101102191108.GB2744@redhat.com>
References: <20101102050835.2963.63375.stgit@s20.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101102050835.2963.63375.stgit@s20.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 01, 2010 at 11:08:35PM -0600, Alex Williamson wrote:
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
> diff --git a/drivers/vfio/vfio_pci_config.c b/drivers/vfio/vfio_pci_config.c
> index 8af995d..8304316 100644
> --- a/drivers/vfio/vfio_pci_config.c
> +++ b/drivers/vfio/vfio_pci_config.c
> @@ -410,7 +410,7 @@ static int vfio_msi_cap_len(struct vfio_dev *vdev, u8 pos)
>   * Determine extended capability length for VC (2 & 9) and
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

Not related to this patch, but I am surprised checkpatch does not
complain about lack of spaces around + here and elsewhere.
Or does it?

>  		}
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
