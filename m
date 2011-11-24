Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab1KXSmW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 13:42:22 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37079 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724Ab1KXSmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 13:42:21 -0500
Date: Thu, 24 Nov 2011 22:42:15 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v5] power: bq20z75: devicetree init support
Message-ID: <20111124184215.GA29135@oksana.dev.rtsoft.ru>
References: <1316031547-18281-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1316031547-18281-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rhyland,

Got this:

  CC [M]  drivers/power/bq20z75.o
drivers/power/bq20z75.c: In function ‘bq20z75_of_populate_pdata’:
drivers/power/bq20z75.c:630:21: error: storage size of ‘gpio_flags’ isn’t known
drivers/power/bq20z75.c:668:2: error: implicit declaration of function ‘of_get_named_gpio_flags’ [-Werror=implicit-function-declaration]
drivers/power/bq20z75.c:671:19: error: ‘OF_GPIO_ACTIVE_LOW’ undeclared (first use in this function)
drivers/power/bq20z75.c:671:19: note: each undeclared identifier is reported only once for each function it appears in
drivers/power/bq20z75.c:630:21: warning: unused variable ‘gpio_flags’ [-Wunused-variable]
drivers/power/bq20z75.c:627:29: warning: unused variable ‘dtid’ [-Wunused-variable]

I fixed this by...

On Wed, Sep 14, 2011 at 01:19:07PM -0700, Rhyland Klein wrote:

> +#if defined(CONFIG_OF)
> +#include <linux/of_device.h>

Adding linux/of_gpio.h

> +static const struct of_device_id bq20z75_dt_ids[] = {
> +	{ .compatible = "ti,bq20z75" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, bq20z75_dt_ids);
> +
> +static struct bq20z75_platform_data *bq20z75_of_populate_pdata(
> +	struct i2c_client *client)
> +{
> +	const struct of_device_id *dtid;

And deleting that line.


Applied to battery-2.6.git, but please double check if everything
is OK.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
