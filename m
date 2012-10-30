Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934283Ab2J3TNl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:13:41 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40451 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933958Ab2J3TNi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:13:38 -0400
From: "Porter, Matt" <mporter@ti.com>
To: "Balbi, Felipe" <balbi@ti.com>
CC: Pantelis Antoniou <panto@antoniou-consulting.com>,
        Tony Lindgren <tony@atomide.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-i2c@vger.kernel.org>" <linux-i2c@vger.kernel.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Koen Kooi <koen@dominion.thruhere.net>,
        "Dill, Russ" <russ.dill@ti.com>
Subject: Re: [PATCH] i2c: pinctrl-ify i2c-omap.c
Thread-Topic: [PATCH] i2c: pinctrl-ify i2c-omap.c
Thread-Index: AQHNtsjMAFUfLDye6kumfOMOTESGgJfShdSAgAAFnoA=
Date: Tue, 30 Oct 2012 19:13:09 +0000
Message-ID: <AA125593-C53C-426E-9DCA-27318D5AB941@ti.com>
References: <1351698930-3797-1-git-send-email-panto@antoniou-consulting.com>
 <20121030185303.GD4804@arwen.pp.htv.fi>
In-Reply-To: <20121030185303.GD4804@arwen.pp.htv.fi>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <ACC15AC987BB4C44A3BEB568EF7D91C1@owa.mail.ti.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 30, 2012, at 2:53 PM, Felipe Balbi wrote:

> Hi,
> 
> On Wed, Oct 31, 2012 at 05:55:30PM +0200, Pantelis Antoniou wrote:
>> Enable pinctrl for i2c-omap.
>> 
>> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
>> ---
>> drivers/i2c/busses/i2c-omap.c | 10 ++++++++++
>> 1 file changed, 10 insertions(+)
>> 
>> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
>> index db31eae..4c38aa0 100644
>> --- a/drivers/i2c/busses/i2c-omap.c
>> +++ b/drivers/i2c/busses/i2c-omap.c
>> @@ -44,6 +44,8 @@
>> #include <linux/i2c-omap.h>
>> #include <linux/pm_runtime.h>
>> #include <linux/pm_qos.h>
>> +#include <linux/pinctrl/consumer.h>
>> +#include <linux/err.h>
>> 
>> /* I2C controller revisions */
>> #define OMAP_I2C_OMAP1_REV_2		0x20
>> @@ -1064,6 +1066,7 @@ omap_i2c_probe(struct platform_device *pdev)
>> 	const struct of_device_id *match;
>> 	int irq;
>> 	int r;
>> +	struct pinctrl *pinctrl;
>> 
>> 	/* NOTE: driver uses the static register mapping */
>> 	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> @@ -1202,6 +1205,13 @@ omap_i2c_probe(struct platform_device *pdev)
>> 
>> 	of_i2c_register_devices(adap);
>> 
>> +	pinctrl = devm_pinctrl_get_select_default(&pdev->dev);
>> +	if (IS_ERR(pinctrl))
>> +		dev_warn(dev->dev, "unable to select pin group\n");
> 
> if we continue anyway, should this be dev_warn() ? Would you consider
> dev_dbg() instead ?

This has been the convention already in other drivers upstream. Discussed
previously in http://www.spinics.net/lists/arm-kernel/msg192856.html and
http://lkml.org/lkml/2012/9/11/369

That resulted in having dev_warn with a message of "pins are not configured
from the driver" in both leds-gpio and spi-omap2-mcspi. It seems there should
be a good reason to change reporting for the same case here.

-Matt
