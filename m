Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab0IEOQD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 10:16:03 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:38378 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab0IEOQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 10:16:00 -0400
Date: Sun, 5 Sep 2010 16:15:44 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Rhyland Klein <rklein@nvidia.com>
Cc: cbouatmailru@gmail.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, achew@nvidia.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH v2] power supply: add driver for TI BQ20Z75 gas gauge IC
Message-ID: <20100905161544.3a9d9e03@hyperion.delvare>
In-Reply-To: <1283448586-14613-1-git-send-email-rklein@nvidia.com>
References: <1283448586-14613-1-git-send-email-rklein@nvidia.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rhyland,

On Thu,  2 Sep 2010 10:29:46 -0700, rklein@nvidia.com wrote:
> From: Rhyland Klein <rklein@nvidia.com>
> 
> this driver depends on I2C and uses SMBUS for communication with the host.
> 
> Addressed comments from reviews by Mark Brown and Jean Delvare.
>   * Cleaned up whitespace and alignment issues
>   * changed return codes to more appropriate values
>   * change Kconfig option name to be consistent with existing devices
>   * removed global struct and moved to device specific data
>   * changed printk to dev_dbg

Looks much better. A few details could be ironed out:

> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
> ---
>  drivers/power/Kconfig   |    7 +
>  drivers/power/Makefile  |    1 +
>  drivers/power/bq20z75.c |  387 +++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 395 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/power/bq20z75.c
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 8e9ba17..53d9cbf 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -142,4 +142,11 @@ config CHARGER_PCF50633
>  	help
>  	 Say Y to include support for NXP PCF50633 Main Battery Charger.
>  
> +config BATTERY_BQ20Z75
> +        tristate "TI BQ20z75 gas gauge"
> +        depends on I2C
> +        help
> +         Say Y to include support for TI bq20z75 SBS-compliant

Please leave the BQ in capitals for consistency.

> +         gas gauge and protection IC.
> +
>  endif # POWER_SUPPLY
> diff --git a/drivers/power/Makefile b/drivers/power/Makefile
> index 0005080..cdc403d 100644
> --- a/drivers/power/Makefile
> +++ b/drivers/power/Makefile
> @@ -34,3 +34,4 @@ obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
>  obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
>  obj-$(CONFIG_BATTERY_Z2)	+= z2_battery.o
>  obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
> +obj-$(CONFIG_BATTERY_BQ20Z75)	+= bq20z75.o

Would be nice to move this entry right before CONFIG_BATTERY_BQ27x00.
Same for Kconfig, BTW.

> diff --git a/drivers/power/bq20z75.c b/drivers/power/bq20z75.c
> new file mode 100644
> index 0000000..a7eeedf
> --- /dev/null
> +++ b/drivers/power/bq20z75.c
> (...)
> +static int bq20z75_get_property(struct power_supply *psy,
> +	enum power_supply_property psp, union power_supply_propval *val);

You no longer need this forward declaration.

Once these small details are fixed, feel free to add:

Reviewed-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
