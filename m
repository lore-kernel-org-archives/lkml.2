Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063Ab0JJIKS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 04:10:18 -0400
Received: from mga11.intel.com ([192.55.52.93]:4304 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab0JJIKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 04:10:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,309,1283756400"; 
   d="scan'208";a="615152671"
Date: Sun, 10 Oct 2010 04:10:12 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] usb: usb3.0 ch9 definitions
Message-ID: <20101010081012.GB18531@linux.intel.com>
References: <1286635573-30035-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286635573-30035-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 09, 2010 at 04:46:12PM +0200, Tatyana Brokhman wrote:
> +/*
> + * SuperSpeed USB Capability descriptor: Defines the set of SuperSpeed USB
> + * specific device level capabilities
> + */
> +#define		USB_SS_CAP_TYPE		3
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
> +	__le16 bU2DevExitLat;
> +} __attribute__((packed));
> +
> +#define USB_DT_USB_SS_CAP_SIZE	10

Hang on, if we're looking at page 10-57 of "USB 3 0 (11132008)-final.pdf",
it's 12 bytes long with the last two bytes being wReserved.  Is there
an erratum that changes this?  I just looked through
"USB3_Errata [June 2010].pdf" and don't see any errata that look germane.

