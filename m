Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab1LFHNX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 02:13:23 -0500
Received: from db3ehsobe005.messaging.microsoft.com ([213.199.154.143]:7671
	"EHLO DB3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941Ab1LFHNW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 02:13:22 -0500
X-SpamScore: -14
X-BigFish: VS-14(zz9371K542M1432N98dKc8kzz1202hzz8275bh8275dhz2dh2a8h668h839h8e2h8e3h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Dong Aisheng-B29396 <B29396@freescale.com>
To: Guo Shawn-R65073 <r65073@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>
Subject: RE: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
Thread-Topic: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
Thread-Index: AQHMsnlAdrguC9Qi5Ei/Yb1CNiu/O5XOyroA//+b9/A=
Date: Tue, 6 Dec 2011 07:13:16 +0000
Message-ID: <65EE16ACC360FA4D99C96DC085B3F7723459CE@039-SN1MPN1-002.039d.mgd.msft.net>
References: <1322999384-7886-1-git-send-email-b29396@freescale.com>
 <20111206070615.GJ2980@S2100-06.ap.freescale.net>
In-Reply-To: <20111206070615.GJ2980@S2100-06.ap.freescale.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.89]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Guo Shawn-R65073
> Sent: Tuesday, December 06, 2011 3:06 PM
> To: Dong Aisheng-B29396
> Cc: linux-kernel@vger.kernel.org; linux-arm-kernel@lists.infradead.org;
> linus.walleij@stericsson.com; s.hauer@pengutronix.de;
> kernel@pengutronix.de
> Subject: Re: [RFC PATCH 1/3] pinctrl: imx: add pinmux imx core driver
> 
> On Sun, Dec 04, 2011 at 07:49:42PM +0800, Dong Aisheng wrote:
> > ---
> > This patch series shows the basic idea of driver design. There're
> > still some TODOes like adding more pinmux functions and gpio support.
> > The patch is here for request for comments on the driver design and
> > other might exist issues.
> >
> > Signed-off-by: Dong Aisheng <dong.aisheng@linaro.org>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> > Cc: Shawn Guo <shanw.guo@freescale.com>
> > ---
> >  drivers/pinctrl/Kconfig           |    6 +
> >  drivers/pinctrl/Makefile          |    2 +
> >  drivers/pinctrl/pinmux-imx-core.c |  284
> +++++++++++++++++++++++++++++++++++++
> >  drivers/pinctrl/pinmux-imx-core.h |   83 +++++++++++
> >  4 files changed, 375 insertions(+), 0 deletions(-)
> >
> > diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig index
> > ef56644..214d072 100644
> > --- a/drivers/pinctrl/Kconfig
> > +++ b/drivers/pinctrl/Kconfig
> > @@ -40,4 +40,10 @@ config PINMUX_U300
> >  	help
> >  	  Say Y here to enable the U300 pinmux driver
> >
> > +config PINMUX_IMX
> > +	bool "IMX pinmux driver"
> > +	depends on ARCH_MXC
> > +	select PINMUX
> > +	help
> > +	  Say Y here to enable the IMX pinmux driver
> >  endif
> > diff --git a/drivers/pinctrl/Makefile b/drivers/pinctrl/Makefile index
> > bdc548a..764657b 100644
> > --- a/drivers/pinctrl/Makefile
> > +++ b/drivers/pinctrl/Makefile
> > @@ -4,5 +4,7 @@ ccflags-$(CONFIG_DEBUG_PINMUX)	+= -DDEBUG
> >
> >  obj-$(CONFIG_PINCTRL)		+= core.o
> >  obj-$(CONFIG_PINMUX)		+= pinmux.o
> > +obj-$(CONFIG_PINMUX_IMX)	+= pinmux-imx-core.o \
> > +				   pinmux-imx53.o pinmux-imx6q.o
> 
> You do not have pinmux-imx53.c and pinmux-imx6q.c in this patch yet.
> 
> >  obj-$(CONFIG_PINMUX_SIRF)	+= pinmux-sirf.o
> >  obj-$(CONFIG_PINMUX_U300)	+= pinmux-u300.o
> > diff --git a/drivers/pinctrl/pinmux-imx-core.c
> > b/drivers/pinctrl/pinmux-imx-core.c
> > new file mode 100644
> > index 0000000..1e60932
> > --- /dev/null
> > +++ b/drivers/pinctrl/pinmux-imx-core.c
> > @@ -0,0 +1,284 @@
> > +/*
> > + * Core driver for the imx pin controller
> > + *
> > + * Copyright (C) 2011 Freescale Semiconductor, Inc.
> > + * Copyright (C) 2011 Linaro Ltd.
> > + *
> > + * Author: Dong Aisheng <dong.aisheng@linaro.org>
> > + *
> > + * This program is free software; you can redistribute it and/or
> > +modify
> > + * it under the terms of the GNU General Public License as published
> > +by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + */
> > +
> > +#include <linux/init.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/io.h>
> > +#include <linux/err.h>
> > +#include <linux/pinctrl/pinctrl.h>
> > +#include <linux/pinctrl/pinmux.h>
> > +
> > +#include "pinmux-imx-core.h"
> > +
> > +#define DRIVER_NAME "pinmux-imx"
> > +
> > +/**
> > + * @dev: a pointer back to containing device
> > + * @virtbase: the offset to the controller in virtual memory  */
> > +struct imx_pmx {
> > +	struct device *dev;
> > +	struct pinctrl_dev *pctl;
> > +	void __iomem *virtbase;
> > +	struct imx_pinctrl_info *info;
> > +};
> > +
> > +#define IMX_PINCTRL_REG_SIZE 4
> > +#define IMX_PINCTRL_MAX_FUNC 7
> > +
> > +extern struct imx_pinctrl_info mx53_pinctrl_info; extern struct
> > +imx_pinctrl_info mx6q_pinctrl_info;
> > +
> 
> You do not have mx53_pinctrl_info and mx6q_pinctrl_info in this patch yet.
> 
Yes, it's defined in another file in this patch series.
I just separate them for clear.
Maybe I should put them together in one patch or change sequence right?
BTW, if taking it from platform_data, I may not have this issue.

Regards
Dong Aisheng

