Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933420Ab2CZSTT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 14:19:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38988 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933341Ab2CZSTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 14:19:14 -0400
Date: Mon, 26 Mar 2012 20:19:12 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, Estevam Fabio-R49496 <r49496@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/4] ARM i.MX 3ds debugboard: register a dummy regulator
 for the smsc911x device
Message-ID: <20120326181912.GV3852@pengutronix.de>
References: <1330774804-7310-1-git-send-email-s.hauer@pengutronix.de>
 <1330774804-7310-5-git-send-email-s.hauer@pengutronix.de>
 <CAOMZO5DL8YQT2qb=vxdQtdN+zfZLK9H9_1qu5sS+1YAvSo5SAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMZO5DL8YQT2qb=vxdQtdN+zfZLK9H9_1qu5sS+1YAvSo5SAA@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:16:59 up 135 days,  2:04, 32 users,  load average: 0.08, 0.07,
 0.06
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 03:09:34PM -0300, Fabio Estevam wrote:
> Hi Sascha,
> 
> On Sat, Mar 3, 2012 at 8:40 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> > Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> 
> ...
> >        /* Register Lan device on the debugboard */
> > +       regulator_register_fixed(0, dummy_supplies, ARRAY_SIZE(dummy_supplies));
> 
> I am using linux-next, which has this patch applied and I am getting:
> 
> smsc911x smsc911x.0: Failed to get supply 'vdd33a': -517
> smsc911x smsc911x.0: (unregistered net_device): couldn't get regulators -517
> platform smsc911x.0: Driver smsc911x requests probe deferral
> 
> Does this work for you on pcm037?

At least it did work when I sent the patches, but -EPROBE_DEFER did not
exist at that time. Do you have the fixed regulator enabled in your
config?

> 
> If I select CONFIG_REGULATOR_DUMMY then the the smsc driver is probed
> correctly, but if I understand correctly your suggestion was to not
> select CONFIG_REGULATOR_DUMMY, right?

Right.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
