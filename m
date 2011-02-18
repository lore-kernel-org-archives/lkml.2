Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab1BRJwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:52:33 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55386 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076Ab1BRJwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:52:24 -0500
Date: Fri, 18 Feb 2011 10:52:21 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jason Chen <weitway@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 3/7] Add i.MX5 framebuffer driver
Message-ID: <20110218095221.GK24426@pengutronix.de>
References: <1297865452-32181-1-git-send-email-s.hauer@pengutronix.de>
 <1297865452-32181-4-git-send-email-s.hauer@pengutronix.de>
 <AANLkTina46_CMvB_9cqc4=PvcPxaV_BQ_H_ghJZFFxg8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTina46_CMvB_9cqc4=PvcPxaV_BQ_H_ghJZFFxg8@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:50:33 up 1 day, 21:47, 52 users,  load average: 2.83, 3.14,
 1.94
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Fri, Feb 18, 2011 at 05:22:09PM +0800, Jason Chen wrote:
> hi, Sasha,
> 
> > +       if (var->vmode & FB_VMODE_ODD_FLD_FIRST) /* PAL */
> > +               sig_cfg.odd_field_first = 1;
> > +       if (var->sync & FB_SYNC_EXT)
> > +               sig_cfg.ext_clk = 1;
> > +       if (var->sync & FB_SYNC_HOR_HIGH_ACT)
> > +               sig_cfg.Hsync_pol = 1;
> Please remove FB_SYNC_EXT support.

No problem, can do. But why? Is it nonfunctional in the hardware
or is it that the current code just misses more pieces to support
this?

> 
> +static void imx_ipu_fb_disable_overlay(struct fb_info *ovl)
> +{
> +       struct imx_ipu_fb_info *mxc_ovl = ovl->par;
> +
> +       if (!mxc_ovl->enabled)
> +               return;
> +
> +       ipu_dp_disable_fg(mxc_ovl->dp);
> +       ipu_wait_for_interrupt(451, 100);
> +       ipu_idmac_disable_channel(mxc_ovl->ipu_ch);
> +       ipu_dmfc_disable_channel(mxc_ovl->dmfc);
> +       mxc_ovl->enabled = 0;
> +}
> Had better has a definition of ipu irq 451.

Ok.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
