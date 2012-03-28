Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758526Ab2C1Qbf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:31:35 -0400
Received: from mail.meprolight.com ([194.90.149.17]:42403 "EHLO meprolight.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758264Ab2C1Qbe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:31:34 -0400
From: Alex Gershgorin <alexg@meprolight.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "fabio.estevam@freescale.com" <fabio.estevam@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Wed, 28 Mar 2012 18:31:04 +0200
Subject: RE: [PATCH] mfd: mc13xxx: add I2C support fix building for v3.4
Thread-Topic: [PATCH] mfd: mc13xxx: add I2C support fix building for v3.4
Thread-Index: Ac0M8KVwyAkq5DRBRAy1MH1XgF9DXgAArx8E
Message-ID: <4875438356E7CA4A8F2145FCD3E61C0B2CC34CAD25@MEP-EXCH.meprolight.com>
References: <1332943273-22447-1-git-send-email-alexg@meprolight.com>,<20120328144017.GV3232@opensource.wolfsonmicro.com>
In-Reply-To: <20120328144017.GV3232@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, Mar 28, 2012 at 04:01:13PM +0200, Alex Gershgorin wrote:

> index c3fbc5e..2119732 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -577,6 +577,8 @@ config MFD_MC13XXX
>       depends on SPI_MASTER || I2C
>       select MFD_CORE
>       select MFD_MC13783
> +     select REGMAP_I2C if I2C
> +     select REGMAP_SPI if SPI_MASTER
>       help
>         Enable support for the Freescale MC13783 and MC13892 PMICs.
>         This driver provides common support for accessing the device,

> > I'd really expect this to be squashed into the patches adding the regmap
> > usage for I2C and SPI, how can those patches work without this?

You ask me about another solution?
 
> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index 31dbf91..5a60273 100644
> --- a/drivers/mfd/mc13xxx-core.c
> +++ b/drivers/mfd/mc13xxx-core.c
> @@ -616,7 +616,7 @@ static int mc13xxx_add_subdevice(struct mc13xxx *mc13xxx, const char *format)
>  #ifdef CONFIG_OF
>  static int mc13xxx_probe_flags_dt(struct mc13xxx *mc13xxx)
>  {
> -     struct device_node *np = mc13xxx->dev.of_node;
> +     struct device_node *np = mc13xxx->dev->of_node;

> >This looks like it should be submitted properly as a bug fix for
> >inclusion on 3.4 or squashed into whatever change introduces the issue
> >if it's not present in 3.4.

Ok 

  


