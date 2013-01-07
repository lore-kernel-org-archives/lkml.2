Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751338Ab3AGFJI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:09:08 -0500
Received: from mga01.intel.com ([192.55.52.88]:6383 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab3AGFJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:09:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,421,1355126400"; 
   d="scan'208";a="270694300"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <anton@enomsg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Tc, Jenny" <jenny.tc@intel.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: RE: [PATCH 1/2] power_supply: Add charge control struct in power
 supply class
Thread-Topic: [PATCH 1/2] power_supply: Add charge control struct in power
 supply class
Thread-Index: AQHN67kbn/4y50H2dkedkoB0BD97xJg9UDEw
Date: Mon, 7 Jan 2013 05:09:02 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD245CAF83@BGSMSX102.gar.corp.intel.com>
References: <1354002423-24587-1-git-send-email-ramakrishna.pallala@intel.com>
 <1354002423-24587-2-git-send-email-ramakrishna.pallala@intel.com>
 <20130106025024.GC6919@lizard.sbx05280.losalca.wayport.net>
In-Reply-To: <20130106025024.GC6919@lizard.sbx05280.losalca.wayport.net>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r0759CIt025383

> > +struct power_supply_charger_control {
> > +	const char *name;
> > +	/* get charging status */
> > +	int (*is_charging_enabled)(void);
> > +	int (*is_charger_enabled)(void);
> > +
> > +	/* set charging parameters */
> > +	int (*set_in_current_limit)(int uA);
> > +	int (*set_charge_current)(int uA);
> > +	int (*set_charge_voltage)(int uV);
> > +
> > +	/* control battery charging */
> > +	int (*enable_charging)(void);
> > +	int (*disable_charging)(void);
> > +
> > +	/* control VSYS or system supply */
> > +	int (*turnon_charger)(void);
> > +	int (*turnoff_charger)(void);
> > +};
> > +
> 
> I'm all for this patch, but why do you need to place it into power_supply.h and
> power_supply_core.c? :) I see nothing generic here, it's pure charger-manager
> stuff. So, place everything into charger-manager.{c,h}.

Hi Anton,

The main reason for keeping this stuff in power_supply.h and power_supply_core.c is to make these interfaces uniform
Across multiple charger frameworks and to avoid each charger framework define it's own interfaces. If there is need for new callback
They can add to the existing struct defined above and it will available to all the frameworks. Also the work required to support a new
Framework will be reduced if the driver already support any one of the existing frameworks.
 
Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
