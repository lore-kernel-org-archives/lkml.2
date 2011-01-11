Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab1AKKQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:16:42 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39665 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab1AKKQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:16:38 -0500
Date: Tue, 11 Jan 2011 11:16:36 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Ben Herrenchmidt <benh@kernel.crashing.org>,
        Uwe =?iso-8859-15?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 1/2] Add a common struct clk
Message-ID: <20110111101636.GF26617@pengutronix.de>
References: <1294199462.347935.472473715866.0.gpush@pororo>
 <1294199462.348449.192344022926.1.gpush@pororo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294199462.348449.192344022926.1.gpush@pororo>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:02:35 up 7 days, 19:10, 39 users,  load average: 0.41, 0.86,
 0.99
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 11:51:02AM +0800, Jeremy Kerr wrote:
> diff --git a/kernel/clk.c b/kernel/clk.c
> new file mode 100644
> index 0000000..8de8fe3
> --- /dev/null
> +++ b/kernel/clk.c
> @@ -0,0 +1,102 @@
> +/*
> + * Copyright (C) 2010 Canonical Ltd <jeremy.kerr@canonical.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * Standard functionality for the common clock API.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/module.h>
> +

...

> +
> +int clk_set_parent(struct clk *clk, struct clk *parent)
> +{
> +	if (clk->ops->set_parent)
> +		return clk->ops->set_parent(clk, parent);
> +	return -ENOSYS;
> +}
> +EXPORT_SYMBOL_GPL(clk_set_parent);

The i.MX clk implementation disables the old parent if clk is enabled
and enables the new parent if clk is enabled (modulo bugs). Shouldn't
we do this here aswell? Otherwise at least the enable_count of both the
old and the new parent will be wrong after calling clk_set_parent for an
enabled clk.

I thought about returning -EBUSY if clk_set_parent is called for an
enabled clk, but this way we could never reparent the cpu clock which I
think is done in the Freescale BSP for power saving.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
