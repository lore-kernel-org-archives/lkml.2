Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245Ab2J3TAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 15:00:06 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:40578 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965633Ab2J3TAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 15:00:01 -0400
Subject: Re: [PATCH] i2c: pinctrl-ify i2c-omap.c
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <20121030185303.GD4804@arwen.pp.htv.fi>
Date: Tue, 30 Oct 2012 20:59:56 +0200
Cc: Tony Lindgren <tony@atomide.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        <linux-omap@vger.kernel.org>, <linux-i2c@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Koen Kooi <koen@dominion.thruhere.net>,
        Matt Porter <mporter@ti.com>, Russ Dill <Russ.Dill@ti.com>
Content-Transfer-Encoding: 7bit
Message-Id: <E7EF8F48-DF19-434C-95EE-8C472B31DCD4@antoniou-consulting.com>
References: <1351698930-3797-1-git-send-email-panto@antoniou-consulting.com> <20121030185303.GD4804@arwen.pp.htv.fi>
To: <balbi@ti.com>
X-Mailer: Apple Mail (2.1085)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Oct 30, 2012, at 8:53 PM, Felipe Balbi wrote:

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

Sure. No problem.

> 
>> +	dev_info(dev->dev, "bus %d rev%d.%d.%d at %d kHz\n", adap->nr,
>> +		 dev->dtrev, dev->rev >> 4, dev->rev & 0xf, dev->speed);
> 
> this dev_info() doesn't look like it's part of $subject. Care to, at
> least, add a reasoning for adding this to commit log ?
> 

I'll just remove it...

> -- 
> balbi

