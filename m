Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0JGPlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 11:41:03 -0400
Received: from kroah.org ([198.145.64.141]:40115 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752708Ab0JGPkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 11:40:49 -0400
Date: Thu, 7 Oct 2010 08:39:04 -0700
From: Greg KH <greg@kroah.com>
To: tlinder <tlinder@codeaurora.org>
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Wilcox <willy@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/PATCH v2 2/3] usb: usb3.0 ch9 definitions
Message-ID: <20101007153904.GD26129@kroah.com>
References: <1286465076-12503-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286465076-12503-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 05:24:36PM +0200, tlinder wrote:
> Signed-off-by: tlinder <tlinder@codeaurora.org>

I need a "real" name here please.

> ---
>  include/linux/usb/ch9.h |   59 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 57 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
> index da2ed77..20573b2 100644
> --- a/include/linux/usb/ch9.h
> +++ b/include/linux/usb/ch9.h
> @@ -123,8 +123,23 @@
>  #define USB_DEVICE_A_ALT_HNP_SUPPORT	5	/* (otg) other RH port does */
>  #define USB_DEVICE_DEBUG_MODE		6	/* (special devices only) */
>  
> +/**

What's this '**' for?

> + * New Feature Selectors as added by USB 3.0
> + * See USB 3.0 spec Table 9-6
> + */
> +#define USB_DEVICE_U1_ENABLE	48	/* dev may initiate U1 transition */
> +#define USB_DEVICE_U2_ENABLE	49	/* dev may initiate U2 transition*/
> +#define USB_DEVICE_LTM_ENABLE	50	/* dev may send LTM*/
> +#define USB_INTRF_FUNC_SUSPEND	0	/* function suspend*/
> +
> +#define USB_INTR_FUNC_SUSPEND_OPT_MASK	0xFF00
> +
>  #define USB_ENDPOINT_HALT		0	/* IN/OUT will STALL */
>  
> +/* Bit array elements as returned by the USB_REQ_GET_STATUS request. */
> +#define USB_DEV_STAT_U1_ENABLED		2	/* transition into U1 state */
> +#define USB_DEV_STAT_U2_ENABLED		3	/* transition into U2 state */
> +#define USB_DEV_STAT_LTM_ENABLED	4	/* Latency tolerance messages*/
>  
>  /**
>   * struct usb_ctrlrequest - SETUP data for a USB device control request
> @@ -675,6 +690,7 @@ struct usb_bos_descriptor {
>  	__u8  bNumDeviceCaps;
>  } __attribute__((packed));
>  
> +#define USB_DT_BOS_SIZE		5
>  /*-------------------------------------------------------------------------*/
>  
>  /* USB_DT_DEVICE_CAPABILITY:  grouped with BOS */
> @@ -712,16 +728,55 @@ struct usb_wireless_cap_descriptor {	/* Ultra Wide Band */
>  	__u8  bReserved;
>  } __attribute__((packed));
>  
> +/* USB 2.0 Extension descriptor */
>  #define	USB_CAP_TYPE_EXT		2
> -

Why delete this line?

Clean this up and I can take this type of change now.

thanks,

greg k-h
