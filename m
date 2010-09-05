Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0IEQsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 12:48:06 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:42965 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0IEQsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 12:48:05 -0400
Date: Sun, 5 Sep 2010 18:47:51 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guillem Jover <guillem@hadrons.org>
Cc: Riku Voipio <riku.voipio@iki.fi>, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 2/2] hwmon: (f75375s) Do not overwrite
 values  read from registers
Message-ID: <20100905184751.4fe7bc09@hyperion.delvare>
In-Reply-To: <20100903030132.GA16049@gaara.hadrons.org>
References: <20100903030132.GA16049@gaara.hadrons.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Sep 2010 05:01:32 +0200, Guillem Jover wrote:
> All bits in the values read from registers to be used for the next
> write were getting overwritten, avoid doing so to not mess with the
> current configuration.
> 
> Signed-off-by: Guillem Jover <guillem@hadrons.org>
> ---
>  drivers/hwmon/f75375s.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
> index e5828c0..9638d58 100644
> --- a/drivers/hwmon/f75375s.c
> +++ b/drivers/hwmon/f75375s.c
> @@ -298,7 +298,7 @@ static int set_pwm_enable_direct(struct i2c_client *client, int nr, int val)
>  		return -EINVAL;
>  
>  	fanmode = f75375_read8(client, F75375_REG_FAN_TIMER);
> -	fanmode = ~(3 << FAN_CTRL_MODE(nr));
> +	fanmode &= ~(3 << FAN_CTRL_MODE(nr));
>  
>  	switch (val) {
>  	case 0: /* Full speed */
> @@ -350,7 +350,7 @@ static ssize_t set_pwm_mode(struct device *dev, struct device_attribute *attr,
>  
>  	mutex_lock(&data->update_lock);
>  	conf = f75375_read8(client, F75375_REG_CONFIG1);
> -	conf = ~(1 << FAN_CTRL_LINEAR(nr));
> +	conf &= ~(1 << FAN_CTRL_LINEAR(nr));
>  
>  	if (val == 0)
>  		conf |= (1 << FAN_CTRL_LINEAR(nr)) ;

Applied, thanks.

-- 
Jean Delvare
