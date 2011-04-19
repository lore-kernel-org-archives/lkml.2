Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020Ab1DSVk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:40:28 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:46764 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752382Ab1DSVk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:40:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=AF+0iX71KKIAA8+YSZcpeo+rMyFvC+3yMOdDz736VKFKSJm8hJuXCHllRzKpyr8zi8sGe8s15qYEm6P+NslcISgDwgida9gIVrD04lTWZpOp3Knrfo1S0R4CKF8ZP9pk;
Date: Tue, 19 Apr 2011 14:40:23 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: pugs@ieee.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        qemu-devel@nongnu.org, chrisw@redhat.com, aafabbri@cisco.com,
        dwang2@cisco.com, benve@cisco.com
Subject: Re: [PATCH] vfio: Add an ioctl to reset the device
Message-Id: <20110419144023.4d3f61da.rdunlap@xenotime.net>
In-Reply-To: <20110419203234.4254.94914.stgit@s20.home>
References: <20110419203234.4254.94914.stgit@s20.home>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 14:32:59 -0600 Alex Williamson wrote:

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

I can't find include/linux/vfio.h in linux-next or mainline git, but
ioctls need to be documented in Documentation/ioctl/ioctl-number.txt....

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
