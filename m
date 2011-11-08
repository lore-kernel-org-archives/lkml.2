Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab1KHJP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 04:15:26 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:22400 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab1KHJPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 04:15:21 -0500
Date: Tue, 8 Nov 2011 10:15:12 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: lm63: Add support for the NatSemi LM96163.
Message-ID: <20111108101512.7baa9d29@endymion.delvare>
In-Reply-To: <1320661258-1775-1-git-send-email-thierry.reding@avionic-design.de>
References: <1320661258-1775-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 Nov 2011 11:20:58 +0100, Thierry Reding wrote:
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

Oh, BTW... there's really no reason to reuse the "lm63" name when both
chips are not fully compatible. Please introduce a new name for the new
chip. It's fairly easy.

I've added detection support to sensors-detect:
http://dl.lm-sensors.org/lm-sensors/files/sensors-detect

I would appreciate if you could try it and report.

I would also appreciate if you could provide a dump of your chip's
registers (using the i2c-dev driver with i2cdump - part of the
i2c-tools package) for my collection.

-- 
Jean Delvare
