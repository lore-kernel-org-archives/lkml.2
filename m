Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab2IYDyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 23:54:49 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33047 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2IYDyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 23:54:47 -0400
MIME-Version: 1.0
In-Reply-To: <1347897325-20684-1-git-send-email-shubhrajyoti@ti.com>
References: <1347897325-20684-1-git-send-email-shubhrajyoti@ti.com>
Date: Tue, 25 Sep 2012 09:24:46 +0530
Message-ID: <CAM=Q2cv8ewLvKafU_iaxM4cq+G54K2rDu4Hd6Cj5cEtpZVf1qw@mail.gmail.com>
Subject: Re: [PATCH] matroxfb: Convert struct i2c_msg initialization to C99 format
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 9:25 PM, Shubhrajyoti D <shubhrajyoti@ti.com> wrote:
> Convert the struct i2c_msg initialization to C99 format. This makes
> maintaining and editing the code simpler. Also helps once other fields
> like transferred are added in future.
>
> Thanks to Julia Lawall <julia.lawall@lip6.fr>  for automating the conversion

ping.

>
> Signed-off-by: Shubhrajyoti D <shubhrajyoti@ti.com>
> ---
> the cocci file was posted
> http://www.mail-archive.com/cocci@diku.dk/msg02753.html
>
>  drivers/video/matrox/matroxfb_maven.c |   15 +++++++++++++--
>  1 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/video/matrox/matroxfb_maven.c b/drivers/video/matrox/matroxfb_maven.c
> index 217678e..fb5c123 100644
> --- a/drivers/video/matrox/matroxfb_maven.c
> +++ b/drivers/video/matrox/matroxfb_maven.c
> @@ -137,8 +137,19 @@ static int* get_ctrl_ptr(struct maven_data* md, int idx) {
>
>  static int maven_get_reg(struct i2c_client* c, char reg) {
>         char dst;
> -       struct i2c_msg msgs[] = {{ c->addr, I2C_M_REV_DIR_ADDR, sizeof(reg), &reg },
> -                                { c->addr, I2C_M_RD | I2C_M_NOSTART, sizeof(dst), &dst }};
> +       struct i2c_msg msgs[] = {{
> +                                       .addr = c->addr,
> +                                       .flags = I2C_M_REV_DIR_ADDR,
> +                                       .len = sizeof(reg),
> +                                       .buf = &reg
> +                               },
> +                               {
> +                                       .addr = c->addr,
> +                                       .flags = I2C_M_RD | I2C_M_NOSTART,
> +                                       .len = sizeof(dst),
> +                                       .buf = &dst
> +                               }
> +       };
>         s32 err;
>
>         err = i2c_transfer(c->adapter, msgs, 2);
> --
> 1.7.5.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
