Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab2DKQwm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:52:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50524 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab2DKQwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:52:41 -0400
Date: Wed, 11 Apr 2012 18:52:23 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Chris Ball <cjb@laptop.org>
Cc: Dmitry Artamonow <mad_soft@inbox.ru>, linux-mmc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH] mmc: remove linux/blkdev.h include from host drivers
Message-ID: <20120411165223.GP3852@pengutronix.de>
References: <1334084783-3572-1-git-send-email-mad_soft@inbox.ru>
 <87ty0qs2fz.fsf@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ty0qs2fz.fsf@laptop.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 18:50:18 up 151 days, 37 min, 55 users,  load average: 0.04, 0.08,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 11:39:12AM -0400, Chris Ball wrote:
> Hi Sascha, Wolfram,
> 
> On Tue, Apr 10 2012, Dmitry Artamonow wrote:
> > I've compile tested everything with and without CONFIG_BLOCK enabled,
> > except for imxmmc.c - this driver seems to be long time broken
> > (at least since the removal of mach-imx in 2.6.31 - see commit
> > 1341d34ffc296f98dc84876f35f3151525dc02a2 ) 
> 
> I can confirm that it no longer builds:
> 
> /home/cjb/git/mmc/drivers/mmc/host/imxmmc.c:32:26: fatal error: mach/imx-dma.h: No such file or directory
> 
> Should imxmmc simply be removed from drivers/mmc/host?  Do any of the
> more current i.MX MMC drivers support the same hardware?

It has long been on my todo list to remove this driver. The more recent
i.MX use the mxcmmc driver which is basically the same hardware but
without a bunch of bugs which made the older imxmmc driver unusable on
newer hardware. I can send a patch if you like.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
