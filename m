Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405Ab2FGTYj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 15:24:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48654 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761381Ab2FGTYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 15:24:38 -0400
Date: Thu, 7 Jun 2012 21:24:27 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Christoph Fritz <chf.fritz@googlemail.com>
Cc: Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Christian Hemp <c.hemp@phytec.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "Hans J. Koch" <hjk@hansjkoch.de>
Subject: Re: [PATCH] ARM: mx35: add WEIM register addresses
Message-ID: <20120607192427.GO30400@pengutronix.de>
References: <20120509131638.GA2057@lovely.krouter>
 <20120607180738.GM30400@pengutronix.de>
 <1339093049.4704.192.camel@mars>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339093049.4704.192.camel@mars>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 21:16:43 up 208 days,  3:03, 17 users,  load average: 1.65, 1.41,
 1.41
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 08:17:29PM +0200, Christoph Fritz wrote:
> On Thu, 2012-06-07 at 20:07 +0200, Sascha Hauer wrote:
> 
> > The same could be used on i.MX25 aswell. I think we should clean this
> > up before adding more SoCs.
> 
> :) full ack. What would you suggest? A macro?

Something like the following should do. We still could do better, but at
least we have all pieces together.

imx-weim.h:

#define IMX_WEIM_CSU_BITS	...

static inline void imx_weim_cs(void __iomem *base, int cs, u32 csu, u32 csl, u32 csa)
{
	do_it
}

static inline void mx27_weim_cs(int cs, u32 csu, u32 csl, u32 csa)
{
	imx_weim_cs(MX27_IO_ADDRESS(MX27_WEIM_BASE), cs, csu, csl, csa));
}


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
