Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751197Ab3AGFXn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 00:23:43 -0500
Received: from mga01.intel.com ([192.55.52.88]:48785 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab3AGFXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 00:23:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,421,1355126400"; 
   d="scan'208";a="270697160"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        Anton Vorontsov <anton@enomsg.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Myungjoo Ham <myungjoo.ham@samsung.com>
Subject: RE: [PATCH 1/2] power_supply: Add charge control struct in power
 supply class
Thread-Topic: [PATCH 1/2] power_supply: Add charge control struct in power
 supply class
Thread-Index: AQHN67kZJS22ggXo6kCbpjqu49NvMZg89pEAgABfU7A=
Date: Mon, 7 Jan 2013 05:23:36 +0000
Message-ID: <20ADAB092842284E95860F279283C564E70A93@BGSMSX101.gar.corp.intel.com>
References: <1354002423-24587-1-git-send-email-ramakrishna.pallala@intel.com>
 <1354002423-24587-2-git-send-email-ramakrishna.pallala@intel.com>
 <20130106025024.GC6919@lizard.sbx05280.losalca.wayport.net>
 <D854C92F57B1B347B57E531E78D05EAD245CAF83@BGSMSX102.gar.corp.intel.com>
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD245CAF83@BGSMSX102.gar.corp.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r075Nh2l025485

> 
> > > +struct power_supply_charger_control {
> > > +	const char *name;
> > > +	/* get charging status */
> > > +	int (*is_charging_enabled)(void);
> > > +	int (*is_charger_enabled)(void);
> > > +
> > > +	/* set charging parameters */
> > > +	int (*set_in_current_limit)(int uA);
> > > +	int (*set_charge_current)(int uA);
> > > +	int (*set_charge_voltage)(int uV);
> > > +
> > > +	/* control battery charging */
> > > +	int (*enable_charging)(void);
> > > +	int (*disable_charging)(void);
> > > +
> > > +	/* control VSYS or system supply */
> > > +	int (*turnon_charger)(void);
> > > +	int (*turnoff_charger)(void);
> > > +};
> > > +
> >
> > I'm all for this patch, but why do you need to place it into
> > power_supply.h and power_supply_core.c? :) I see nothing generic here,
> > it's pure charger-manager stuff. So, place everything into charger-
> manager.{c,h}.
> 
> Hi Anton,
> 
> The main reason for keeping this stuff in power_supply.h and
> power_supply_core.c is to make these interfaces uniform Across multiple
> charger frameworks and to avoid each charger framework define it's own
> interfaces. If there is need for new callback They can add to the existing struct
> defined above and it will available to all the frameworks. Also the work
> required to support a new Framework will be reduced if the driver already
> support any one of the existing frameworks.
> 

Rama,

The similar functionalities are exposed by patch https://lkml.org/lkml/2012/10/18/219.
As per Anton's review comments on this patch, I'll be moving the macros to power_supply.h.
Wouldn't that be enough ?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
