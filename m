Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab1EDTSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:18:22 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:51880
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753941Ab1EDTSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:18:20 -0400
From: Tom Lyon <pugs@lyon-about.com>
Reply-To: pugs@ieee.org
To: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] vfio: Fix free in dma mapping error path
Date: Wed, 4 May 2011 12:19:07 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-desktop; KDE/4.4.4; x86_64; ; )
Cc: pugs@ieee.org, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        qemu-devel@nongnu.org, chrisw@redhat.com
References: <20110429220534.10316.63083.stgit@s20.home>
In-Reply-To: <20110429220534.10316.63083.stgit@s20.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201105041219.07488.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 29, 2011 03:05:54 pm Alex Williamson wrote:
> This is allocated via vmalloc, so needs vfree, not kfree.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
> 
>  drivers/vfio/vfio_dma.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/vfio/vfio_dma.c b/drivers/vfio/vfio_dma.c
> index cee1a25..4a488b6 100644
> --- a/drivers/vfio/vfio_dma.c
> +++ b/drivers/vfio/vfio_dma.c
> @@ -322,7 +322,7 @@ int vfio_dma_map_common(struct vfio_listener *listener,
>  	if (ret != npage) {
>  		printk(KERN_ERR "%s: get_user_pages_fast returns %d, not %d\n",
>  			__func__, ret, npage);
> -		kfree(pages);
> +		vfree(pages);
>  		ret = -EFAULT;
>  		goto out_lock;
>  	}
Applied. Thanks.
