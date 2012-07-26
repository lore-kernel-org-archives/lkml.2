Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2GZV77 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:59:59 -0400
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:53121 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753453Ab2GZV74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:59:56 -0400
Subject: Re: [PATCH] cx25840: Declare MODULE_FIRMWARE usage
From: Andy Walls <awalls@md.metrocast.net>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Date: Thu, 26 Jul 2012 17:59:14 -0400
In-Reply-To: <1343321059-124171-1-git-send-email-tim.gardner@canonical.com>
References: <1343321059-124171-1-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1343339959.2575.3.camel@palomino.walls.org>
Mime-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-26_06:2012-07-26,2012-07-26,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=6.0.2-1203120001 definitions=main-1207260263
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 10:44 -0600, Tim Gardner wrote:
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: linux-media@vger.kernel.org
> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> ---
>  drivers/media/video/cx25840/cx25840-firmware.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/media/video/cx25840/cx25840-firmware.c b/drivers/media/video/cx25840/cx25840-firmware.c
> index 8150200..b3169f9 100644
> --- a/drivers/media/video/cx25840/cx25840-firmware.c
> +++ b/drivers/media/video/cx25840/cx25840-firmware.c
> @@ -61,6 +61,10 @@ static void end_fw_load(struct i2c_client *client)
>  	cx25840_write(client, 0x803, 0x03);
>  }
>  
> +#define CX2388x_FIRMWARE "v4l-cx23885-avcore-01.fw"
> +#define CX231xx_FIRMWARE "v4l-cx231xx-avcore-01.fw"
> +#define CX25840_FIRMWARE "v4l-cx25840.fw"
> +
>  static const char *get_fw_name(struct i2c_client *client)
>  {
>  	struct cx25840_state *state = to_state(i2c_get_clientdata(client));
> @@ -68,10 +72,10 @@ static const char *get_fw_name(struct i2c_client *client)
>  	if (firmware[0])
>  		return firmware;
>  	if (is_cx2388x(state))
> -		return "v4l-cx23885-avcore-01.fw";
> +		return CX2388x_FIRMWARE;
>  	if (is_cx231xx(state))
> -		return "v4l-cx231xx-avcore-01.fw";
> -	return "v4l-cx25840.fw";
> +		return CX231xx_FIRMWARE;
> +	return CX25840_FIRMWARE;
>  }
>  
>  static int check_fw_load(struct i2c_client *client, int size)
> @@ -164,3 +168,8 @@ int cx25840_loadfw(struct i2c_client *client)
>  
>  	return check_fw_load(client, size);
>  }
> +
> +MODULE_FIRMWARE(CX2388x_FIRMWARE);
> +MODULE_FIRMWARE(CX231xx_FIRMWARE);
> +MODULE_FIRMWARE(CX25840_FIRMWARE);
> +

How will the firmware attribute in the .module_info section be used?

For any one model of TV capture device, the cx25840 only needs one of
the above firmware files.  The others need not exist.

I would not want anything in user or kernel space to refuse to load the
module just because all 3 firmware files are not present.

Regards,
Andy

