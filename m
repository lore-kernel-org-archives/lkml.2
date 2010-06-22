Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374Ab0FVFX0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 01:23:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41767 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0FVFXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 01:23:25 -0400
Date: Tue, 22 Jun 2010 07:23:14 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <greg@kroah.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Dmitry Torokhov <dtor@mail.ru>,
       Anisse Astier <anisse@astier.eu>, Greg Kroah-Hartman <gregkh@suse.de>,
       Magnus Damm <damm@opensource.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Paul Mundt <lethal@linux-sh.org>, Eric Miao <eric.y.miao@gmail.com>,
       linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Driver core: reduce duplicated code
Message-ID: <20100622052314.GA17128@pengutronix.de>
References: <20100618073950.GA12822@pengutronix.de> <1277129511-2732-1-git-send-email-u.kleine-koenig@pengutronix.de> <20100621213846.GB25511@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100621213846.GB25511@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

> > I changed the semantic slightly to only call
> > platform_device_add_resources if data != NULL instead of size != 0.  The
> > idea is to support wrappers like:
> > 
> > 	#define add_blablub(id, pdata) \
> > 		platform_device_register_resndata(NULL, "blablub", id, \
> > 			NULL, 0, pdata, sizeof(struct blablub_platform_data))
> > 
> > that don't fail if pdata=NULL.  Ditto for res.
> 
> That's fine, but why would you want to have a #define for something like
> this?  Is it really needed?
Well, what is really needed?  I intend to use it on arm/imx.  I have
several different machines using similar SoCs and so I want to have a
function à la:

	struct platform_device *__init imx_add_imx_i2c(int id,
		resource_size_t iobase, resource_size_t iosize, int irq,
		const struct imxi2c_platform_data *pdata)

that builds a struct resource[] and then calls
platform_device_register_resndata().  And then I have a set of macros
like:

	#define imx21_add_i2c_imx(pdata)	\
		imx_add_imx_i2c(0, MX2x_I2C_BASE_ADDR, SZ_4K, MX2x_INT_I2C, pdata)
	#define imx25_add_imx_i2c0(pdata)	\
		imx_add_imx_i2c(0, MX25_I2C1_BASE_ADDR, SZ_16K, MX25_INT_I2C1, pdata)
	##define imx25_add_imx_i2c1(pdata)	\
		imx_add_imx_i2c(1, MX25_I2C2_BASE_ADDR, SZ_16K, MX25_INT_I2C2, pdata)

etc.  The final goal is to get rid of files like
arch/arm/mach-mx3/devices.c.

> Anyway, this version looks fine to me, I'll go apply it.
\o/

Best regards and thanks
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
