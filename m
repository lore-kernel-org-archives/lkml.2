Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485Ab1KGKRx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 05:17:53 -0500
Received: from portal.weinmann.de ([62.8.140.122]:24846 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab1KGKRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 05:17:52 -0500
X-Greylist: delayed 967 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Nov 2011 05:17:51 EST
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'balbi@ti.com'" <balbi@ti.com>
CC: "'linux-i2c@vger.kernel.org'" <'linux-i2c@vger.kernel.org'>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<'linux-arm-kernel@lists.infradead.org'>,
        "'nicolas.ferre@atmel.com'" <nicolas.ferre@atmel.com>,
        "'plagnioj@jcrosoft.com'" <plagnioj@jcrosoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Mon, 7 Nov 2011 11:01:27 +0100
Subject: RE: [PATCH V2] drivers/i2c/busses/i2c-at91.c: fix brokeness
Thread-Topic: [PATCH V2] drivers/i2c/busses/i2c-at91.c: fix brokeness
Thread-Index: AcydMjskWZQdAQr8SuyWt9dcP+io9QAACJng
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D087B38B21C@wm021.weinmann.com>
References: <alpine.DEB.2.00.1111071019560.21431@gatekeeper.vosshq.de>
 <20111107094701.GF4265@legolas.emea.dhcp.ti.com>
In-Reply-To: <20111107094701.GF4265@legolas.emea.dhcp.ti.com>
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

Hi,

> IMHO, you should split this patch into three or more smaller patches.
> You're doing lots of different things in one commit and it'll be a pain to
> bisect should this cause any issues to anyone.

I didn't split the patch because it is virtually a complete rewrite.
Due to the severe limitations of the old driver, I think it should
replace the old driver.

> > +/* -*- linux-c -*-
> 
> you shouldn't add this editor hooks to linux source files.

Ok.


> > -static int at91_i2c_resume(struct platform_device *pdev)
> > +static int at91_i2c_resume(struct device *dev)
> >  {
> > -	return clk_enable(twi_clk);
> > +	struct platform_device *pdev = to_platform_device(dev);
> > +	struct at91_i2c_dev *i2c_dev = platform_get_drvdata(pdev);
> 
> dev_get_drvdata(dev) will do the same of two above lines. You don't need to
> fetch the platform_device...

Ok.

> > -MODULE_AUTHOR("Rick Bronson");
> > +MODULE_AUTHOR("Nikolaus Voss");
> 
> wow... are you sure ? Rick will always be the original author, no ?

Yes, of course, but I don't want to declare him responsible for my
own mistakes. The new driver has almost nothing to do with the old.

Thanks for your *very* fast reply and review.

Niko

