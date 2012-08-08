Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759166Ab2HHT1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 15:27:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56157 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759149Ab2HHT1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 15:27:16 -0400
Date: Wed, 8 Aug 2012 21:27:07 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Steev Klimaszewski <steev@genesi-usa.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shawn Guo <shawn.guo@linaro.org>, Dave Martin <dave.martin@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/2] ARM: build ssi-fiq.S in ARM mode to prevent
 CONFIG_THUMB2_KERNEL build breakage
Message-ID: <20120808192707.GL1451@pengutronix.de>
References: <1344379514-30076-1-git-send-email-matt@genesi-usa.com>
 <1344379514-30076-2-git-send-email-matt@genesi-usa.com>
 <20120808065502.GI1451@pengutronix.de>
 <CAKGA1bmUuSZuWDM4QPTxmNR0+=uQ1RbFhw4u-sb9KaSPYwQiVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1bmUuSZuWDM4QPTxmNR0+=uQ1RbFhw4u-sb9KaSPYwQiVw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:18:48 up 46 days, 10:30, 43 users,  load average: 0.19, 0.15,
 0.14
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 12:32:39PM -0500, Matt Sealey wrote:
> On Wed, Aug 8, 2012 at 1:55 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> >>               .text
> >> +             .arm
> >>               .global imx_ssi_fiq_start
> >>               .global imx_ssi_fiq_end
> >>               .global imx_ssi_fiq_base
> >
> > I think it would be better to add a depends on !THUMB2_KERNEL to
> > SND_IMX_SOC_PCM_FIQ. The above may result in broken code in a thumb2
> > kernel, so I'd rather keep the compile error instead.
> 
> I'm curious as to how/why would it result in broken code? It's not
> possible that the processors relying on
> the imx_ssi_fiq_* stuff cannot run ARM code (unless Freescale shipped
> a weird version) so it should
> magically enter and exit. I wonder if it needs some thumb-interworking
> stuff wrapped around it though.
> You'd know better than me..

Currently I don't know if the code compiled in arm mode on an otherwise
thumb2 kernel does work and I do not have a thumb2 capacle hardware with
sound support to test this.

> 
> I'm a little worried that making it !CONFIG_THUMB2_KERNEL would
> basically make more than
> one of the boards in imx_v6_v7_defconfig suddenly lose audio support
> for no other reason..

Obviously no v6_v7 board does use this code as it is, because it does
not compile. So there's no risk of breaking something if we just disable
FIQ support in thumb2 mode.

Better disable an unused feature than add some untested code.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
