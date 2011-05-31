Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab1EaOSM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 10:18:12 -0400
Received: from netrider.rowland.org ([192.131.102.5]:37041 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756186Ab1EaOSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 10:18:10 -0400
Date: Tue, 31 May 2011 10:18:09 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tatyana Brokhman <tlinder@codeaurora.org>
cc: greg@kroah.com, <linux-usb@vger.kernel.org>,
        <linux-arm-msm@vger.kernel.org>, <balbi@ti.com>,
        <ablay@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 9/9] usb: Adding SuperSpeed support to dummy_hcd
In-Reply-To: <1306847914-19876-10-git-send-email-tlinder@codeaurora.org>
Message-ID: <Pine.LNX.4.44L0.1105311014160.30678-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 May 2011, Tatyana Brokhman wrote:

> This patch adds SS support to the dummy hcd module. It may be used to test
> SS device when no (SS) HW is available.
> USB 3.0 hub includes 2 hubs - HS and SS ones.
> This patch adds support for a SS hub in the dummy_hcd module. Thus, when
> dummy_hcd enabled it will register 2 root hubs (SS and HS).
> A new module parameter was added to simulate a SuperSpeed connection.
> When a new device is connected it will enumerate via the HS root hub by
> default. In order to simulate SuperSpeed connection set the is_super_speed module
> parameter to true.

If is_super_speed is false, shouldn't you avoid registering the
SuperSpeed hub?  Or would that add too many complications?

> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
> 
> ---
>  drivers/usb/gadget/Kconfig     |    1 +
>  drivers/usb/gadget/dummy_hcd.c |  556 +++++++++++++++++++++++++++++++++-------
>  2 files changed, 469 insertions(+), 88 deletions(-)
> 
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 5927541..d5f0af7 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -626,6 +626,7 @@ config USB_DUMMY_HCD
>  	depends on USB_GADGET_DUMMY_HCD
>  	default USB_GADGET
>  	select USB_GADGET_SELECTED
> +	select USB_GADGET_SUPERSPEED

This belongs under USB_GADGET_DUMMY_HCD, next to the "select
USB_GADGET_DUALSPEED" line.

Alan Stern

