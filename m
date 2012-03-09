Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab2CIK5a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 05:57:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51222 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab2CIK52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 05:57:28 -0500
Date: Fri, 9 Mar 2012 11:56:45 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, vinod.koul@intel.com, linux@arm.linux.org.uk,
        kernel@pengutronix.de
Subject: Re: [PATCH v2 00/13] dmaengine: imx-dma: merge dma arch code into
 dmaengine.
Message-ID: <20120309105645.GA3852@pengutronix.de>
References: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331130825-14947-1-git-send-email-javier.martin@vista-silicon.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:48:23 up 117 days, 18:35, 60 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 03:33:32PM +0100, Javier Martin wrote:
> The following series have to be applied on top of the following patches:
> [PATCH v2 1/2] dmaengine: Add support for MEMCPY for imx-dma.
> [PATCH v3 2/2] dmaengine: Add support for multiple descriptors for imx-dma.
> 
> As discussed with Vinod and Sascha, the file 'arch/arm/mach-imx/dma-v1.c'
> is deprecated and no new patches are accepted for it.
> 
> This series merges this code into the imx-dma.c dmaengine driver.
> 
> Changes since v1:
>  - Merge patch 14 with 01.
>  - Add a proper changelog to each patch of the series.
> 
> [PATCH v2 01/13] dmaengine: imx-dma: merge old dma-v1.c with imx-dma.c
> [PATCH v2 02/13] dmaengine: imx-dma: remove data member from internal structure.
> [PATCH v2 03/13] dmaengine: imx-dma: remove dma_mode member of internal structure.
> [PATCH v2 04/13] dmaengine: imx-dma: remove 'imxdma_setup_mem2mem_hw' function.
> [PATCH v2 05/13] dmaengine: imx-dma: remove 'imxdma_config_channel_hw' function.
> [PATCH v2 06/13] dmaengine: imx-dma: remove 'imxdma_setup_sg_hw' function.
> [PATCH v2 07/13] dmaengine: imx-dma: remove sg member from internal structure.
> [PATCH v2 08/13] dmaengine: imx-dma: remove 'in_use' field of 'internal' structure.
> [PATCH v2 09/13] dmaengine: imx-dma: remove 'resbytes' field of 'internal' structure.
> [PATCH v2 10/13] dmaengine: imx-dma: remove internal structure.
> [PATCH v2 11/13] dmaengine: imx-dma: remove unused arg of imxdma_sg_next.
> [PATCH v2 12/13] dmaengine: imx-dma: remove 'imx_dmav1_baseaddr' and 'dma_clk'.
> [PATCH v2 13/13] dmaengine: imx-dma: use 'dev_dbg' and 'dev_warn' for messages.

I didn't look at the individual patches but only on the end result and
overall it looks good. There are several things left for further cleanup:

- use resources for irq and base address
- use platform device id rather than cpu_is_* to distinguish
  between the different device types.
- request_irq for i.MX21/27 in alloc_chan_resources instead in probe
- Use all available channels. In the time we had dmaengine users and
  legacy API users 8 channels were reserved for the old API and 8
  channels for the dmaengine API.

I think the first three points can be done in a later series, the last
one should be trivial to fix now.

Some comments follow to the individual patches.

And, oh:

Tested-by: Sascha Hauer <s.hauer@pengutronix.de

Thanks for working on this topic, it has long been on my todo list.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
