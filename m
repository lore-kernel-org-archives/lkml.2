Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2HJFHC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 01:07:02 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35924 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328Ab2HJFHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 01:07:01 -0400
MIME-Version: 1.0
In-Reply-To: <1343583999-30231-1-git-send-email-develkernel412222@gmail.com>
References: <1343583999-30231-1-git-send-email-develkernel412222@gmail.com>
Date: Fri, 10 Aug 2012 10:37:00 +0530
Message-ID: <CA+C2MxT+yDQCFKn1nCmJjmGJ+-XOOGmCrmzUNr9iko0kUAXYyQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] lp8727_charger: free_irq when lp8727_register_psy fail
From: Devendra Naga <develkernel412222@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <develkernel412222@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to ask this again,

But will anybody please ACK , NACK or comment on this patch?

Thanks,
Devendra.

On Sun, Jul 29, 2012 at 11:16 PM, Devendra Naga
<develkernel412222@gmail.com> wrote:
> actually the driver does a request_threaded_irq and after this it calls
> lp8727_register_psy, and if it fails it doesn't free the irqs that it
> registered to
>
> Signed-off-by: Devendra Naga <develkernel412222@gmail.com>
> ---
>  drivers/power/lp8727_charger.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/power/lp8727_charger.c b/drivers/power/lp8727_charger.c
> index d8b7578..699f0ef 100644
> --- a/drivers/power/lp8727_charger.c
> +++ b/drivers/power/lp8727_charger.c
> @@ -454,11 +454,13 @@ static int lp8727_probe(struct i2c_client *cl, const struct i2c_device_id *id)
>         ret = lp8727_register_psy(pchg);
>         if (ret) {
>                 dev_err(pchg->dev, "power supplies register err: %d", ret);
> -               goto error;
> +               goto error_irq;
>         }
>
>         return 0;
>
> +error_irq:
> +       free_irq(pchg->client->irq, pchg);
>  error:
>         kfree(pchg);
>         return ret;
> --
> 1.7.9.5
>
