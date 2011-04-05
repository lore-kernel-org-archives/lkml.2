Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab1DEHe7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 03:34:59 -0400
Received: from kroah.org ([198.145.64.141]:59387 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751273Ab1DEHee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 03:34:34 -0400
Date: Mon, 4 Apr 2011 21:22:30 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>,
        Mike Sterling <mike.sterling@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: Re: [PATCH 04/12] Staging: hv: Rename vmbus_driver_context structure
Message-ID: <20110405042230.GC8090@kroah.com>
References: <1300226527-26933-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-1-git-send-email-kys@microsoft.com>
 <1300226624-27004-2-git-send-email-kys@microsoft.com>
 <1300226624-27004-3-git-send-email-kys@microsoft.com>
 <1300226624-27004-4-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300226624-27004-4-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 03:03:35PM -0700, K. Y. Srinivasan wrote:
> Now that struct vmbus_driver_context is properly
> cleaned up, rename this structure appropriately and
> cleanup the code.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Signed-off-by: Mike Sterling <mike.sterling@microsoft.com>
> Signed-off-by: Abhishek Kane <v-abkane@microsoft.com>
> Signed-off-by: Hank Janssen <hjanssen@microsoft.com>
> ---
>  drivers/staging/hv/vmbus_drv.c |   32 +++++++++++++++-----------------
>  1 files changed, 15 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/staging/hv/vmbus_drv.c b/drivers/staging/hv/vmbus_drv.c
> index 239b91c..f292b03 100644
> --- a/drivers/staging/hv/vmbus_drv.c
> +++ b/drivers/staging/hv/vmbus_drv.c
> @@ -41,7 +41,7 @@
>  struct pci_dev *hv_pci_dev;
>  
>  /* Main vmbus driver data structure */
> -struct vmbus_driver_context {
> +struct hv_bus {
>  	struct bus_type bus;
>  	struct tasklet_struct msg_dpc;
>  	struct tasklet_struct event_dpc;
> @@ -99,7 +99,7 @@ static struct device_attribute vmbus_device_attrs[] = {
>  };
>  
>  /* The one and only one */
> -static struct vmbus_driver_context vmbus_drv = {
> +static struct hv_bus  hv_bus = {

2 spaces?


>  	.bus.name =		"vmbus",
>  	.bus.match =		vmbus_match,
>  	.bus.shutdown =		vmbus_shutdown,

Wait, why is a bus_type embedded within another structure?  That
is going to get pulled out later, right?

thanks,

greg k-h
