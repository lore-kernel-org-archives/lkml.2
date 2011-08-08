Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab1HHMSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 08:18:01 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:61945 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab1HHMR7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 08:17:59 -0400
MIME-Version: 1.0
In-Reply-To: <1312794859.21052.2.camel@phoenix>
References: <1312794859.21052.2.camel@phoenix>
Date: Mon, 8 Aug 2011 14:17:58 +0200
Message-ID: <CAHR064ggiMvUm1m6g9fpxV-5Bk2PShZQiwjPRrukj0w_EwskWA@mail.gmail.com>
Subject: Re: [PATCH 1/3] platform-drivers-x86: eeepc-laptop: fix wrong test
 for successful registered led_classdev
From: Corentin Chary <corentin.chary@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good catch ! It would be great to have a coccinel script to check that
in scripts/coccinelle/null/.

On Mon, Aug 8, 2011 at 11:14 AM, Axel Lin <axel.lin@gmail.com> wrote:
> device_create returns &struct device pointer on success, or ERR_PTR() on error.
> Thus if led_classdev_register fails, led_cdev->dev is always not NULL.
>
> If IS_ERR(eeepc->tpd_led.dev) is ture, it means led_classdev_register fails.
> If (asus->tpd_led.dev) is NULL, it means we call eeepc_led_exit before
> calling led_classdev_register for &eeepc->tpd_led.
>
> We only want to call led_classdev_unregister for sucessfully registered
> led_classdev, then we should check (!IS_ERR_OR_NULL(eeepc->tpd_led.dev)).
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Corentin Chary <corentin.chary@gmail.com>

> ---
>  drivers/platform/x86/eeepc-laptop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
> index 1c45d92..29a216a 100644
> --- a/drivers/platform/x86/eeepc-laptop.c
> +++ b/drivers/platform/x86/eeepc-laptop.c
> @@ -568,7 +568,7 @@ static int eeepc_led_init(struct eeepc_laptop *eeepc)
>
>  static void eeepc_led_exit(struct eeepc_laptop *eeepc)
>  {
> -       if (eeepc->tpd_led.dev)
> +       if (!IS_ERR_OR_NULL(eeepc->tpd_led.dev))
>                led_classdev_unregister(&eeepc->tpd_led);
>        if (eeepc->led_workqueue)
>                destroy_workqueue(eeepc->led_workqueue);
> --
> 1.7.4.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Corentin Chary
http://xf.iksaif.net
