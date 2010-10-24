Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab0JXPGZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 11:06:25 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:43762 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876Ab0JXPGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 11:06:21 -0400
X-Spam-Flag: NO
X-Spam-Score: -21.89
Message-ID: <4CC4418F.3070507@tremplin-utc.net>
Date: Sun, 24 Oct 2010 16:24:15 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.11) Gecko/20101020 Mandriva/3.1.5-1mdv2011.0 (2011.0) Thunderbird/3.1.5
MIME-Version: 1.0
To: Samu Onkalo <samu.p.onkalo@nokia.com>
CC: khali@linux-fr.org, guenter.roeck@ericsson.com, jic23@cam.ac.uk,
        lm-sensors@lm-sensors.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] hwmon: lis3: restore axis enabled bits
References: <1287748654-2626-1-git-send-email-samu.p.onkalo@nokia.com> <1287748654-2626-7-git-send-email-samu.p.onkalo@nokia.com>
In-Reply-To: <1287748654-2626-7-git-send-email-samu.p.onkalo@nokia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 22-10-10 13:57, Samu Onkalo schreef:
> All axis enable bits are set to 0 at module remove.
> Restore reset default value at init.
>
> Signed-off-by: Samu Onkalo<samu.p.onkalo@nokia.com>
Acked-by: Eric Piel <eric.piel@tremplin-utc.net>
> ---
>   drivers/hwmon/lis3lv02d_i2c.c |    2 +-
>   drivers/hwmon/lis3lv02d_spi.c |    2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/hwmon/lis3lv02d_i2c.c b/drivers/hwmon/lis3lv02d_i2c.c
> index 98983cc..36171bf 100644
> --- a/drivers/hwmon/lis3lv02d_i2c.c
> +++ b/drivers/hwmon/lis3lv02d_i2c.c
> @@ -83,7 +83,7 @@ static int lis3_i2c_init(struct lis3lv02d *lis3)
>   	if (ret<  0)
>   		return ret;
>
> -	reg |= CTRL1_PD0;
> +	reg |= CTRL1_PD0 | CTRL1_Xen | CTRL1_Yen | CTRL1_Zen;
>   	return lis3->write(lis3, CTRL_REG1, reg);
>   }
>
> diff --git a/drivers/hwmon/lis3lv02d_spi.c b/drivers/hwmon/lis3lv02d_spi.c
> index b9be5e3..778885d 100644
> --- a/drivers/hwmon/lis3lv02d_spi.c
> +++ b/drivers/hwmon/lis3lv02d_spi.c
> @@ -50,7 +50,7 @@ static int lis3_spi_init(struct lis3lv02d *lis3)
>   	if (ret<  0)
>   		return ret;
>
> -	reg |= CTRL1_PD0;
> +	reg |= CTRL1_PD0 | CTRL1_Xen | CTRL1_Yen | CTRL1_Zen;
>   	return lis3->write(lis3, CTRL_REG1, reg);
>   }
>

