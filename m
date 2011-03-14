Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab1CNTi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:38:58 -0400
Received: from kroah.org ([198.145.64.141]:38748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab1CNTi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:38:57 -0400
Date: Mon, 14 Mar 2011 12:33:33 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: Re: [PATCH 10/21] Staging: hv: Cleanup root device handling
Message-ID: <20110314193333.GA18944@kroah.com>
References: <1299794886-1200-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299794886-1200-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 02:08:06PM -0800, K. Y. Srinivasan wrote:
> Now we can complete the cleanup of the root device
> management. Use the preferred APIs for creating and
> managing the root device. As part of this cleanup get rid
> of the root device object from vmbus_driver_context.

I don't understand, what is the "root device"?

The hyper-v "bus controller"?

> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
> Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> ---
>  drivers/staging/hv/vmbus_drv.c |  126 ++++++----------------------------------
>  1 files changed, 18 insertions(+), 108 deletions(-)
> 
> diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> index b473f46..8b9394a 100644
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -19,6 +19,7 @@
>   *   Hank Janssen  <hjanssen@microsoft.com>
>   */
>  #include <linux/init.h>
> +#include <linux/err.h>
>  #include <linux/module.h>
>  #include <linux/device.h>
>  #include <linux/irq.h>
> @@ -40,6 +41,8 @@
>  #define VMBUS_IRQ		0x5
>  #define VMBUS_IRQ_VECTOR	IRQ5_VECTOR
>  
> +static struct device *root_dev; /* Root device */

This shouldn't be a "raw" struct device, should it?  It should be of a
type that shows exactly what it is.  Is it a hyper_v device that talks
on the bus?

Or is it a "platform" device that controls all of the devices on the
bus, and as such should be the "root" device of the bus tree?

confused,

greg k-h
