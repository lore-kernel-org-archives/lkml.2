Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab2IFQiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 12:38:51 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50178 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762Ab2IFQiu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 12:38:50 -0400
Date: Thu, 6 Sep 2012 09:36:13 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>
Subject: Re: [PATCH RESEND] USB/host: Cleanup unneccessary irq disable code
Message-ID: <20120906163613.GA28140@kroah.com>
References: <27240C0AC20F114CBF8149A2696CBE4A178108@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A178108@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 06, 2012 at 02:00:16AM +0000, Liu, Chuansheng wrote:
> Because the IRQF_DISABLED as the flag is now a NOOP and has been
> deprecated and in hardirq context the interrupt is disabled.
> 
> so in usb/host code:
> Removing the usage of flag IRQF_DISABLED;
> Removing the calling local_irq save/restore actions in irq
> handler usb_hcd_irq();
> 
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
> ---
>  drivers/usb/core/hcd.c       |   15 ---------------
>  drivers/usb/host/ehci-ls1x.c |    2 +-
>  drivers/usb/host/ohci-xls.c  |    2 +-
>  3 files changed, 2 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
> index bc84106..f84ddea 100644
> --- a/drivers/usb/core/hcd.c
> +++ b/drivers/usb/core/hcd.c
> @@ -2153,15 +2153,8 @@ EXPORT_SYMBOL_GPL(usb_bus_start_enum);
>  irqreturn_t usb_hcd_irq (int irq, void *__hcd)
>  {
>         struct usb_hcd          *hcd = __hcd;
> -       unsigned long           flags;
>         irqreturn_t             rc;

All of your whitespace is broken, making this patch impossible to apply.

As I asked before, please fix this.

greg k-h
