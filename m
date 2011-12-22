Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683Ab1LVDFk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:05:40 -0500
Received: from netrider.rowland.org ([192.131.102.5]:45830 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753388Ab1LVDFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:05:39 -0500
Date: Wed, 21 Dec 2011 22:05:38 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Dmitry Antipov <dmitry.antipov@linaro.org>
cc: linaro-dev@lists.linaro.org, <patches@linaro.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ohci-hcd: ohci-hcd: use usleep_range() instead of mdelay()
In-Reply-To: <4EF185AA.2000006@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1112212159460.21935-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Dmitry Antipov wrote:

>  From ac60fe289eef3d81009f2b14a12acbac3e71878b Mon Sep 17 00:00:00 2001
> From: Dmitry Antipov <dmitry.antipov@linaro.org>
> Date: Wed, 21 Dec 2011 11:05:27 +0400
> Subject: [PATCH] ohci-hcd: use usleep_range() instead of mdelay()
> 
> ---
>   drivers/usb/host/ohci-hcd.c |    4 +++-
>   1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
> index b263919..a6d58da 100644
> --- a/drivers/usb/host/ohci-hcd.c
> +++ b/drivers/usb/host/ohci-hcd.c
> @@ -574,6 +574,7 @@ static int ohci_run (struct ohci_hcd *ohci)
>   	u32			mask, val;
>   	int			first = ohci->fminterval == 0;
>   	struct usb_hcd		*hcd = ohci_to_hcd(ohci);
> +	unsigned long		usecs;
> 
>   	disable (ohci);
> 
> @@ -724,7 +725,8 @@ retry:
>   	spin_unlock_irq (&ohci->lock);
> 
>   	// POTPGT delay is bits 24-31, in 2 ms units.
> -	mdelay ((val >> 23) & 0x1fe);
> +	usecs = ((val >> 23) & 0x1fe) * USEC_PER_MSEC;
> +	usleep_range(usecs, usecs + 1000);
>   	hcd->state = HC_STATE_RUNNING;
> 
>   	if (quirk_zfmicro(ohci)) {

Why not simply use msleep()?

Alan Stern

