Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1CNTjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 15:39:23 -0400
Received: from kroah.org ([198.145.64.141]:38753 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624Ab1CNTi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 15:38:58 -0400
Date: Mon, 14 Mar 2011 12:34:52 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: Re: [PATCH 11/21] Staging: hv: Make vmbus driver a platform pci
 driver
Message-ID: <20110314193452.GB18944@kroah.com>
References: <1299794912-1233-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299794912-1233-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 02:08:32PM -0800, K. Y. Srinivasan wrote:
> Make vmbus driver a platform pci driver. This is
> in preparation to cleaning up irq allocation for this
> driver.

Now wouldn't this be the "root" device that everything else hangs off
of? 

> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
> Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> ---
>  drivers/staging/hv/vmbus_drv.c |   63 +++++++++++++++++++++++-----------------
>  1 files changed, 36 insertions(+), 27 deletions(-)
> 
> diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> index 8b9394a..e4855ac 100644
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -43,6 +43,8 @@
>  
>  static struct device *root_dev; /* Root device */
>  
> +struct pci_dev *hv_pci_dev;

Why do you have 2 different devices here?  Is the root_dev still needed
now?

Still confused,

greg k-h
