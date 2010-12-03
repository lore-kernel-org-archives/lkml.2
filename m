Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab0LCXRr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 18:17:47 -0500
Received: from kroah.org ([198.145.64.141]:41920 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884Ab0LCXRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 18:17:46 -0500
Date: Fri, 3 Dec 2010 14:52:17 -0800
From: Greg KH <greg@kroah.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: stable@kernel.org, David Airlie <airlied@linux.ie>,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [stable] [PATCH] [Stable] agp/intel: complete the enablement
 for B43.1
Message-ID: <20101203225217.GB15457@kroah.com>
References: <1289555843-6425-1-git-send-email-ike.pan@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289555843-6425-1-git-send-email-ike.pan@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 05:57:23PM +0800, Ike Panhc wrote:
> This patch completes the missing part of commit 41a514 and 3dde04b and I think
> commit 3dde04b is already in queue for next stable release.
> 
> Thanks Chris Wilson has the patch for enabling Intel B43.1 and backports it to
> stable kernel. On mainline commit 210b23 and 1a997ff the way to detect gtt size
> is changed, but these two commits landed on mainline kernel after .36 kernel
> released. So that mainline kernel works fine on B43.1 machine but not stable
> kernel.
> 
> Without this patch, X fails to start on 2.6.35.y kernel. After patched, X
> starts.
> 
> This patch is made for 2.6.35.y and I believe it suits for 2.6.36.y.
> 
> Signed-off-by: Ike Panhc <ike.pan@canonical.com>

I don't understand, is this patch upstream already?  If so, what is git
git commit id for it?  If not, why not?

confused,

greg k-h

> ---
>  drivers/char/agp/intel-agp.h |    1 +
>  drivers/char/agp/intel-gtt.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/agp/intel-agp.h b/drivers/char/agp/intel-agp.h
> index bc9a4ad..cdefd47 100644
> --- a/drivers/char/agp/intel-agp.h
> +++ b/drivers/char/agp/intel-agp.h
> @@ -241,6 +241,7 @@
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_GM45_HB || \
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_G41_HB || \
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_B43_HB || \
> +		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_B43_1_HB || \
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB || \
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB || \
>  		agp_bridge->dev->device == PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB || \
> diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
> index ed11c77..c35361c 100644
> --- a/drivers/char/agp/intel-gtt.c
> +++ b/drivers/char/agp/intel-gtt.c
> @@ -1338,6 +1338,7 @@ static void intel_i965_get_gtt_range(int *gtt_offset, int *gtt_size)
>  	case PCI_DEVICE_ID_INTEL_G45_HB:
>  	case PCI_DEVICE_ID_INTEL_G41_HB:
>  	case PCI_DEVICE_ID_INTEL_B43_HB:
> +	case PCI_DEVICE_ID_INTEL_B43_1_HB:
>  	case PCI_DEVICE_ID_INTEL_IRONLAKE_D_HB:
>  	case PCI_DEVICE_ID_INTEL_IRONLAKE_M_HB:
>  	case PCI_DEVICE_ID_INTEL_IRONLAKE_MA_HB:
> -- 
> 1.7.1
> 
> _______________________________________________
> stable mailing list
> stable@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable
