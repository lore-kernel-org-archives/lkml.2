Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751744Ab2FRMjq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:39:46 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37919 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab2FRMjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:39:45 -0400
From: "AnilKumar, Chimata" <anilkumar@ti.com>
To: "axel.lin@gmail.com" <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>, "Nori, Sekhar" <nsekhar@ti.com>
Subject: RE: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Thread-Topic: [PATCH RFT] regulator: tps65217: Convert to
 regulator_[is_enabled|get_voltage_sel]_regmap
Thread-Index: AQHNSRRxSJBCL2eqoUaZnppvZVbxc5b39csQgAf6AbD//7R+gIAAZxhA
Date: Mon, 18 Jun 2012 12:39:38 +0000
Message-ID: <331ABD5ECB02734CA317220B2BBEABC13E9D84D9@DBDE01.ent.ti.com>
References: <1339558031.26190.4.camel@phoenix>
 <331ABD5ECB02734CA317220B2BBEABC13E9D83E7@DBDE01.ent.ti.com>
 <CAF+7xWkh6CHvcur2iDs0Nwp_nO8i=6tYyTVauL6qtyrrMctjjA@mail.gmail.com>
In-Reply-To: <CAF+7xWkh6CHvcur2iDs0Nwp_nO8i=6tYyTVauL6qtyrrMctjjA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.24]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

Small correction in core file modification.

On Mon, Jun 18, 2012 at 17:25:59, Axel Lin wrote:
> > Basically regmap pointer is missed out in runtime configutaion data. Without this we
> > can see NULL pointer exception because config.regmap is NULL.
> >
> > +       config.regmap = tps->regmap;
> >
> Since this patch is target for 3.6, this is not required.
> The regulator core will set it automatically.
> In drivers/regulator/core.c
>         if (config->regmap)
>                 rdev->regmap = config->regmap;
>         else
>                 rdev->regmap = dev_get_regmap(dev, NULL);
> 

+	if (config->regmap)
+		rdev->regmap = config->regmap;
+	else
+		rdev->regmap = dev_get_regmap(dev->parent, NULL);

Regards
AnilKumar