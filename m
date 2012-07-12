Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab2GLJMo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 05:12:44 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8249 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752141Ab2GLJMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 05:12:42 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Jul 2012 02:08:52 -0700
Message-ID: <4FFE94E8.8000909@nvidia.com>
Date: Thu, 12 Jul 2012 14:42:08 +0530
From: Venu Byravarasu <vbyravarasu@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "stern@rowland.harvard.edu" <stern@rowland.harvard.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] usb: host: tegra: pass correct pointer in ehci_setup()
References: <1342082208-14184-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1342082208-14184-1-git-send-email-ldewangan@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Venu Byravarasu <vbyravarasu@nvidia.com>
Tested-by: Venu Byravarasu <vbyravarasu@nvidia.com>

On Thursday 12 July 2012 02:06 PM, Laxman Dewangan wrote:
> The ehci_setup() require the pointer of usb_hcd.
> Passing the correct pointer in place of ehci_hcd
> pointer.
>
> This is side effetct of change:
> commit 1a49e2ac9651df7349867a5cf44e2c83de1046af
> Author: Alan Stern <stern@rowland.harvard.edu>
>
>      EHCI: centralize controller initialization
>
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> ---
>   drivers/usb/host/ehci-tegra.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/host/ehci-tegra.c b/drivers/usb/host/ehci-tegra.c
> index 9e44b1f..d2a7c95 100644
> --- a/drivers/usb/host/ehci-tegra.c
> +++ b/drivers/usb/host/ehci-tegra.c
> @@ -285,7 +285,7 @@ static int tegra_ehci_setup(struct usb_hcd *hcd)
>   	/* switch to host mode */
>   	hcd->has_tt = 1;
>   
> -	retval = ehci_setup(ehci);
> +	retval = ehci_setup(hcd);
>   	if (retval)
>   		return retval;
>   


