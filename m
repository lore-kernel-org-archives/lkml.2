Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760834Ab2IGOUP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 10:20:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34295 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760691Ab2IGOUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 10:20:09 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Girdwood, Liam" <lrg@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Thread-Topic: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Thread-Index: AQHNSRRxSJBCL2eqoUaZnppvZVbxc5b39csQgAf6AbD//7R+gIAAaf7ngH9m9fA=
Date: Fri, 7 Sep 2012 14:19:59 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13EA29B8E@DBDE01.ent.ti.com>
References: <1339558031.26190.4.camel@phoenix>
 <331ABD5ECB02734CA317220B2BBEABC13E9D83E7@DBDE01.ent.ti.com>
 <CAF+7xWkh6CHvcur2iDs0Nwp_nO8i=6tYyTVauL6qtyrrMctjjA@mail.gmail.com>
 <331ABD5ECB02734CA317220B2BBEABC13E9D84D9@DBDE01.ent.ti.com>
 <20120618124513.GM3974@opensource.wolfsonmicro.com>
In-Reply-To: <20120618124513.GM3974@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 18:15:14, Mark Brown wrote:
> On Mon, Jun 18, 2012 at 12:39:38PM +0000, AnilKumar, Chimata wrote:
> 
> > +	if (config->regmap)
> > +		rdev->regmap = config->regmap;
> > +	else
> > +		rdev->regmap = dev_get_regmap(dev->parent, NULL);
> 
> No, this would be broken.  We're specifically using the device we got
> passed in.  In this case the fact that the regmap is on the MFD means
> that the driver does need to explicitly set the regmap.  Or we should
> have this be a multi-stage series of checks:
> 
> 	if (config->regmap)
> 		rdev->regmap = config->regmap;
> 	else if (dev_get_regmap(dev, NULL))
> 		rdev->regmap = dev_get_regmap(dev, NULL);
> 	else if (dev->parent)
> 		rdev->regmap = dev_get_regmap(dev->parent, NULL);
> 
> which should cover the MFD case if there's no regmap on the child
> without having to go through all the drivers doing it by hand.
> 

Mark,

Currently this is not properly taken care, is there are any specific
reasons for this?

Thanks
AnilKumar
