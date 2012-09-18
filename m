Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757801Ab2IRJ4f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:56:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15689 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086Ab2IRJ4d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:56:33 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 18 Sep 2012 02:55:25 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "julia.lawall@lip6.fr" <julia.lawall@lip6.fr>
Date: Tue, 18 Sep 2012 15:26:27 +0530
Subject: RE: [PATCHv2 6/6] media: Convert struct i2c_msg initialization to
 C99 format
Thread-Topic: [PATCHv2 6/6] media: Convert struct i2c_msg initialization to
 C99 format
Thread-Index: Ac2Vg2WAcDFM42w6TYW4IKYYqeNjywAAEz5Q
Message-ID: <D958900912E20642BCBC71664EFECE3E6DDEFB947B@BGMAIL02.nvidia.com>
References: <1347961843-9376-1-git-send-email-shubhrajyoti@ti.com>
 <1347961843-9376-7-git-send-email-shubhrajyoti@ti.com>
In-Reply-To: <1347961843-9376-7-git-send-email-shubhrajyoti@ti.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Shubhrajyoti D
> Sent: Tuesday, September 18, 2012 3:21 PM
> To: linux-media@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; julia.lawall@lip6.fr; Shubhrajyoti D
> Subject: [PATCHv2 6/6] media: Convert struct i2c_msg initialization to C99
> format
> 
>         Convert the struct i2c_msg initialization to C99 format. This makes
>         maintaining and editing the code simpler. Also helps once other fields
>         like transferred are added in future.
> 
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> ---
>  drivers/media/i2c/msp3400-driver.c |   42
> ++++++++++++++++++++++++++++++-----
>  1 files changed, 36 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/media/i2c/msp3400-driver.c
> b/drivers/media/i2c/msp3400-driver.c
> index aeb22be..b8cef8d 100644
> --- a/drivers/media/i2c/msp3400-driver.c
> +++ b/drivers/media/i2c/msp3400-driver.c
> @@ -119,12 +119,32 @@ int msp_reset(struct i2c_client *client)
>  	static u8 write[3]     = { I2C_MSP_DSP + 1, 0x00, 0x1e };
>  	u8 read[2];
>  	struct i2c_msg reset[2] = {
> -		{ client->addr, I2C_M_IGNORE_NAK, 3, reset_off },
> -		{ client->addr, I2C_M_IGNORE_NAK, 3, reset_on  },
> +		{
> +			.addr = client->addr,
> +			.flags = I2C_M_IGNORE_NAK,
> +			.len = 3,
> +			.buf = reset_off
> +		},
> +		{
> +			.addr = client->addr,
> +			.flags = I2C_M_IGNORE_NAK,
> +			.len = 3,
> +			.buf = reset_on
> +		},
>  	};
>  	struct i2c_msg test[2] = {
> -		{ client->addr, 0,        3, write },
> -		{ client->addr, I2C_M_RD, 2, read  },
> +		{
> +			.addr = client->addr,
> +			.flags = 0,

Does flags not contain 0 by default?
 

> +			.len = 3,
> +			.buf = write
> +		},
> +		{
> +			.addr = client->addr,
> +			.flags = I2C_M_RD,
> +			.len = 2,
> +			.buf = read
> +		},
>  	};
> 
>  	v4l_dbg(3, msp_debug, client, "msp_reset\n");
> @@ -143,8 +163,18 @@ static int msp_read(struct i2c_client *client, int dev,
> int addr)
>  	u8 write[3];
>  	u8 read[2];
>  	struct i2c_msg msgs[2] = {
> -		{ client->addr, 0,        3, write },
> -		{ client->addr, I2C_M_RD, 2, read  }
> +		{
> +			.addr = client->addr,
> +			.flags = 0,
> +			.len = 3,
> +			.buf = write
> +		},
> +		{
> +			.addr = client->addr,
> +			.flags = I2C_M_RD,
> +			.len = 2,
> +			.buf = read
> +		}
>  	};
> 
>  	write[0] = dev + 1;
> --
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
