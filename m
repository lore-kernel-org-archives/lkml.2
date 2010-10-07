Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0JGEMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 00:12:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:65307 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab0JGEMr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 00:12:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=goq/dIU1JaOvplAG1tKocVc5lXLeMZguP91rRnAFVs9iolLxfg6IfteEB+y1RBsbFg
         WMLKxsYeXtTxHNxMKp4k1oTG/DId9GERPpQEmHXOAPYoEQF4s7RlZBgZmpNVCP5Dv9f0
         shOOw1qviMVqpPL7+bto3cUnszXasnsUxJNKQ=
MIME-Version: 1.0
In-Reply-To: <1286424645-2899-1-git-send-email-rahul.ruikar@gmail.com>
References: <1286424645-2899-1-git-send-email-rahul.ruikar@gmail.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Thu, 7 Oct 2010 09:42:24 +0530
Message-ID: <AANLkTinT7NR9xe17UBeh3j4pnzqzQ2EO=cUR4=REzm5S@mail.gmail.com>
Subject: Re: [RESEND/PATCH] usb: gadget: dummy_hcd: Fix error path
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rahul Ruikar <rahul.ruikar@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

Kindly include this patch.

- Rahul Ruikar





On 7 October 2010 09:40, Rahul Ruikar <rahul.ruikar@gmail.com> wrote:
> In function dummy_udc_probe()
> call put_device() when device_register() fails.
> also usb_get_hcd() put before device_register() after review comment
> from Alan Stern.
>
> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
> ---
>  drivers/usb/gadget/dummy_hcd.c |    8 +++++---
>  1 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
> index dc65462..9b30483 100644
> --- a/drivers/usb/gadget/dummy_hcd.c
> +++ b/drivers/usb/gadget/dummy_hcd.c
> @@ -874,6 +874,8 @@ static int dummy_udc_probe (struct platform_device *pdev)
>        struct dummy    *dum = the_controller;
>        int             rc;
>
> +       usb_get_hcd(dummy_to_hcd(dum));
> +
>        dum->gadget.name = gadget_name;
>        dum->gadget.ops = &dummy_ops;
>        dum->gadget.is_dualspeed = 1;
> @@ -885,10 +887,10 @@ static int dummy_udc_probe (struct platform_device *pdev)
>        dum->gadget.dev.parent = &pdev->dev;
>        dum->gadget.dev.release = dummy_gadget_release;
>        rc = device_register (&dum->gadget.dev);
> -       if (rc < 0)
> +       if (rc < 0) {
> +               put_device(&dum->gadget.dev);
>                return rc;
> -
> -       usb_get_hcd (dummy_to_hcd (dum));
> +       }
>
>        platform_set_drvdata (pdev, dum);
>        rc = device_create_file (&dum->gadget.dev, &dev_attr_function);
> --
> 1.7.2.3
>
>
