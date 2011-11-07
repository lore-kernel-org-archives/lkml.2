Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932807Ab1KGQvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 11:51:23 -0500
Received: from imr4.ericy.com ([198.24.6.9]:44912 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755625Ab1KGQvV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 11:51:21 -0500
Subject: Re: [PATCH] hwmon: lm63: Add support for the NatSemi LM96163.
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1320661258-1775-1-git-send-email-thierry.reding@avionic-design.de>
References: <1320661258-1775-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Mon, 7 Nov 2011 08:49:26 -0800
Message-ID: <1320684566.2309.115.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2011-11-07 at 05:20 -0500, Thierry Reding wrote:
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
>  drivers/hwmon/lm63.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/hwmon/lm63.c b/drivers/hwmon/lm63.c
> index 508cb29..94e373c 100644
> --- a/drivers/hwmon/lm63.c
> +++ b/drivers/hwmon/lm63.c
> @@ -483,7 +483,7 @@ static int lm63_detect(struct i2c_client *new_client,
>  		return -ENODEV;
>  	}
>  
> -	if (chip_id == 0x41 && address == 0x4c)
> +	if ((chip_id == 0x41 || chip_id == 0x49) && address == 0x4c)
>  		strlcpy(info->type, "lm63", I2C_NAME_SIZE);
>  	else if (chip_id == 0x51 && (address == 0x18 || address == 0x4e))
>  		strlcpy(info->type, "lm64", I2C_NAME_SIZE);

Minor - the new chip should be mentioned in drivers/hwmon/Kconfig and in
Documentation/hwmon/lm63.

My main concern is that LM96163 supports a high resolution PWM mode.
Since that mode is much more convenient than the LM63-compatible mode, I
think it is likely to be enabled in designs using LM96163, and it should
be supported by the driver if we add support for LM96163.

Thanks,
Guenter


