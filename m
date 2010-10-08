Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932677Ab0JHRwn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 13:52:43 -0400
Received: from kroah.org ([198.145.64.141]:44783 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932552Ab0JHRwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 13:52:41 -0400
Date: Fri, 8 Oct 2010 10:52:34 -0700
From: Greg KH <greg@kroah.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Wilcox <willy@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] usb: usb3.0 ch9 definitions
Message-ID: <20101008175234.GA25525@kroah.com>
References: <1286544380-27299-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286544380-27299-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 03:26:18PM +0200, Tatyana Brokhman wrote:
> Adding SuperSpeed usb definitions as defined by ch9 of the USB3.0 spec.
> This patch is a preparation for adding SuperSpeed support to the gadget
> framework.
> 
> Signed-off-by: Tatyana Brokhman<tlinder@codeaurora.org>
> ---
>  include/linux/usb/ch9.h |   58 ++++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 57 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
> index da2ed77..d83115e 100644
> --- a/include/linux/usb/ch9.h
> +++ b/include/linux/usb/ch9.h
> @@ -123,8 +123,23 @@
>  #define USB_DEVICE_A_ALT_HNP_SUPPORT	5	/* (otg) other RH port does */
>  #define USB_DEVICE_DEBUG_MODE		6	/* (special devices only) */
>  
> +/*
> + * New Feature Selectors as added by USB 3.0
> + * See USB 3.0 spec Table 9-6
> + */
> +#define USB_DEVICE_U1_ENABLE	48	/* dev may initiate U1 transition */
> +#define USB_DEVICE_U2_ENABLE	49	/* dev may initiate U2 transition*/

You forget the space on a number of comments, please fix that up.

> +struct usb_ss_cap_descriptor {		/* Link Power Management */
> +	__u8  bLength;
> +	__u8  bDescriptorType;
> +	__u8  bDevCapabilityType;
> +	__u8  bmAttributes;
> +#define USB_LTM_SUPPORT			(1 << 1) /* supports LTM */
> +	__le16 wSpeedSupported;
> +#define USB_LOW_SPEED_OPERATION		(1)	 /* Low speed operation */
> +#define USB_FULL_SPEED_OPERATION	(1 << 1) /* Full speed operation */
> +#define USB_HIGH_SPEED_OPERATION	(1 << 2) /* High speed operation */
> +#define USB_5GBPS_OPERATION		(1 << 3) /* Operation at 5Gbps */
> +	__u8  bFunctionalitySupport;
> +	__u8  bU1devExitLat;
> +	__u16 bU2DevExitLat;

As was pointed out, this still needs to be __le16, as that's the format
of the data, not if it's a bit field or not.

thanks,

greg k-h
