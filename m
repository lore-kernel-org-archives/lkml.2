Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0E2McO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 08:32:14 -0400
Received: from poutre.nerim.net ([62.4.16.124]:61511 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752954Ab0E2McK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 08:32:10 -0400
Date: Sat, 29 May 2010 14:32:06 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Linux Input <linux-input@vger.kernel.org>,
       Christopher Heiny <cheiny@synaptics.com>,
       Allie Xiong <axiong@synaptics.com>,
       William Manson <wmanson@synaptics.com>,
       Joerie de Gram <j.de.gram@gmail.com>
Subject: Re: [RFC PATCH 1/1] input/touchscreen: Synaptics Touchscreen Driver
Message-ID: <20100529143206.1b3343d7@hyperion.delvare>
In-Reply-To: <1275092980-29208-2-git-send-email-cheiny@synaptics.com>
References: <1275092980-29208-1-git-send-email-cheiny@synaptics.com>
	<1275092980-29208-2-git-send-email-cheiny@synaptics.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

On Fri, 28 May 2010 17:29:40 -0700, Christopher Heiny wrote:
> Initial driver for Synaptics touchscreens using RMI4 protocol.
> 
> Signed-off-by: William Manson <WManson@synaptics.com>
> Signed-off-by: Allie Xiong <axiong@synaptics.com>
> Signed-off-by: Christopher Heiny <cheiny@synaptics.com>

You can add:

Acked-by: Jean Delvare <khali@linux-fr.org>

for the i2c parts. I still have a few comments you might be interested
in, maybe for a future incremental patch:

> (...)
> --- /dev/null
> +++ b/drivers/input/touchscreen/rmi_i2c_gta01.c
> @@ -0,0 +1,117 @@
> (...)
> +static void
> +rmi_i2c_release(struct device *dev)
> +{
> +	struct platform_device *pd = container_of(dev,
> +			struct platform_device, dev);

You could use to_platform_device(dev) instead, it's more readable.

> (...)
> --- /dev/null
> +++ b/drivers/input/touchscreen/rmi_phys_i2c.c
> (...)
> +/* TODO: for multiple device support will need a per-device mutex */

This comment would be better placed below, where page_mutex is declared.

> +#define DRIVER_NAME "rmi4-i2c"
> +
> +/* TODO: for multiple device support will need a per-device device name */

This comment is confusing... you would need different names if you were
supporting different device _types_ in the same driver. But you
definitely do _not_ need different names to support several devices of
the same type in a given system.

> +#define DEVICE_NAME "rmi4-i2c"

The use of dashes in i2c device names is strongly discouraged.
Including "i2c" in these names is discouraged as well, as it is
redundant. "rmi4_ts" would be a better name IMHO.

> (...)
> +static int
> +rmi_i2c_probe(struct i2c_client *client, const struct i2c_device_id *dev_id)
> +{
> +	struct instance_data *id;
> +	int retval = 0;
> +	int i;
> +	bool found = false;
> +
> +	struct rmi_i2c_data *rmii2cdata;
> +	struct rmi_i2c_platformdata *platformdata;
> +
> +	pr_debug("Probing i2c RMI device\n");
> +
> +	/* Allocate and initialize the instance data for this client */
> +	id = kzalloc(sizeof(*id) * 2, GFP_KERNEL);

I still don't get the * 2.

> (...)
> +	/* cast to our struct rmi_i2c_data so we know
> +	the fields (see rmi_ic2.h) */
> +	rmii2cdata = ((struct rmi_i2c_data *)(client->dev.platform_data));

Explicit cast still not needed, you can just write:

	rmii2cdata = client->dev.platform_data;

-- 
Jean Delvare
