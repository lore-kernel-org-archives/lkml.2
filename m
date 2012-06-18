Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab2FRFLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 01:11:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:60146 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736Ab2FRFLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 01:11:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="181369070"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "R, Durgadoss" <durgadoss.r@intel.com>
Subject: RE: [PATCHv2] power_supply: Register battery as a thermal zone
Thread-Topic: [PATCHv2] power_supply: Register battery as a thermal zone
Thread-Index: AQHNTQs71I137SCSiUGywBoF1Z1h2Jb/hstg
Date: Mon, 18 Jun 2012 05:10:57 +0000
Message-ID: <20ADAB092842284E95860F279283C564282328@BGSMSX101.gar.corp.intel.com>
References: <1336576007-8772-1-git-send-email-jenny.tc@intel.com>
 <20120618042927.GA25372@lizard>
In-Reply-To: <20120618042927.GA25372@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5I5CBhe018714

Hi Anton,

> -----Original Message-----
> From: Anton Vorontsov [mailto:cbouatmailru@gmail.com]
> Sent: Monday, June 18, 2012 9:59 AM
> To: Tc, Jenny
> Cc: linux-kernel@vger.kernel.org; R, Durgadoss
> Subject: Re: [PATCHv2] power_supply: Register battery as a thermal zone
> 
> On Wed, May 09, 2012 at 08:36:47PM +0530, Jenny TC wrote:
> > Battery and charger contribute to Thermals in most of the embedded
> > devices. So, it makes sense to identify them as Thermal zones in a
> > particular platform.
> >
> > This patch registers a thermal zone if the power supply is reporting a
> > temperature property. The thermal zone will be used by platform's
> > thermal management solution.
> >
> > Signed-off-by: Jenny TC <jenny.tc@intel.com>
> > ---
> 
> Once again, thanks for the patch! It's a nice feature.
> 
> [...]
> > @@ -206,6 +258,9 @@ int power_supply_register(struct device *parent,
> struct power_supply *psy)
> >  	goto success;
> >
> >  create_triggers_failed:
> > +	if (psy->tzd)
> > +		thermal_zone_device_unregister(psy->tzd);
> 
> This causes errors:
> 
>   CC      drivers/power/pda_power.o
> drivers/power/power_supply_core.c: In function â€˜power_supply_registerâ€™:
> drivers/power/power_supply_core.c:261:9: error: â€˜struct power_supplyâ€™ has
> no member named â€˜tzdâ€™
> drivers/power/power_supply_core.c:262:37: error: â€˜struct power_supplyâ€™
> has no member named â€˜tzdâ€™
> make[2]: *** [drivers/power/power_supply_core.o] Error 1
> 
> I think we should just introduce unregister_thermal(). So, that's what I've
> applied:

Sorry I missed it. Thanks for adding it.  Hope you will merge it

-jtc
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
