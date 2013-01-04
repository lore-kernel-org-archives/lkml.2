Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab3ADGRt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 01:17:49 -0500
Received: from perceval.ideasonboard.com ([95.142.166.194]:48597 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab3ADGRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 01:17:46 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Lad, Prabhakar" <prabhakar.lad@ti.com>,
        Manjunath Hadli <manjunath.hadli@ti.com>
Subject: Re: [PATCH v2] adv7343: use devm_kzalloc() instead of kzalloc()
Date: Fri, 04 Jan 2013 07:19:19 +0100
Message-ID: <1742549.yh29KufX9Q@avalon>
User-Agent: KMail/4.9.2 (Linux/3.6.11-gentoo; KDE/4.9.2; x86_64; ; )
In-Reply-To: <1357276277-21812-1-git-send-email-prabhakar.lad@ti.com>
References: <1357276277-21812-1-git-send-email-prabhakar.lad@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Prabhakar,

Thank you for the patches.

For the whole set,

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

On Friday 04 January 2013 10:41:15 Lad, Prabhakar wrote:
> I2C drivers can use devm_kzalloc() too in their .probe() methods. Doing so
> simplifies their clean up paths.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> ---
>  Changes for v2:
>  1: Fixed comments pointed out by Laurent.
> 
>  drivers/media/i2c/adv7343.c |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/adv7343.c b/drivers/media/i2c/adv7343.c
> index 2b5aa67..432eb5f 100644
> --- a/drivers/media/i2c/adv7343.c
> +++ b/drivers/media/i2c/adv7343.c
> @@ -397,7 +397,8 @@ static int adv7343_probe(struct i2c_client *client,
>  	v4l_info(client, "chip found @ 0x%x (%s)\n",
>  			client->addr << 1, client->adapter->name);
> 
> -	state = kzalloc(sizeof(struct adv7343_state), GFP_KERNEL);
> +	state = devm_kzalloc(&client->dev, sizeof(struct adv7343_state),
> +			     GFP_KERNEL);
>  	if (state == NULL)
>  		return -ENOMEM;
> 
> @@ -431,16 +432,13 @@ static int adv7343_probe(struct i2c_client *client,
>  		int err = state->hdl.error;
> 
>  		v4l2_ctrl_handler_free(&state->hdl);
> -		kfree(state);
>  		return err;
>  	}
>  	v4l2_ctrl_handler_setup(&state->hdl);
> 
>  	err = adv7343_initialize(&state->sd);
> -	if (err) {
> +	if (err)
>  		v4l2_ctrl_handler_free(&state->hdl);
> -		kfree(state);
> -	}
>  	return err;
>  }
> 
> @@ -451,7 +449,6 @@ static int adv7343_remove(struct i2c_client *client)
> 
>  	v4l2_device_unregister_subdev(sd);
>  	v4l2_ctrl_handler_free(&state->hdl);
> -	kfree(state);
> 
>  	return 0;
>  }
-- 
Regards,

Laurent Pinchart

