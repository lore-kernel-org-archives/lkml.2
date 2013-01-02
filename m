Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab3ABL3U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 06:29:20 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44189 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602Ab3ABL3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 06:29:17 -0500
Date: Wed, 2 Jan 2013 12:29:08 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, kernel@pengutronix.de,
        p.zabel@pengutronix.de, javier.martin@vista-silicon.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] coda: Fix build due to iram.h rename
Message-ID: <20130102112908.GI26326@pengutronix.de>
References: <1352898282-21576-1-git-send-email-fabio.estevam@freescale.com>
 <20121217093714.GI26326@pengutronix.de>
 <20121227201512.0a5c5828@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121227201512.0a5c5828@infradead.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 12:20:09 up 193 days,  2:31, 64 users,  load average: 1.47, 2.02,
 3.45
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Thu, Dec 27, 2012 at 08:15:12PM -0200, Mauro Carvalho Chehab wrote:
> Em Mon, 17 Dec 2012 10:37:14 +0100
> Sascha Hauer <s.hauer@pengutronix.de> escreveu:
> 
> > On Wed, Nov 14, 2012 at 11:04:42AM -0200, Fabio Estevam wrote:
> > > commit c045e3f13 (ARM: imx: include iram.h rather than mach/iram.h) changed the
> > > location of iram.h, which causes the following build error when building the coda
> > > driver:
> > > 
> > > drivers/media/platform/coda.c:27:23: error: mach/iram.h: No such file or directory
> > > drivers/media/platform/coda.c: In function 'coda_probe':
> > > drivers/media/platform/coda.c:2000: error: implicit declaration of function 'iram_alloc'
> > > drivers/media/platform/coda.c:2001: warning: assignment makes pointer from integer without a cast
> > > drivers/media/platform/coda.c: In function 'coda_remove':
> > > drivers/media/platform/coda.c:2024: error: implicit declaration of function 'iram_free
> > > 
> > > Since the content of iram.h is not imx specific, move it to include/linux/iram.h
> > > instead.
> > 
> > Generally we need a fix for this, but:
> > 
> > > diff --git a/arch/arm/mach-imx/iram.h b/include/linux/iram.h
> > > similarity index 100%
> > > rename from arch/arm/mach-imx/iram.h
> > > rename to include/linux/iram.h
> > 
> > We shouldn't introduce a file include/linux/iram.h which is purely i.MX
> > specific. The name is far too generic. I would rather suggest
> > include/linux/platform_data/imx-iram.h (Although it's not exactly
> > platform_data, so I'm open for better suggestions).
> > 
> > As a side note this i.MX specific iram stuff (hopefully) is obsolete
> > after the next merge window as Philip already has patches for a generic
> > iram allocator which didn't make it into this merge window.
> 
> Hi Sasha,
> 
> This compilation breakage seems to still be happening.
> 
> Just tested here with arm32 "allmodconfig", on a tree based on Linus one,
> with -next and -media patches applied on it:
> 
> drivers/media//platform/coda.c:27:23: fatal error: mach/iram.h: No such file or directory
> compilation terminated.
> 
> I don't mind how this would be named, but this should be fixed somehow ;)

I will prepare a patch for this next week when I'm back in the office.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
