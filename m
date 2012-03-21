Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab2CUKed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 06:34:33 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:35847 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904Ab2CUKec convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 06:34:32 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>, linux-mm@kvack.org,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH 05/16] mm/drivers: use vm_flags_t for vma flags
Date: Wed, 21 Mar 2012 11:34:56 +0100
Message-ID: <3319224.gEMkjEgmG9@avalon>
User-Agent: KMail/4.8.0 (Linux/3.2.1-gentoo-r2; KDE/4.8.0; x86_64; ; )
In-Reply-To: <20120321065633.13852.11903.stgit@zurg>
References: <20120321065140.13852.52315.stgit@zurg> <20120321065633.13852.11903.stgit@zurg>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konstantin,

Thanks for the patch.

On Wednesday 21 March 2012 10:56:33 Konstantin Khlebnikov wrote:
> Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> Cc: linux-media@vger.kernel.org
> Cc: devel@driverdev.osuosl.org
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: "Arve Hjønnevåg" <arve@android.com>
> ---
>  drivers/media/video/omap3isp/ispqueue.h |    2 +-

For the OMAP3 ISP driver,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

>  drivers/staging/android/ashmem.c        |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispqueue.h
> b/drivers/media/video/omap3isp/ispqueue.h index 92c5a12..908dfd7 100644
> --- a/drivers/media/video/omap3isp/ispqueue.h
> +++ b/drivers/media/video/omap3isp/ispqueue.h
> @@ -90,7 +90,7 @@ struct isp_video_buffer {
>  	void *vaddr;
> 
>  	/* For userspace buffers. */
> -	unsigned long vm_flags;
> +	vm_flags_t vm_flags;
>  	unsigned long offset;
>  	unsigned int npages;
>  	struct page **pages;
> diff --git a/drivers/staging/android/ashmem.c
> b/drivers/staging/android/ashmem.c index 9f1f27e..4511420 100644
> --- a/drivers/staging/android/ashmem.c
> +++ b/drivers/staging/android/ashmem.c
> @@ -269,7 +269,7 @@ out:
>  	return ret;
>  }
> 
> -static inline unsigned long calc_vm_may_flags(unsigned long prot)
> +static inline vm_flags_t calc_vm_may_flags(unsigned long prot)
>  {
>  	return _calc_vm_trans(prot, PROT_READ,  VM_MAYREAD) |
>  	       _calc_vm_trans(prot, PROT_WRITE, VM_MAYWRITE) |
> 

-- 
Regards,

Laurent Pinchart

