Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab2HJNvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 09:51:46 -0400
Received: from netrider.rowland.org ([192.131.102.5]:40777 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756664Ab2HJNvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 09:51:44 -0400
Date: Fri, 10 Aug 2012 09:51:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: gregkh@linuxfoundation.org, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: host: tegra: fix warning messages in ehci_remove
In-Reply-To: <1344579163-10190-1-git-send-email-vbyravarasu@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1208100951220.15352-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Aug 2012, Venu Byravarasu wrote:

> Existing implementation of tegra_ehci_remove() calls
> usb_put_hcd(hcd) first and then iounmap(hcd->regs).
> 
> usb_put_hcd() implementation calls hcd_release()
> which frees up memory allocated for hcd.
> 
> As iounmap is trying to unmap hcd->regs, after hcd
> getting freed up, warning messages were observed during
> unload of USB.
> 
> Hence fixing it.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
>  drivers/usb/host/ehci-tegra.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 950e95e..26dedb3 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -799,11 +799,12 @@ static int tegra_ehci_remove(struct platform_device *pdev)
>  #endif
>  
>  	usb_remove_hcd(hcd);
> -	usb_put_hcd(hcd);
>  
>  	tegra_usb_phy_close(tegra->phy);
>  	iounmap(hcd->regs);
>  
> +	usb_put_hcd(hcd);
> +
>  	clk_disable_unprepare(tegra->clk);
>  	clk_put(tegra->clk);

Acked-by: Alan Stern <stern@rowland.harvard.edu>

