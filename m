Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226Ab0KBOMU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:12:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42258 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab0KBOMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:12:14 -0400
Date: Tue, 2 Nov 2010 15:12:08 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>, Felipe Balbi <balbi@ti.com>,
        Greg KH <greg@kroah.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Hao Wu <hao.wu@intel.com>,
        Alan Cox <alan@linux.intel.com>, Mike Rapoport <mike@compulab.co.il>
Subject: Re: [PATCH v3 2/2] drivers: cleanup Kconfig stuff
Message-ID: <20101102141208.GU31158@pengutronix.de>
References: <1288656853-4625-1-git-send-email-felipe.contreras@gmail.com> <1288656853-4625-3-git-send-email-felipe.contreras@gmail.com> <20101102131146.GA21476@opensource.wolfsonmicro.com> <AANLkTim6E+e=D88C8g+YDVwS1D5JPeXvVRw-JVoVxh2i@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim6E+e=D88C8g+YDVwS1D5JPeXvVRw-JVoVxh2i@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 04:02:18PM +0200, Felipe Contreras wrote:
> On Tue, Nov 2, 2010 at 3:11 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Tue, Nov 02, 2010 at 02:14:13AM +0200, Felipe Contreras wrote:
> >
> >>  config REGULATOR_TWL4030
> >>       bool "TI TWL4030/TWL5030/TWL6030/TPS695x0 PMIC"
> >>       depends on TWL4030_CORE
> >> +     default y
> >>       help
> >>         This driver supports the voltage regulators provided by
> >>         this family of companion chips.
> >
> > This default is not suitable for non-OMAP platforms, it should be
> > conditional on OMAP or something if we're going to do this (though
> > generally we handle this with defconfigs rather than in Kconfig).
> 
> This would only be enabled when TWL4030_CORE is enabled, so non-OMAP
> platforms would not get affected.
Well, all platforms that have TWL4030_CORE will get REGULATOR_TWL4030 by
default, too.  (TWL4030_CORE doesn't depend on something omapish.)

For me this looks OK.  It would be still better if it removed
CONFIG_REGULATOR_TWL4030=y from arch/arm/configs/omap2plus_defconfig.
 
Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
