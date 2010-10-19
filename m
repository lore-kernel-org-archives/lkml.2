Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933678Ab0JSApf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:45:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:49741 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757909Ab0JSApd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:45:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,347,1283756400"; 
   d="scan'208";a="848465265"
Date: Mon, 18 Oct 2010 17:45:30 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jacob Pan <jacob.jun.pan@intel.com>, linux-kernel@vger.kernel.org,
        John Youn <John.Youn@synopsys.com>
Subject: Re: [PATCH 1/3] usb: USB3.0 ch11 definitions
Message-ID: <20101019004530.GA2574@xanatos>
References: <1287414160-12307-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287414160-12307-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding John Youn, as his patch to add USB 3.0 hub support to the USB
core had some of the same definitions added:
http://git.kernel.org/?p=linux/kernel/git/sarah/xhci.git;a=commit;h=0954d269be8c830858b593a712030e2e46886d3f

John, I'm still trying to get the xHCI roothub code correct, and then
I'll probably respin your patch to fit on top of this one.

Tatyana, the values look correct, I just have two comments below.

On Mon, Oct 18, 2010 at 05:02:30PM +0200, Tatyana Brokhman wrote:
> Adding hub SuperSpeed usb definitions as defined by ch10 of the USB3.0
> spec.
> This patch is a preparation for adding SuperSpeed support to the dummy_hcd.
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> ---
>  include/linux/usb/ch11.h |   47 ++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/usb/hcd.h  |    4 +++
>  2 files changed, 51 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/usb/ch11.h b/include/linux/usb/ch11.h
> index 119194c..7dabff0 100644
> --- a/include/linux/usb/ch11.h
> +++ b/include/linux/usb/ch11.h
> @@ -28,6 +28,13 @@
>  #define HUB_STOP_TT		11
>  
>  /*
> + * Hub class additional requests defined by USB 3.0 spec
> + * See USB 3.0 spec Table 10-6
> + */
> +#define HUB_SET_DEPTH		12
> +#define HUB_GET_PORT_ERR_COUNT	13
> +
> +/*
>   * Hub Class feature numbers
>   * See USB 2.0 spec Table 11-17
>   */
> @@ -83,6 +90,21 @@ struct usb_port_status {
>  /* bits 13 to 15 are reserved */
>  #define USB_PORT_STAT_SUPER_SPEED	0x8000	/* Linux-internal */
>  
> +
> +/*
> + * Port feature selectors added by USB 3.0 spec.
> + * See USB 3.0 spec Table 10-7
> + */
> +#define USB_PORT_FEAT_LINK_STATE		5
> +#define USB_PORT_FEAT_U1_TIMEOUT		23
> +#define USB_PORT_FEAT_U2_TIMEOUT		24
> +#define USB_PORT_FEAT_C_LINK_STATE		25
> +#define USB_PORT_FEAT_C_CONFIG_ERR		26
> +#define USB_PORT_FEAT_REMOTE_WAKE_MASK		27
> +#define USB_PORT_FEAT_BH_PORT_RESET		28
> +#define USB_PORT_FEAT_C_BH_PORT_RESET		29
> +#define USB_PORT_FEAT_FORCE_LINKPM_ACCEPT	30
> +

Why not put these USB 3.0 hub port feature definitions next to the USB
2.0 definitions on line 56 (right after USB_PORT_FEAT_C_PORT_L1 is
defined)?

>  /*
>   * wPortChange bit field
>   * See USB 2.0 spec Table 11-22
> @@ -121,6 +143,31 @@ struct usb_hub_status {
>  #define HUB_CHANGE_LOCAL_POWER	0x0001
>  #define HUB_CHANGE_OVERCURRENT	0x0002
>  
> +/*
> + * Additions to wPortStatus bit field from USB 3.0
> + * See USB 3.0 spec Table 10-10
> + */
> +#define USB_PORT_STAT_LINK_STATE	0x01e0
> +#define USB_SS_PORT_STAT_POWER		0x0200
> +#define USB_PORT_STAT_SPEED_5GBPS	0x0000
> +/* Valid only if port is enabled */
> +
> +/*
> + * Definitions for PORT_LINK_STATE values
> + * (bits 5-8) in wPortStatus
> + */
> +#define USB_SS_PORT_LS_U0		0x0000
> +#define USB_SS_PORT_LS_U1		0x0020
> +#define USB_SS_PORT_LS_U2		0x0040
> +#define USB_SS_PORT_LS_U3		0x0060
> +#define USB_SS_PORT_LS_SS_DISABLED	0x0080
> +#define USB_SS_PORT_LS_RX_DETECT	0x00a0
> +#define USB_SS_PORT_LS_SS_INACTIVE	0x00c0
> +#define USB_SS_PORT_LS_POLLING		0x00e0
> +#define USB_SS_PORT_LS_RECOVERY		0x0100
> +#define USB_SS_PORT_LS_HOT_RESET	0x0120
> +#define USB_SS_PORT_LS_COMP_MOD		0x0140
> +#define USB_SS_PORT_LS_LOOPBACK		0x0160

On a similar note, shouldn't these after line 84 with the other
USB_PORT_STAT_* definitions?

Thanks for adding these definitions. :)

Sarah Sharp
