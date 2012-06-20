Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2FTOVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:21:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50579 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab2FTOVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:21:21 -0400
Date: Wed, 20 Jun 2012 16:20:44 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Rob Lee <rob.lee@linaro.org>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org, linux@arm.linux.org.uk,
        richard.zhao@freescale.com, dirk.behme@de.bosch.com,
        amit.kachhap@linaro.org, amit.kucheria@linaro.org, lenb@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH v5] ARM: imx: Add basic imx6q cpu thermal management
Message-ID: <20120620142044.GU28394@pengutronix.de>
References: <1340175964-4043-1-git-send-email-rob.lee@linaro.org>
 <1340175964-4043-2-git-send-email-rob.lee@linaro.org>
 <20120620101127.GS28394@pengutronix.de>
 <CAMXH7KE0Ei5cZLCOuO-hxBXW8WX48VhxNs2FxPV8biDNqzRY5A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMXH7KE0Ei5cZLCOuO-hxBXW8WX48VhxNs2FxPV8biDNqzRY5A@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:17:52 up 4 days,  1:46, 78 users,  load average: 0.31, 0.50, 2.38
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 09:12:51AM -0500, Rob Lee wrote:
> Sascha, thanks for the review.
> 
> >> +
> >> +static struct imx6q_thermal_zone     *th_zone;
> >> +static void __iomem                  *ocotp_base;
> >
> > This is a driver and drivers should generally be multi instance safe.
> >
> 
> I don't understand what this comment is referring to.  Could you elaborate?

Drivers can only be multi instance safe when all variables are inside a
instance specific struct and you pass a pointer to this struct around.
What if the i.MX7 has two different ocotp_base and you want to use this
driver on both ocotp?

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
