Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932235Ab1JCQAD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:00:03 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10646 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097Ab1JCP75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 11:59:57 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 03 Oct 2011 08:59:47 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Igor Grinberg <grinberg@compulab.co.il>, Axel Lin <axel.lin@gmail.com>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Olof Johansson <olof@lixom.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>
Date: Mon, 3 Oct 2011 08:59:45 -0700
Subject: RE: [PATCH] mmc: sdhci-tegra: Add #ifdef CONFIG_OF guard for
 of_find_property
Thread-Topic: [PATCH] mmc: sdhci-tegra: Add #ifdef CONFIG_OF guard for
 of_find_property
Thread-Index: AcyBpwW38vQiIHNfSI2UTsFAOk68+AAPiOiQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173A2C6C97@HQMAIL01.nvidia.com>
References: <1317614852.30838.1.camel@phoenix>
 <4E897318.3090004@compulab.co.il>
In-Reply-To: <4E897318.3090004@compulab.co.il>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id p93G06AI016876

Igor Grinberg wrote at Monday, October 03, 2011 2:32 AM:
> Hi Axel,
> 
> On 10/03/11 06:07, Axel Lin wrote:
> > I got below build error with "make tegra_defconfig;make"
> > Add #ifdef CONFIG_OF guard for of_find_property to fix below build error:
> >
> >   CC      drivers/mmc/host/sdhci-tegra.o
> > drivers/mmc/host/sdhci-tegra.c: In function 'sdhci_tegra_dt_parse_pdata':
> > drivers/mmc/host/sdhci-tegra.c:157: error: implicit declaration of function 'of_find_property'
...
> > diff --git a/drivers/mmc/host/sdhci-tegra.c b/drivers/mmc/host/sdhci-tegra.c
...
> > @@ -154,8 +154,11 @@ static struct tegra_sdhci_platform_data * __devinit sdhci_tegra_dt_parse_pdata(
> >  	plat->cd_gpio = of_get_named_gpio(np, "cd-gpios", 0);
> >  	plat->wp_gpio = of_get_named_gpio(np, "wp-gpios", 0);
> >  	plat->power_gpio = of_get_named_gpio(np, "power-gpios", 0);
> > +
> > +#ifdef CONFIG_OF
> >  	if (of_find_property(np, "support-8bit", NULL))
> >  		plat->is_8bit = 1;
> > +#endif
> 
> Shouldn't we add a stub for the of_find_property() method to include/linux/of.h
> instead of adding more ifdefs?
> Or may be use of_get_property() method instead?

I submitted a patch to add a stub of_find_property a little while back.
Per https://lkml.org/lkml/2011/9/22/301, Grant applied it already. I'm
not sure why it hasn't shown up in linux-next, since Grant's repo wasn't
affected by the kernel.org downtime.

Sorry for the breakage.

-- 
nvpublic

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
