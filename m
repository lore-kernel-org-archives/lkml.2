Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757609Ab2BIORV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 09:17:21 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46532 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab2BIORU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 09:17:20 -0500
Date: Thu, 9 Feb 2012 15:17:03 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Javier Martin <javier.martin@vista-silicon.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
        vinod.koul@intel.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, kernel@pengutronix.de
Subject: Re: [PATCH 1/2] i.MX DMA: Add support for 2D transfers.
Message-ID: <20120209141703.GB3852@pengutronix.de>
References: <1328285474-26365-1-git-send-email-javier.martin@vista-silicon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328285474-26365-1-git-send-email-javier.martin@vista-silicon.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:02:14 up 88 days, 21:49, 61 users,  load average: 0.32, 0.49,
 0.48
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 05:11:13PM +0100, Javier Martin wrote:
> DMAC present in i.MX2 and i.MX1 chips have two
> 2D configuration slots that any DMA channel can
> use to make 2D DMA transfers.
> 
> Signed-off-by: Javier Martin <javier.martin@vista-silicon.com>

My problem with this patch is that it adds new code to
arch/arm/mach-imx/dma-v1.c.
The original intention of having a legacy driver in arch/arm/mach-imx/dma-v1.c
and a dmaengine driver in drivers/dma was that we move remove the
arch/arm parts to drivers/dma once all users have switched to the new
API.  I fixed the sound drivers and the mxcmmc driver already.  We
currently have the imxmmc driver and the i.MX1/2 camera drivers left
in the tree.  The imxmmc driver is broken for ages and I think we can
remove it when nobody takes care of putting it back to work. You seem to
work on the i.MX2 camera driver and thus you should be able to fix it
(do you use DMA here or the EMMA engine?). This leaves the i.MX1 driver
and I have no possibility to fix it. I once pinged Paulius about this
issue but appearently nothing has happened.
I think we should start cleaning this up even if we risk breaking
something. Otherwise we are stuck with the legacy driver forever.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
