Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989Ab2D0Hay (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 03:30:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46422 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab2D0Hax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 03:30:53 -0400
Date: Fri, 27 Apr 2012 09:30:48 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Dong Aisheng <b29396@freescale.com>, linux-kernel@vger.kernel.org,
        b20223@freescale.com, linus.walleij@stericsson.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        linux-arm-kernel@lists.infradead.org, kernel@pengutronix.de,
        cjb@laptop.org
Subject: Re: [PATCH v3 2/4] pinctrl: pinctrl-imx: add imx pinctrl core driver
Message-ID: <20120427073048.GR17184@pengutronix.de>
References: <1335451227-27709-1-git-send-email-b29396@freescale.com>
 <1335451227-27709-2-git-send-email-b29396@freescale.com>
 <20120426144446.GN9142@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120426144446.GN9142@game.jcrosoft.org>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:24:51 up 166 days, 15:11, 55 users,  load average: 3.09, 2.37,
 1.46
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 04:44:46PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> > +			fsl,pins = <1386 0x17059	/* MX6Q_PAD_SD4_CMD__USDHC4_CMD */
> > +				    1392 0x17059	/* MX6Q_PAD_SD4_CLK__USDHC4_CLK	*/
> > +				    1462 0x17059	/* MX6Q_PAD_SD4_DAT0__USDHC4_DAT0 */
> > +				    1470 0x17059	/* MX6Q_PAD_SD4_DAT1__USDHC4_DAT1 */
> > +				    1478 0x17059	/* MX6Q_PAD_SD4_DAT2__USDHC4_DAT2 */
> > +				    1486 0x17059	/* MX6Q_PAD_SD4_DAT3__USDHC4_DAT3 */
> > +				    1493 0x17059	/* MX6Q_PAD_SD4_DAT4__USDHC4_DAT4 */
> > +				    1501 0x17059	/* MX6Q_PAD_SD4_DAT5__USDHC4_DAT5 */
> > +				    1509 0x17059	/* MX6Q_PAD_SD4_DAT6__USDHC4_DAT6 */
> > +				    1517 0x17059>;	/* MX6Q_PAD_SD4_DAT7__USDHC4_DAT7 */
> honestly I don't like this it's obscure need to decode manually
> 
> I propose to use phandle
> 
> as example on uart you will want or not the rst/cts so you will have quite a
> lot of bindings
> 
> so you can describe the pin configuration (function) and refer it by phandle
> in the group

I don't exactly know where are you aiming at. I think that you want a
collection of pin groups somewhere and want to refer to it in the device
nodes. No, please don't. There's no way to come up with a common group
needed for example for the IPU (image processing unit). What pins you
want to use here depends on the number of data lines you have on your
panel and what type of panel you have. You can always use the remaining
pins for somethin else. SPI is another example. The SPI unit has some
dedicated chip select lines. The exact number of used chip selects is
board specific.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
