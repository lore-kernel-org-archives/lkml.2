Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2AZRfH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 12:35:07 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34098 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab2AZRfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 12:35:00 -0500
Date: Thu, 26 Jan 2012 18:34:44 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        linux-mmc@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        linux-serial@vger.kernel.org
Subject: Re: [alsa-devel] [PATCH 1/7 v2] dmaengine: add a simple dma library
Message-ID: <20120126173444.GM5446@pengutronix.de>
References: <1327589784-4287-1-git-send-email-g.liakhovetski@gmx.de>
 <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327589784-4287-2-git-send-email-g.liakhovetski@gmx.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:25:56 up 75 days,  1:13, 59 users,  load average: 2.73, 5.58,
 6.82
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guennadi,

On Thu, Jan 26, 2012 at 03:56:18PM +0100, Guennadi Liakhovetski wrote:
> This patch adds a library of functions, helping to implement dmaengine
> drivers for hardware, unable to handle scatter-gather lists natively.
> The first version of this driver only supports memcpy and slave DMA
> operation.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
> 

[...]

> +
> +/*
> + * For slave DMA we assume, that there is a finite number of DMA slaves in the
> + * system, and that each such slave can only use a finite number of channels.
> + * We use slave channel IDs to make sure, that no such slave channel ID is
> + * allocated more than once.
> + */
> +static unsigned int slave_num = 256;
> +module_param(slave_num, uint, 0444);
> +
> +/* A bitmask with slave_num bits */
> +static unsigned long *simple_slave_used;

You never check that the slave ids passed into this code are
within the range of slave_num. Given that this is a user changeable
value this is a bit flawy.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
