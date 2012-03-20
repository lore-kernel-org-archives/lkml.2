Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825Ab2CTNIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:08:18 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37147 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab2CTNIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:08:16 -0400
Date: Tue, 20 Mar 2012 14:08:05 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
        fabio.estevam@freescale.com
Subject: Re: [PATCH] ARM: i.MX35: Add set_rate and round_rate calls to csi_clk
Message-ID: <20120320130805.GK3852@pengutronix.de>
References: <1332239392-12639-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332239392-12639-1-git-send-email-alexg@meprolight.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 14:04:14 up 128 days, 20:51, 97 users,  load average: 0.08, 0.04,
 0.24
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 12:29:52PM +0200, Alex Gershgorin wrote:
> This patch add set_rate and round_rate calls to csi_clk. This is needed
> to give mx3-camera control over master clock rate to camera.

The file you are patching is scheduled for removal in favour for the
common clock framework, so you are flogging a dead horse here. I suggest
that you wait some time until I finished the i.MX35 patches for this.

> +static int csi_set_rate(struct clk *clk, unsigned long rate)
> +{
> +	unsigned long div;
> +	unsigned long parent_rate;
> +	unsigned long pdr2 = __raw_readl(CCM_BASE + CCM_PDR2);
> +
> +	if (pdr2 & (1 << 7))
> +		parent_rate = get_rate_arm();
> +	else
> +		parent_rate = get_rate_ppll();
> +
> +	div = parent_rate / rate;
> +
> +	/* Set clock divider */
> +	pdr2 |= ((div - 1) & 0x3f) << 16;

btw you forget to clear the divider bits in pdr2 before
setting the new values.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
