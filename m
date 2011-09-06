Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1IFPGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:06:38 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:34787 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab1IFPGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:06:34 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH] arm: omap: Fix build error in ispccdc.c
Date: Tue, 6 Sep 2011 17:06:23 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.3-gentoo; KDE/4.7.0; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1315317735-5255-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1315317735-5255-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109061706.26776.laurent.pinchart@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Tuesday 06 September 2011 16:02:15 Joerg Roedel wrote:
> The following build error occurs with 3.1-rc5:
>
>   CC      drivers/media/video/omap3isp/ispccdc.o
> /home/data/repos/linux.trees.git/drivers/media/video/omap3isp/ispccdc.c: In
> function 'ccdc_lsc_config':
> /home/data/repos/linux.trees.git/drivers/media/video/omap3isp/ispccdc.c:42
> 7:2: error: implicit declaration of function 'kzalloc'
> [-Werror=implicit-function-declaration]
> /home/data/repos/linux.trees.git/drivers/media/video/omap3isp/ispccdc.c:42
> 7:6: warning: assignment makes pointer from integer without a cast [enabled
> by default]
> 
> This patch adds the missing 'linux/slab.h' include to fix the problem.

Thanks for the patch.

> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: linux-media@vger.kernel.org
> Cc: linux-omap@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Mauro, can you please pick this patch and push it to v3.1 ?

> ---
>  drivers/media/video/omap3isp/ispccdc.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/media/video/omap3isp/ispccdc.c
> b/drivers/media/video/omap3isp/ispccdc.c index 9d3459d..80796eb 100644
> --- a/drivers/media/video/omap3isp/ispccdc.c
> +++ b/drivers/media/video/omap3isp/ispccdc.c
> @@ -31,6 +31,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/mm.h>
>  #include <linux/sched.h>
> +#include <linux/slab.h>
>  #include <media/v4l2-event.h>
> 
>  #include "isp.h"

-- 
Regards,

Laurent Pinchart
