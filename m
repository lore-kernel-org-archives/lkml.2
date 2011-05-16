Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab1EPLEB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 07:04:01 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:36168 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754400Ab1EPLEA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 07:04:00 -0400
MIME-Version: 1.0
In-Reply-To: <1305353736.11286.2.camel@phoenix>
References: <1305353736.11286.2.camel@phoenix>
Date: Mon, 16 May 2011 16:33:58 +0530
Message-ID: <BANLkTinQkekfnR=zc4TJfU3qSHarKQsUcg@mail.gmail.com>
Subject: Re: [PATCH] mfd: Fix omap_usbhs_alloc_children error handling
From: "Munegowda, Keshava" <keshava_mgowda@ti.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 11:45 AM, Axel Lin <axel.lin@gmail.com> wrote:
> 1. Return proper error if omap_usbhs_alloc_child fails
> 2. In the case of goto err_ehci, we should call platform_device_unregister(ehci)
>   instead of platform_device_put(ehci) because we have already added the
>   platform device to device hierarchy.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/omap-usb-host.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
> index 3ab9ffa..344f518 100644
> --- a/drivers/mfd/omap-usb-host.c
> +++ b/drivers/mfd/omap-usb-host.c
> @@ -281,6 +281,7 @@ static int omap_usbhs_alloc_children(struct platform_device *pdev)
>
>        if (!ehci) {
>                dev_err(dev, "omap_usbhs_alloc_child failed\n");
> +               ret = -ENOMEM;
>                goto err_end;
>        }
>
> @@ -304,13 +305,14 @@ static int omap_usbhs_alloc_children(struct platform_device *pdev)
>                sizeof(*ohci_data), dev);
>        if (!ohci) {
>                dev_err(dev, "omap_usbhs_alloc_child failed\n");
> +               ret = -ENOMEM;
>                goto err_ehci;
>        }
>
>        return 0;
>
>  err_ehci:
> -       platform_device_put(ehci);
> +       platform_device_unregister(ehci);
>
>  err_end:
>        return ret;
> --
> 1.7.1
>

Looks goo to me;

Balbi,
      I will take this patch on top of hwmod and runtime pm patches?
is it OK for you.
