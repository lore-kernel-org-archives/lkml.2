Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1LHJjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:39:44 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47296 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1LHJjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:39:40 -0500
Date: Thu, 8 Dec 2011 10:39:27 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Alberto Panizzo <maramaopercheseimorto@gmail.com>,
        Valentin Longchamp <valentin.longchamp@keymile.com>,
        Daniel Mack <daniel@caiaq.de>, Eric Benard <eric@eukrea.com>
Subject: Re: [PATCH] video IPUv1 fixes for different display connections
Message-ID: <20111208093927.GU27267@pengutronix.de>
References: <1322747932-24943-1-git-send-email-s.hauer@pengutronix.de>
 <1323329606.1641.25.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323329606.1641.25.camel@vkoul-udesk3>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:37:43 up 25 days, 17:24, 30 users,  load average: 0.03, 0.02,
 0.12
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 01:03:26PM +0530, Vinod Koul wrote:
> On Thu, 2011-12-01 at 14:58 +0100, Sascha Hauer wrote:
> > Hi,
> > 
> > The following series fixes the display connections to the IPU on
> > i.MX3 boards. The connection to the display is completely independend
> > of the internal pixel format in the framebuffer. The driver instead
> > changes the IPU <-> Display mapping dependent on the pixelformat
> > which is wrong.
> > The following patch makes 16bpp and 32bpp modes possible on both
> > RGB666 and RGB888 connected displays.
> > The burstsize setting for 32bpp was configured wrong, so 32bpp
> > modes have obviously never been tested.
> > 
> > Not for stable since all in kernel boards seem to work.
> Applied thanks.
> 
> Couldn't help but notice that :
> @@ -312,7 +312,7 @@ static void ipu_ch_param_set_size(union
> chan_param_mem *params,
>         case IPU_PIX_FMT_RGB565:
>                 params->ip.bpp  = 2;
>                 params->ip.pfs  = 4;
> 
> is not really good way. Someone else who is using this driver has no way
> of knowing what these magic numbers mean and how to use them
> Perhaps you can add meaning to these numbers and some note on why they
> should be set to these values.

Yes, you are right. Adding defines for these really makes this better
readable. BTW did you queue both patches or only the first one?

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
