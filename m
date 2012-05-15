Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958Ab2EOHBI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 03:01:08 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36546 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900Ab2EOHBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 03:01:05 -0400
Date: Tue, 15 May 2012 09:00:58 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Saravana Kannan <skannan@codeaurora.org>
Cc: "Turquette, Mike" <mturquette@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        andrew@lunn.ch, rnayak@ti.com
Subject: Re: [PATCH] clk: Constify struct clk_init_data
Message-ID: <20120515070058.GK30400@pengutronix.de>
References: <1337004763-21250-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120514215304.GB3075@gmail.com>
 <4FB1AF14.3050507@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB1AF14.3050507@codeaurora.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:59:30 up 184 days, 14:46, 26 users,  load average: 0.00, 0.01,
 0.05
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 06:19:16PM -0700, Saravana Kannan wrote:
> On 05/14/2012 02:53 PM, Turquette, Mike wrote:
> >On Mon, May 14, 2012 at 7:12 AM, Mark Brown<broonie@opensource.wolfsonmicro.com>  wrote:
> >>Allow drivers to declare their clk_init_data const, the framework really
> >>shouldn't be modifying the data.
> >>
> >>Signed-off-by: Mark Brown<broonie@opensource.wolfsonmicro.com>
> >
> >+interested parties
> >
> >>
> >>diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
> >>index c1c23b9..fc43ea6 100644
> >>--- a/include/linux/clk-provider.h
> >>+++ b/include/linux/clk-provider.h
> >>@@ -143,7 +143,7 @@ struct clk_init_data {
> >>  */
> >>  struct clk_hw {
> >>        struct clk *clk;
> >>-       struct clk_init_data *init;
> >>+       const struct clk_init_data *init;
> 
> Oh, wait. This won't work for the case where the clock registration
> is completely dynamic. Say, created from device tree or thru some
> PCI/USB device probe, etc. That's why I didn't add it before.

Why not? In this case clk_init_data is also only used in clk_register.
Given that Mark has posted the patch I assume it actually works.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
