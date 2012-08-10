Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab2HSQXJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 12:23:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46633 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753734Ab2HSQXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 12:23:06 -0400
Subject: Re: [PATCH 1/2] lp8727_charger: free_irq when lp8727_register_psy
 fail
From: Devendra <develkernel412222@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <1343583999-30231-1-git-send-email-develkernel412222@gmail.com>
References: <1343583999-30231-1-git-send-email-develkernel412222@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Aug 2012 10:05:55 +0530
Message-ID: <1344573355.2441.0.camel@test-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry Guys on disturbing you,

Will you guys please ACK, NACK or comment on this?

Thanks,

On Sun, 2012-07-29 at 23:31 +0545, Devendra Naga wrote:
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
>  	ret = lp8727_register_psy(pchg);
>  	if (ret) {
>  		dev_err(pchg->dev, "power supplies register err: %d", ret);
> -		goto error;
> +		goto error_irq;
>  	}
>  
>  	return 0;
>  
> +error_irq:
> +	free_irq(pchg->client->irq, pchg);
>  error:
>  	kfree(pchg);
>  	return ret;


