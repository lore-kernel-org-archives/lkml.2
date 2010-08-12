Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab0HLH4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 03:56:51 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56975 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758393Ab0HLH4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:56:48 -0400
Date: Thu, 12 Aug 2010 09:56:41 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Rabin Vincent <rabin@rab.in>, Dan Williams <dan.j.williams@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMAENGINE: add a slave buffer prep call
Message-ID: <20100812075641.GX27749@pengutronix.de>
References: <1281476766-7066-1-git-send-email-linus.walleij@stericsson.com> <20100811141219.GA5846@debian> <AANLkTikD2LwYwsk6Q-7U-P3o+ujhY_0TqgeqOo=hhjA=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikD2LwYwsk6Q-7U-P3o+ujhY_0TqgeqOo=hhjA=@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:55:23 up 39 days, 23:06, 37 users,  load average: 0.05, 0.32,
	0.32
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 09:02:04PM +0200, Linus Walleij wrote:
> 2010/8/11 Rabin Vincent <rabin@rab.in>:
> 
> > On Tue, Aug 10, 2010 at 11:46:06PM +0200, Linus Walleij wrote:
> >> This makes it possible for engines to implement slave transfers
> >> to be done to/from a simple kmalloc():ed memory buffer and not
> >> just from scatterlists.
> >
> > Why is this needed?  Drivers can just pass in a single-entry scatterlist
> > to the existing API to achieve the same functionality, and a couple of
> > them already do so.
> 
> Because of the overhead, simply. Especially if you want to trigger
> many jobs after each other. (This is necessary in device/slave-DMA
> since every transaction may fail...) It's not just constructing the
> sg-headers and freeing them again and again, it's also list traversals
> here and there since the driver must assume it can be a linked sglist and
> then two other list traversals for each
> dma_map_sg()/dma_unmap_sg() pair and ... yeah that's basically
> it.
> 
> And the number of extra code lines needed.
> 
> Then it's something conceptwise of creating a list that you know
> is just always one element that is just not elegant, like taking a queue
> numer and standing in queue when there is only one customer but
> hey, maybe it's just me.
> 
> One way of achieving it for all present drivers is to wrap the passed
> buffer in a single sglist and pass to the sglist function if the single
> buffer call is not supported in the driver. Maybe it'd be better if I
> coded up the patch like that so all driver can rely on this function
> to be present?

+1 for this approach as it seems easier to implement and has benefits
for all drivers.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
