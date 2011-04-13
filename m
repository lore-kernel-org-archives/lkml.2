Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab1DMIRl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:17:41 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:37099 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752016Ab1DMIRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:17:37 -0400
Date: Wed, 13 Apr 2011 11:17:33 +0300
From: Felipe Balbi <balbi@ti.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Tatyana Brokhman <tlinder@codeaurora.org>, gregkh@suse.de,
        linux-arm-msm@vger.kernel.org, balbi@ti.com, ablay@codeaurora.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] usb/gadget: cleanup of "Add SuperSpeed support to
 the Gadget Framework"
Message-ID: <20110413081732.GV15130@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20110411175917.GE4018@linutronix.de>
 <1302636896-12717-1-git-send-email-bigeasy@linutronix.de>
 <1302636896-12717-2-git-send-email-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302636896-12717-2-git-send-email-bigeasy@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Apr 12, 2011 at 09:34:52PM +0200, Sebastian Andrzej Siewior wrote:
> style, some endianess fixups
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  drivers/usb/gadget/Kconfig     |    1 -
>  drivers/usb/gadget/composite.c |   62 +++++++++++++++++----------------------
>  include/linux/usb/gadget.h     |    2 +-
>  3 files changed, 28 insertions(+), 37 deletions(-)
> 
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index b4130bc..21429c7 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -609,7 +609,6 @@ config USB_GADGET_SUPERSPEED
>  	boolean "Gadget operating in Super Speed"
>  	depends on USB_GADGET
>  	depends on USB_GADGET_DUALSPEED
> -	default n
>  	help
>  	  Enabling this feature enables Super Speed support in the Gadget
>  	  driver. It means that gadget drivers should provide extra (SuperSpeed)
> diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
> index d5fe1c2..a94b7b7 100644
> --- a/drivers/usb/gadget/composite.c
> +++ b/drivers/usb/gadget/composite.c
> @@ -76,10 +76,7 @@ static char composite_manufacturer[50];
>  /* Default endpoint companion descriptor */
>  static struct usb_ss_ep_comp_descriptor default_ep_comp_desc = {
>  		.bDescriptorType = USB_DT_SS_ENDPOINT_COMP,
> -		.bLength = 0x06,
> -		.bMaxBurst = 0, /* the default is we don't support bursting */
> -		.bmAttributes = 0, /* 2^0 streams supported */
> -		.wBytesPerInterval = 0,
> +		.bLength = sizeof(struct usb_ss_ep_comp_descriptor),

actually, there's a define:

#define USB_DT_SS_EP_COMP_SIZE		6

-- 
balbi
