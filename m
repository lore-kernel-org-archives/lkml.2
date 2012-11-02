Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2KBM4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:56:39 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:42401 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab2KBM4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:56:37 -0400
MIME-Version: 1.0
In-Reply-To: <1351858169-5742-1-git-send-email-yamanetoshi@gmail.com>
References: <1351858121-5708-1-git-send-email-yamanetoshi@gmail.com>
	<1351858169-5742-1-git-send-email-yamanetoshi@gmail.com>
Date: Fri, 2 Nov 2012 13:56:36 +0100
Message-ID: <CA+MoWDpYP3LsbYZ82hxKeaGa=o2yOnhExvTFkYomOL-2p4aNoA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Staging/media: Use dev_ printks in go7007/wis-ov7640.c
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 1:09 PM, YAMANE Toshiaki <yamanetoshi@gmail.com> wrote:
> fixed below checkpatch warnings.
> - WARNING: Prefer netdev_dbg(netdev, ... then dev_dbg(dev, ... then pr_debug(...  to printk(KERN_DEBUG ...
> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
>
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
Tested-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  drivers/staging/media/go7007/wis-ov7640.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/go7007/wis-ov7640.c b/drivers/staging/media/go7007/wis-ov7640.c
> index eb5efc9..fe46374 100644
> --- a/drivers/staging/media/go7007/wis-ov7640.c
> +++ b/drivers/staging/media/go7007/wis-ov7640.c
> @@ -59,12 +59,12 @@ static int wis_ov7640_probe(struct i2c_client *client,
>
>         client->flags = I2C_CLIENT_SCCB;
>
> -       printk(KERN_DEBUG
> +       dev_dbg(&client->dev,
>                 "wis-ov7640: initializing OV7640 at address %d on %s\n",
>                 client->addr, adapter->name);
>
>         if (write_regs(client, initial_registers) < 0) {
> -               printk(KERN_ERR "wis-ov7640: error initializing OV7640\n");
> +               dev_err(&client->dev, "wis-ov7640: error initializing OV7640\n");
>                 return -ENODEV;
>         }
>
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Peter
