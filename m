Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752999Ab1KIQBz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:01:55 -0500
Received: from portal.weinmann.de ([62.8.140.122]:55719 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1KIQBx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:01:53 -0500
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Ryan Mallon'" <rmallon@gmail.com>
CC: "'linux-i2c@vger.kernel.org'" <linux-i2c@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'ben-linux@fluff.org'" <ben-linux@fluff.org>,
        "'khali@linux-fr.org'" <khali@linux-fr.org>,
        "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>,
        "'balbi@ti.com'" <balbi@ti.com>
Date: Wed, 9 Nov 2011 17:01:07 +0100
Subject: RE: [PATCH V3 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Topic: [PATCH V3 2/4] drivers/i2c/busses/i2c-at91.c: add new driver
Thread-Index: AcyeaOZBDaYR16ZzTmChYOCuMaYX7gATqGyw
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B3C9440@wm021.weinmann.com>
References: <cover.1320753142.git.n.voss@weinmann.de>
 <7bdd6b456b0e055441cb25634c8cb6d483718f6c.1320753142.git.n.voss@weinmann.de>
 <4EB9B24A.5040809@gmail.com>
In-Reply-To: <4EB9B24A.5040809@gmail.com>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan,

> > +#include <mach/at91_twi.h>
> 
> 
> This include file looks like it only contains register definitions which
> are used in this file. Would be good to either move them directly into
> this driver or move the header file to this directory and make it a
> local include.

Ok.

> > +
> > +	dev->dev = get_device(&pdev->dev);
> 
> 
> Is this (and the put_device(&pdev->dev) in the exit code) necessary? I
> see that some other i2c drivers do this also, but I'm not familiar with
> using it in other device drivers. Isn't the reference count for
> pdev->dev already incremented by the fact we are probing the device?

It is incremented by the platform_device_register() which does a
device_add(). This seems to be enough, I removed the get-/put_device().


> 
> > +	dev->irq = irq->start;
> > +	platform_set_drvdata(pdev, dev);
> > +
> > +	dev->clk = clk_get(&pdev->dev, "twi_clk");
> 
> 
> This didn't get answered. Can't you just do:
> 
> 	dev->clk = clk_get(&pdev->dev, NULL);
> 
> and clkdev should figure out the correct clock based on the device pointer?

No, this doesn't work on at91 since the clocks have no dev_id property
but only con_id. I cannot see a reason for this, but that's the way it's
done. Multiple hardware interfaces are handled via a lookup table.


> > +	rc = i2c_del_adapter(&dev->adapter);
> 
> 
> Most of the other i2c drivers don't check the return code for
> i2c_del_adapter. If this fails then you will unload the module, but
> potentially leak resources that i2c_del_adapter failed to free up. Not
> sure what the correct answer is here.

I don't really check the value but use it has exit code for the remove()-
function to indicate something went wrong. Just ignoring it wouldn't heal
the resource leakage.

Thanks for reviewing,

Niko


