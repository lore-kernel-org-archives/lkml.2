Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472Ab2EEEmj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 00:42:39 -0400
Received: from mga14.intel.com ([143.182.124.37]:46611 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751171Ab2EEEmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 00:42:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139155089"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] max17042_battery: fix driver exit function
Thread-Topic: [PATCH] max17042_battery: fix driver exit function
Thread-Index: AQHNC3xnErhAmXsEakusyRSed0Yq3paTm1ZAgCbBNQCAAH6RgA==
Date: Sat, 5 May 2012 04:42:30 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD13FE77@BGSMSX102.gar.corp.intel.com>
References: <1332756506-6905-1-git-send-email-ramakrishna.pallala@intel.com>
 <D854C92F57B1B347B57E531E78D05EAD1071B1@BGSMSX102.gar.corp.intel.com>
 <20120505023620.GB812@lizard>
In-Reply-To: <20120505023620.GB812@lizard>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q454gjpZ007974

> On Tue, Apr 10, 2012 at 05:20:33AM +0000, Pallala, Ramakrishna wrote:
> [...]
> > >  	power_supply_unregister(&chip->battery);
> > > +	if (client->irq)
> > > +		free_irq(client->irq, chip);
> > > +	i2c_set_clientdata(client, NULL);
> > > +
> > >  	return 0;
> > >  }
> >
> > I have not received any comments for this patch.
> > Can I assume that this patch is in your merge queue?
> 
> Applied, but I removed i2c_set_clientdata(client, NULL) line in this patch. It is not be
> required nowadays, I2C core does it by itself.
> 
> Plus, I changed the order of the calls: we should free irq first, then unregister the
> power supply (btw, you might want to fix probe function as well: it should request irq
> only after power supply object is fully usable).

Thanks for the fix. I will look into the probe().

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
