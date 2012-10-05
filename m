Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2JEBjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 21:39:16 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:11109 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791Ab2JEBjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 21:39:13 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-bc-506e3a1fc104
From: Jingoo Han <jg1.han@samsung.com>
To: "'Florian Fainelli'" <florian@openwrt.org>
Cc: stern@rowland.harvard.edu, linux-usb@vger.kernel.org,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Lennert Buytenhek'" <kernel@wantstofly.org>,
        "'Felipe Balbi'" <balbi@ti.com>, "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1349363872-27004-1-git-send-email-florian@openwrt.org>
 <1349363872-27004-15-git-send-email-florian@openwrt.org>
In-reply-to: <1349363872-27004-15-git-send-email-florian@openwrt.org>
Subject: Re: [PATCH 14/24] USB: ohci: merge ohci_finish_controller_resume with
 ohci_resume
Date: Fri, 05 Oct 2012 10:38:38 +0900
Message-id: <000e01cda29a$251922c0$6f4b6840$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2iRSRb1j78jgSLT96IqP0ukRbUfAAU2vgg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsVy+t9jAV15q7wAg7f/LSwu75rDZjF7ST+L
	xYzz+5gsFi1rZXZg8fi8SS6AMYrLJiU1J7MstUjfLoErY8PkVpaCt+4Vr3tuMTcw/rXqYuTk
	kBAwkTi4/hUzhC0mceHeerYuRi4OIYFFjBKTfn9jh3B+MUrM2DWdEaSKTUBN4suXw+wgtoiA
	jsT29y+YQYqYBTYzS0x62A5WJCRQJ7Gg+y3QKA4OTgFXic2/REHCwgIxEgfa+9lAbBYBVYl9
	tyBKeAVsJXYcKAMJ8woISvyYfI8FxGYW0JLYvK2JFcKWl9i85i0zSLmEgLrEo7+6EBcYSUy7
	3swEUSIise/FO8YJjEKzkEyahWTSLCSTZiFpWcDIsopRNLUguaA4KT3XSK84Mbe4NC9dLzk/
	dxMjOMifSe9gXNVgcYhRgINRiYdX4FlugBBrYllxZe4hRgkOZiUR3nytvAAh3pTEyqrUovz4
	otKc1OJDjNIcLErivM0eKQFCAumJJanZqakFqUUwWSYOTqkGRitfO71pdVOLVJrChKvS5n9c
	0VHWI91tXlNvHDsnJ+rU/m9XepdVa0VkB7KqvmRfpb8hxM8xXsp+fXpx7ZTVIvd/m0/JiuJu
	idtn8CdaTuth5zt1y62Xdhxl2nW4LFtkazV/waky+Q/+lnqZ6z4WxGdbdIg8m6PraSd1dXtw
	WTH3Z1O/zWxKLMUZiYZazEXFiQD8EaXKbgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 05, 2012 12:18 AM Florian Fainelli wrote
> 
> Merge ohci_finish_controller_resume with ohci_resume as suggested by Alan
> Stern. Since ohci_finish_controller_resume no longer exists, update the
> various OHCI drivers to call ohci_resume() instead. Some drivers used to set
> themselves the bit HCD_FLAG_HW_ACCESSIBLE, which is now handled by
> ohci_resume().
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>

For drivers/usb/host/ohci-exynos.c, it looks good.

Acked-by: Jingoo Han <jg1.han@samsung.com>


Best regards,
Jingoo Han


> ---
>  drivers/usb/host/ohci-at91.c     |    2 +-
>  drivers/usb/host/ohci-ep93xx.c   |    2 +-
>  drivers/usb/host/ohci-exynos.c   |    5 +----
>  drivers/usb/host/ohci-hcd.c      |   41 +++++++++++++++++++++++++++++++++++--
>  drivers/usb/host/ohci-hub.c      |   42 --------------------------------------
>  drivers/usb/host/ohci-omap.c     |    2 +-
>  drivers/usb/host/ohci-platform.c |    2 +-
>  drivers/usb/host/ohci-pxa27x.c   |    2 +-
>  drivers/usb/host/ohci-s3c2410.c  |    3 +--
>  drivers/usb/host/ohci-spear.c    |    2 +-
>  drivers/usb/host/ohci-tmio.c     |    2 +-
>  11 files changed, 48 insertions(+), 57 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index 0bf72f9..908d84a 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -705,7 +705,7 @@ static int ohci_hcd_at91_drv_resume(struct platform_device *pdev)
>  	if (!clocked)
>  		at91_start_clock();
> 
> -	ohci_finish_controller_resume(hcd);
> +	ohci_resume(hcd, false);
>  	return 0;
>  }
>  #else
> diff --git a/drivers/usb/host/ohci-ep93xx.c b/drivers/usb/host/ohci-ep93xx.c
> index dbfbd1d..a982f04 100644
> --- a/drivers/usb/host/ohci-ep93xx.c
> +++ b/drivers/usb/host/ohci-ep93xx.c
> @@ -194,7 +194,7 @@ static int ohci_hcd_ep93xx_drv_resume(struct platform_device *pdev)
> 
>  	ep93xx_start_hc(&pdev->dev);
> 
> -	ohci_finish_controller_resume(hcd);
> +	ohci_resume(hcd, false);
>  	return 0;
>  }
>  #endif
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index fc3091b..53c5a989 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -252,10 +252,7 @@ static int exynos_ohci_resume(struct device *dev)
>  	if (pdata && pdata->phy_init)
>  		pdata->phy_init(pdev, S5P_USB_PHY_HOST);
> 
> -	/* Mark hardware accessible again as we are out of D3 state by now */
> -	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
> -
> -	ohci_finish_controller_resume(hcd);
> +	ohci_resume(hcd, false);
> 
>  	return 0;
>  }
> diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
> index 5d30992..568bdb3 100644
> --- a/drivers/usb/host/ohci-hcd.c
> +++ b/drivers/usb/host/ohci-hcd.c
> @@ -1003,13 +1003,50 @@ static int __maybe_unused ohci_suspend(struct usb_hcd *hcd, bool do_wakeup)
> 
>  static int __maybe_unused ohci_resume(struct usb_hcd *hcd, bool hibernated)
>  {
> +	struct ohci_hcd		*ohci = hcd_to_ohci(hcd);
> +	int			port;
> +	bool			need_reinit = false;
> +
>  	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
> 
>  	/* Make sure resume from hibernation re-enumerates everything */
>  	if (hibernated)
> -		ohci_usb_reset(hcd_to_ohci(hcd));
> +		ohci_usb_reset(ohci);
> +
> +	/* See if the controller is already running or has been reset */
> +	ohci->hc_control = ohci_readl(ohci, &ohci->regs->control);
> +	if (ohci->hc_control & (OHCI_CTRL_IR | OHCI_SCHED_ENABLES)) {
> +		need_reinit = true;
> +	} else {
> +		switch (ohci->hc_control & OHCI_CTRL_HCFS) {
> +		case OHCI_USB_OPER:
> +		case OHCI_USB_RESET:
> +			need_reinit = true;
> +		}
> +	}
> +
> +	/* If needed, reinitialize and suspend the root hub */
> +	if (need_reinit) {
> +		spin_lock_irq(&ohci->lock);
> +		ohci_rh_resume(ohci);
> +		ohci_rh_suspend(ohci, 0);
> +		spin_unlock_irq(&ohci->lock);
> +	}
> +
> +	/* Normally just turn on port power and enable interrupts */
> +	else {
> +		ohci_dbg(ohci, "powerup ports\n");
> +		for (port = 0; port < ohci->num_ports; port++)
> +			ohci_writel(ohci, RH_PS_PPS,
> +					&ohci->regs->roothub.portstatus[port]);
> +
> +		ohci_writel(ohci, OHCI_INTR_MIE, &ohci->regs->intrenable);
> +		ohci_readl(ohci, &ohci->regs->intrenable);
> +		msleep(20);
> +	}
> +
> +	usb_hcd_resume_root_hub(hcd);
> 
> -	ohci_finish_controller_resume(hcd);
>  	return 0;
>  }
> 
> diff --git a/drivers/usb/host/ohci-hub.c b/drivers/usb/host/ohci-hub.c
> index 2f3619e..db09dae 100644
> --- a/drivers/usb/host/ohci-hub.c
> +++ b/drivers/usb/host/ohci-hub.c
> @@ -316,48 +316,6 @@ static int ohci_bus_resume (struct usb_hcd *hcd)
>  	return rc;
>  }
> 
> -/* Carry out the final steps of resuming the controller device */
> -static void __maybe_unused ohci_finish_controller_resume(struct usb_hcd *hcd)
> -{
> -	struct ohci_hcd		*ohci = hcd_to_ohci(hcd);
> -	int			port;
> -	bool			need_reinit = false;
> -
> -	/* See if the controller is already running or has been reset */
> -	ohci->hc_control = ohci_readl(ohci, &ohci->regs->control);
> -	if (ohci->hc_control & (OHCI_CTRL_IR | OHCI_SCHED_ENABLES)) {
> -		need_reinit = true;
> -	} else {
> -		switch (ohci->hc_control & OHCI_CTRL_HCFS) {
> -		case OHCI_USB_OPER:
> -		case OHCI_USB_RESET:
> -			need_reinit = true;
> -		}
> -	}
> -
> -	/* If needed, reinitialize and suspend the root hub */
> -	if (need_reinit) {
> -		spin_lock_irq(&ohci->lock);
> -		ohci_rh_resume(ohci);
> -		ohci_rh_suspend(ohci, 0);
> -		spin_unlock_irq(&ohci->lock);
> -	}
> -
> -	/* Normally just turn on port power and enable interrupts */
> -	else {
> -		ohci_dbg(ohci, "powerup ports\n");
> -		for (port = 0; port < ohci->num_ports; port++)
> -			ohci_writel(ohci, RH_PS_PPS,
> -					&ohci->regs->roothub.portstatus[port]);
> -
> -		ohci_writel(ohci, OHCI_INTR_MIE, &ohci->regs->intrenable);
> -		ohci_readl(ohci, &ohci->regs->intrenable);
> -		msleep(20);
> -	}
> -
> -	usb_hcd_resume_root_hub(hcd);
> -}
> -
>  /* Carry out polling-, autostop-, and autoresume-related state changes */
>  static int ohci_root_hub_state_changes(struct ohci_hcd *ohci, int changed,
>  		int any_connected, int rhsc_status)
> diff --git a/drivers/usb/host/ohci-omap.c b/drivers/usb/host/ohci-omap.c
> index f8b2d91..9fab4d8 100644
> --- a/drivers/usb/host/ohci-omap.c
> +++ b/drivers/usb/host/ohci-omap.c
> @@ -530,7 +530,7 @@ static int ohci_omap_resume(struct platform_device *dev)
>  	ohci->next_statechange = jiffies;
> 
>  	omap_ohci_clock_power(1);
> -	ohci_finish_controller_resume(hcd);
> +	ohci_resume(hcd, false);
>  	return 0;
>  }
> 
> diff --git a/drivers/usb/host/ohci-platform.c b/drivers/usb/host/ohci-platform.c
> index 1caaf65..99d1755 100644
> --- a/drivers/usb/host/ohci-platform.c
> +++ b/drivers/usb/host/ohci-platform.c
> @@ -203,7 +203,7 @@ static int ohci_platform_resume(struct device *dev)
>  			return err;
>  	}
> 
> -	ohci_finish_controller_resume(hcd);
> +	ohci_resume(hcd, false);
>  	return 0;
>  }
> 
> diff --git a/drivers/usb/host/ohci-pxa27x.c b/drivers/usb/host/ohci-pxa27x.c
> index 77f4402..8bffde3 100644
> --- a/drivers/usb/host/ohci-pxa27x.c
> +++ b/drivers/usb/host/ohci-pxa27x.c
> @@ -591,7 +591,7 @@ static int ohci_hcd_pxa27x_drv_resume(struct device *dev)
>  	/* Select Power Management Mode */
>  	pxa27x_ohci_select_pmm(ohci, inf->port_mode);
> 
> -	ohci_finish_controller_resume(hcd);
> +	ohci_resume(hcd, false);
>  	return 0;
>  }
> 
> diff --git a/drivers/usb/host/ohci-s3c2410.c b/drivers/usb/host/ohci-s3c2410.c
> index 664c869..8af53c6 100644
> --- a/drivers/usb/host/ohci-s3c2410.c
> +++ b/drivers/usb/host/ohci-s3c2410.c
> @@ -524,8 +524,7 @@ static int ohci_hcd_s3c2410_drv_resume(struct device *dev)
> 
>  	s3c2410_start_hc(pdev, hcd);
> 
> -	set_bit(HCD_FLAG_HW_ACCESSIBLE, &hcd->flags);
> -	ohci_finish_controller_resume(hcd);
> +	ohci_resume(hcd, false);
> 
>  	return 0;
>  }
> diff --git a/drivers/usb/host/ohci-spear.c b/drivers/usb/host/ohci-spear.c
> index fc7305e..d607be3 100644
> --- a/drivers/usb/host/ohci-spear.c
> +++ b/drivers/usb/host/ohci-spear.c
> @@ -231,7 +231,7 @@ static int spear_ohci_hcd_drv_resume(struct platform_device *dev)
>  	ohci->next_statechange = jiffies;
> 
>  	spear_start_ohci(ohci_p);
> -	ohci_finish_controller_resume(hcd);
> +	ohci_resume(hcd, false);
>  	return 0;
>  }
>  #endif
> diff --git a/drivers/usb/host/ohci-tmio.c b/drivers/usb/host/ohci-tmio.c
> index 60c2b07..2c9ab8f 100644
> --- a/drivers/usb/host/ohci-tmio.c
> +++ b/drivers/usb/host/ohci-tmio.c
> @@ -352,7 +352,7 @@ static int ohci_hcd_tmio_drv_resume(struct platform_device *dev)
> 
>  	spin_unlock_irqrestore(&tmio->lock, flags);
> 
> -	ohci_finish_controller_resume(hcd);
> +	ohci_resume(hcd, false);
> 
>  	return 0;
>  }
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

