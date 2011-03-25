Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280Ab1CYNri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:47:38 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:54066 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753139Ab1CYNrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:47:36 -0400
Date: Fri, 25 Mar 2011 15:47:31 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: gregkh@suse.de, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org,
        "open list:USB GADGET/PERIPH..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5 v8] usb: Adding SuperSpeed support to dummy_hcd
Message-ID: <20110325134730.GO2609@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1300867372-20811-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300867372-20811-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Mar 23, 2011 at 10:02:51AM +0200, Tatyana Brokhman wrote:
> This patch adds SS support to the dummy hcd module. It may be used to test
> SS device when no (SS) HW is available.
> USB 3.0 hub includes 2 hubs - HS and SS ones.
> This patch adds support for a SS hub in the dummy_hcd module. Thus, when
> dummy_hcd enabled it will register 2 root hubs (SS and HS).
> 
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

missing tear line.

> diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
> index 3214ca3..4f4db96 100644
> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -62,9 +62,12 @@
>  #define POWER_BUDGET	500	/* in mA; use 8 for low-power port testing */
>  
>  static const char	driver_name [] = "dummy_hcd";
> +static const char	ss_driver_name[] = "ss_dummy_hcd";
>  static const char	driver_desc [] = "USB Host+Gadget Emulator";
> +static const char	ss_driver_desc[] = "SS USB Host+Gadget Emulator";
>  
>  static const char	gadget_name [] = "dummy_udc";
> +static const char	ss_gadget_name[] = "ss_dummy_udc";
>  
>  MODULE_DESCRIPTION (DRIVER_DESC);
>  MODULE_AUTHOR ("David Brownell");
> @@ -220,6 +223,7 @@ static inline struct dummy *gadget_dev_to_dummy (struct device *dev)
>  }
>  
>  static struct dummy			*the_controller;
> +static struct dummy			*the_ss_controller;

the only thing I don't like, is why you splitted the ss controller to a
separate controller. Why don't you use the same ? From SW perspective,
we can treat SS and HS/FS/LS controllers as one unit.

-- 
balbi
