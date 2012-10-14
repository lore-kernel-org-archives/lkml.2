Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab2JNNv4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 09:51:56 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47714 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab2JNNvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 09:51:55 -0400
MIME-Version: 1.0
In-Reply-To: <1350221882-7631-1-git-send-email-yamanetoshi@gmail.com>
References: <1349699137-32366-1-git-send-email-yamanetoshi@gmail.com>
	<1350221882-7631-1-git-send-email-yamanetoshi@gmail.com>
Date: Sun, 14 Oct 2012 22:51:53 +0900
Message-ID: <CAOTypNQboxf2Oy0x2vNu8MHaqddQ5CdVTAeU9yOJCucu7F7X7g@mail.gmail.com>
Subject: Re: [PATCH] staging/comedi: Use dev_ printks in drivers/usbdux.c
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: Ian Abbott <abbotti@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 14, 2012 at 10:38 PM, YAMANE Toshiaki <yamanetoshi@gmail.com> wrote:
> fixed below checkpatch warning.
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
>
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
> ---
>  drivers/staging/comedi/drivers/usbdux.c |   10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
> index b536bba..46c5bfb 100644
> --- a/drivers/staging/comedi/drivers/usbdux.c
> +++ b/drivers/staging/comedi/drivers/usbdux.c
> @@ -2386,14 +2386,12 @@ static int usbdux_attach_usb(struct comedi_device *dev,
>         down(&start_stop_sem);
>         this_usbduxsub = usb_get_intfdata(uinterf);
>         if (!this_usbduxsub || !this_usbduxsub->probed) {
> -               printk(KERN_ERR
> -                      "comedi%d: usbdux: error: attach_usb failed, not connected\n",
> -                      dev->minor);
> +               dev_err(&uinterf->dev,
> +                       "usbdux: error: attach_usb failed, not connected\n");
>                 ret = -ENODEV;
>         } else if (this_usbduxsub->attached) {
> -               printk(KERN_ERR
> -                      "comedi%d: usbdux: error: attach_usb failed, already attached\n",
> -                      dev->minor);
> +               dev_err(&uinterf->dev,
> +                       "error: attach_usb failed, already attached\n");
>                 ret = -ENODEV;
>         } else
>                 ret = usbdux_attach_common(dev, this_usbduxsub);
> --
> 1.7.9.5
>

I cannot judge which is better or not ...

-- 

Regards,

YAMANE Toshiaki
