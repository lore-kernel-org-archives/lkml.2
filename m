Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761534Ab2CORPq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:15:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59214 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417Ab2CORPo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:15:44 -0400
Date: Thu, 15 Mar 2012 21:15:38 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ryan Mallon <rmallon@gmail.com>,
        Woogyom Kim <milo.kim@ti.com>, Daniel Jeong <daniel.jeong@ti.com>,
        Minkyu Kang <mk7.kang@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Rhyland Klein <rklein@nvidia.com>,
        Peter Edwards <sweetlilmre@gmail.com>
Subject: Re: [PATCH] power_supply: Convert power_supply i2c drivers to
 module_i2c_driver
Message-ID: <20120315171538.GD11441@oksana.dev.rtsoft.ru>
References: <1327128174.24831.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1327128174.24831.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 02:42:54PM +0800, Axel Lin wrote:
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

Cosmetic nit: I don't think that there should be an empty line.
I.e. it should be just as we do with MODULE_DEVICE_TABLE and
other macros:

static const struct i2c_device_id .. = {
	...
};
MODULE_DEVICE_TABLE(...)

static struct i2c_driver ... = {
	...
};
module_i2c_driver(...);

I fixed it up and applied the patch. Thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
