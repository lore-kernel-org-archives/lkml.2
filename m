Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760180Ab0HLPAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:00:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52936 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386Ab0HLPAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:00:32 -0400
Date: Thu, 12 Aug 2010 17:00:30 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: dmaengine questions
Message-ID: <20100812150030.GB27749@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:24:53 up 40 days, 35 min, 57 users,  load average: 0.84, 2.28,
	2.30
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am currently looking into implementing the Freescale i.MX SDMA engine
into the dmaengine API. The SDMA engine can handle sg transfers from/to
devices. During implementation some questions came up.

On the i.MX we already have a DMA engine which can do slave dma
transfers, the IPU (drivers/dma/ipu/), which is exclusively used for
image operations. My problem is that I found no way for the clients
to select which DMA engine to use as both have the same capabilities
(DMA_SLAVE).

For the SDMA engine the clients have to pass some platform specific data
to the SDMA engine (dma request line, word width and the like). The
current mechanism is to pass this data through the dma_chan->private
field, which seems more like tunneling instead of passing the data as we
lose type safety. Are there any ideas to improve this?

Sascha



-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
