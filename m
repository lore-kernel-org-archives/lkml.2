Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab1DSX2X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 19:28:23 -0400
Received: from qmta12.emeryville.ca.mail.comcast.net ([76.96.27.227]:56291
	"EHLO qmta12.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab1DSX2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 19:28:22 -0400
X-Greylist: delayed 348 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Apr 2011 19:28:22 EDT
From: Tom Lyon <pugs@lyon-about.com>
Reply-To: pugs@ieee.org
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio: Add an ioctl to reset the device
Date: Tue, 19 Apr 2011 16:23:05 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: pugs@ieee.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        qemu-devel@nongnu.org, chrisw@redhat.com, aafabbri@cisco.com,
        dwang2@cisco.com, benve@cisco.com
References: <20110419203234.4254.94914.stgit@s20.home>
In-Reply-To: <20110419203234.4254.94914.stgit@s20.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191623.06156.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 19, 2011 01:32:59 pm Alex Williamson wrote:
> When using VFIO to assign a device to a guest, we want to make sure
> the device is quiesced on VM reset to stop all DMA within the guest
> mapped memory.  Add an ioctl which just calls pci_reset_function()
> and returns whether it succeeds.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
> We've recently needed to add this functionality for current KVM
> based device assignment, VFIO should provide a way to do this too.
> An example of it being used in the Qemu VFIO driver can be found
> here:
> 
> https://github.com/awilliam/qemu-vfio/blob/vfio/hw/vfio.c
> 
>  drivers/vfio/vfio_main.c |    4 ++++
>  include/linux/vfio.h     |    3 +++
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
> index 7e427fc..b9bb692 100644
> --- a/drivers/vfio/vfio_main.c
> +++ b/drivers/vfio/vfio_main.c
> @@ -490,6 +490,10 @@ static long vfio_unl_ioctl(struct file *filep,
>  		ret = vfio_irq_eoi_eventfd(vdev, fd);
>  		break;
> 
> +	case VFIO_RESET_FUNCTION:
> +		ret = pci_reset_function(vdev->pdev);
> +		break;
> +
>  	default:
>  		return -EINVAL;
>  	}
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index f07d8fe..47d9bb9 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -215,6 +215,9 @@ struct vfio_dma_map {
>  /* Re-enable INTx via eventfd */
>  #define	VFIO_IRQ_EOI_EVENTFD	_IOW(';', 110, int)
> 
> +/* Reset PCI function */
> +#define VFIO_RESET_FUNCTION	_IO(';', 111)
> +
>  /*
>   * Reads, writes, and mmaps determine which PCI BAR (or config space)
>   * from the high level bits of the file offset

Applied.
