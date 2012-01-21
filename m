Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab2AUHyH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 02:54:07 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49189 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab2AUHyB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 02:54:01 -0500
Message-ID: <4F1A6F5E.70909@gmail.com>
Date: Sat, 21 Jan 2012 18:55:10 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Woogyom Kim <milo.kim@ti.com>,
        Daniel Jeong <daniel.jeong@ti.com>, Minkyu Kang <mk7.kang@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Peter Edwards <sweetlilmre@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH] power_supply: Convert power_supply i2c drivers to module_i2c_driver
References: <1327128174.24831.1.camel@phoenix>
In-Reply-To: <1327128174.24831.1.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/01/12 17:42, Axel Lin wrote:
> Factor out some boilerplate code for i2c driver registration
> into module_i2c_driver.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Woogyom Kim <milo.kim@ti.com>
> Cc: Daniel Jeong <daniel.jeong@ti.com>
> Cc: Minkyu Kang <mk7.kang@samsung.com>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Rhyland Klein <rklein@nvidia.com>
> Cc: Peter Edwards <sweetlilmre@gmail.com>
> ---
>  drivers/power/ds2782_battery.c   |   12 +-----------
>  drivers/power/lp8727_charger.c   |   13 +------------
>  drivers/power/max17040_battery.c |   12 +-----------
>  drivers/power/max17042_battery.c |   12 +-----------
>  drivers/power/sbs-battery.c      |   12 +-----------
>  drivers/power/z2_battery.c       |   13 +------------
>  6 files changed, 6 insertions(+), 68 deletions(-)
>
> diff --git a/drivers/power/ds2782_battery.c b/drivers/power/ds2782_battery.c
> index bfbce5d..6e3d76a 100644
> --- a/drivers/power/ds2782_battery.c
> +++ b/drivers/power/ds2782_battery.c
> @@ -404,17 +404,7 @@ static struct i2c_driver ds278x_battery_driver = {
>  	.id_table	= ds278x_id,
>  };
>  
> -static int __init ds278x_init(void)
> -{
> -	return i2c_add_driver(&ds278x_battery_driver);
> -}
> -module_init(ds278x_init);
> -
> -static void __exit ds278x_exit(void)
> -{
> -	i2c_del_driver(&ds278x_battery_driver);
> -}
> -module_exit(ds278x_exit);
> +module_i2c_driver(ds278x_battery_driver);
>  
>  MODULE_AUTHOR("Ryan Mallon");
>  MODULE_DESCRIPTION("Maxim/Dallas DS2782 Stand-Alone Fuel Gauage IC driver");

For ds2782:

Acked-by: Ryan Mallon <rmallon@gmail.com>

