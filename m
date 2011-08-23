Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab1HWE7G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 00:59:06 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:52250 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827Ab1HWE7B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 00:59:01 -0400
MIME-Version: 1.0
In-Reply-To: <1314021636-11528-1-git-send-email-julia@diku.dk>
References: <1314021636-11528-1-git-send-email-julia@diku.dk>
Date: Tue, 23 Aug 2011 12:59:00 +0800
X-Google-Sender-Auth: rw5mu3MNBd1Xt_p8x0JZXpwOZFQ
Message-ID: <CAL-cBk1DzOb8Hjj+MzbQ8jSk2PX0cQTfCMWioT=+jOPv5gUNKQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers/staging/usbip/userspace/libsrc/vhci_driver.c:
 test the just-initialized value
From: David Chang <dchang@suse.com>
To: Julia Lawall <julia@diku.dk>
Cc: Matt Mooney <mfm@muteddisk.com>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/22 Julia Lawall <julia@diku.dk>:
> From: Julia Lawall <julia@diku.dk>
>
> Test the just-initialized value rather than some other one.
>
> The semantic match that finds this problem is as follows:
> (http://coccinelle.lip6.fr/)
>
> // <smpl>
> @r@
> identifier x,y,f!={PTR_ERR,ERR_PTR,ERR_CAST};
> statement S;
> @@
>
> x = f(...);
> (
> if (\(x == NULL\|IS_ERR(x)\)) S
> |
> *if (\(y == NULL\|IS_ERR(y)\))
>  { ... when != x
>   return ...; }
> )
> // </smpl>
>
> Signed-off-by: Julia Lawall <julia@diku.dk>
>
> ---
>  drivers/staging/usbip/userspace/libsrc/vhci_driver.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
> index abbc285..2697877 100644
> --- a/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
> +++ b/drivers/staging/usbip/userspace/libsrc/vhci_driver.c
> @@ -133,7 +133,7 @@ static int check_usbip_device(struct sysfs_class_device *cdev)
>                             strlen(vhci_driver->hc_device->path))) {
>                        /* found usbip device */
>                        usbip_cdev = calloc(1, sizeof(*usbip_cdev));
> -                       if (!cdev) {
> +                       if (!usbip_cdev) {
>                                dbg("calloc failed");
>                                return -1;
>                        }
>

Acked-by: David Chang <dchang@suse.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
