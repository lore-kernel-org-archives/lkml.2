Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1E1LEL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 07:04:11 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39493 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab1E1LEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 07:04:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6359"; a="94253001"
From: "Tanya Brokhman" <tlinder@codeaurora.org>
To: "'Alan Stern'" <stern@rowland.harvard.edu>
Cc: <balbi@ti.com>, "'Sarah Sharp'" <sarah.a.sharp@linux.intel.com>,
        <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <ablay@codeaurora.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.1105251010580.1987-100000@iolanthe.rowland.org> <Pine.LNX.4.44L0.1105251033550.1987-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1105251033550.1987-100000@iolanthe.rowland.org>
Subject: RE: [PATCH v12 7/8] usb: Adding SuperSpeed support to dummy_hcd
Date: Sat, 28 May 2011 14:05:54 +0300
Message-ID: <003201cc1d27$39fe02e0$adfa08a0$@org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acwa6YDyYe1wY0csQBSvVWoSnfdFlACPShtA
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

> This patch (as1468) changes the Kconfig definition for
> USB_GADGET_DUALSPEED.  This option is determined entirely by which
> device controller drivers are to be built, through Select statements;
> it does not need to be (and should not be) configurable by the user.
> 
> Also, the "default n" line is superfluous -- everything defaults to N.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> 
> ---
> 
>  drivers/usb/gadget/Kconfig |    5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> Index: usb-2.6/drivers/usb/gadget/Kconfig
> ===================================================================
> --- usb-2.6.orig/drivers/usb/gadget/Kconfig
> +++ usb-2.6/drivers/usb/gadget/Kconfig
> @@ -597,13 +597,10 @@ config USB_DUMMY_HCD
> 
>  endchoice
> 
> +# Selected by UDC drivers that support high-speed operation.
>  config USB_GADGET_DUALSPEED
>  	bool
>  	depends on USB_GADGET
> -	default n
> -	help
> -	  Means that gadget drivers should include extra descriptors
> -	  and code to handle dual-speed controllers.
> 
>  #
>  # USB Gadget Drivers
> 

I was making the same change for SS and I think that if you're about to send
this patch to Greg, it might need a small addition:
At the moment dummy_hcd supports high_speed so I think if this option is no
longer configurable by user you should set this flag when dummy_hcd is
selected:

config USB_DUMMY_HCD
	tristate
	depends on USB_GADGET_DUMMY_HCD
	default USB_GADGET
	select USB_GADGET_SELECTED
	select USB_GADGET_DUALSPEED


Best regards,
Tanya Brokhman
Consultant for Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum








