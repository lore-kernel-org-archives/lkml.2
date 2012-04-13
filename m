Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab2DMOkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:40:35 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38976 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2DMOke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:40:34 -0400
Date: Fri, 13 Apr 2012 16:40:29 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: g.liakhovetski@gmx.de, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: i.mx35 increase dma consistent region size
Message-ID: <20120413144029.GP3852@pengutronix.de>
References: <1334167274-29524-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334167274-29524-1-git-send-email-alexg@meprolight.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:36:51 up 152 days, 22:23, 42 users,  load average: 0.00, 0.04,
 0.20
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 09:01:14PM +0300, Alex Gershgorin wrote:
> The default size of the consistent DMA region is 2MB
> without this patch, attempt to allocate more than 2MB
> is causing allocation failure
> 
> Signed-off-by: Alex Gershgorin <alexg@meprolight.com>
> ---
>  arch/arm/mach-imx/mm-imx3.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-imx/mm-imx3.c b/arch/arm/mach-imx/mm-imx3.c
> index 7412738..a2c0c7d 100644
> --- a/arch/arm/mach-imx/mm-imx3.c
> +++ b/arch/arm/mach-imx/mm-imx3.c
> @@ -201,6 +201,7 @@ static struct map_desc mx35_io_desc[] __initdata = {
>  void __init mx35_map_io(void)
>  {
>  	iotable_init(mx35_io_desc, ARRAY_SIZE(mx35_io_desc));
> +	init_consistent_dma_size(SZ_8M);

I don't know what to think about this. You probably have a board with
camera support and thus need bigger buffers, right? Nevertheless this
patch affects all i.MX35 users, even the ones without camera support.

Another possibility would be to make this board specific.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
