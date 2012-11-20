Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031Ab2KTLJD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:09:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:53469 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752974Ab2KTLI7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:08:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,285,1352102400"; 
   d="scan'208";a="222094137"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: Chanwoo Choi <cw00.choi@samsung.com>,
        anish singh <anish198519851985@gmail.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myunjoo.ham@gmail.com" <myunjoo.ham@gmail.com>,
        "lockwood@android.com" <lockwood@android.com>,
        "peterhuewe@gmx.de" <peterhuewe@gmx.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: RE: [PATCH] extcon : callback function to read cable property
Thread-Topic: [PATCH] extcon : callback function to read cable property
Thread-Index: AQHNpqL6iLZgSIxMH0GKmzwm7ve2K5eyQk0AgAEKtWCAAHd6AIAJUHGggCHhgICAAoy5YIAAyB8AgAgrt0CAAK9KgIAHC3AA//+ymoCAAF3mEP//374AgACE/eD//7E4gAANsMNg
Date: Tue, 20 Nov 2012 11:08:54 +0000
Message-ID: <20ADAB092842284E95860F279283C56444CB72@BGSMSX101.gar.corp.intel.com>
References: <509B0A0F.5000406@samsung.com>
 <20ADAB092842284E95860F279283C5644017F6@BGSMSX101.gar.corp.intel.com>
 <1352521082.1526.230.camel@anish-Inspiron-N5050>
 <20ADAB092842284E95860F279283C56442034B@BGSMSX101.gar.corp.intel.com>
 <CAK7N6vpEbVrM-w+zLytf8BWmwt5j68py4Q64HEy9maCW2OMDjg@mail.gmail.com>
 <20ADAB092842284E95860F279283C56444A584@BGSMSX101.gar.corp.intel.com>
 <50AAEB15.6000703@samsung.com>
 <20ADAB092842284E95860F279283C56444A6A1@BGSMSX101.gar.corp.intel.com>
 <50AB1ECA.5020005@samsung.com>
 <20ADAB092842284E95860F279283C56444C915@BGSMSX101.gar.corp.intel.com>
 <20121120092419.GA27280@lizard>
In-Reply-To: <20121120092419.GA27280@lizard>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAKB98d3021279

> > > For example,
> > > Firstly, the power_supply charging framework check state of charger
> > > cable whether attached or detached cable. Second, when power_supply
> > > charging framework receive the changed state of host system from
> > > 'Host system notifier', change charging current of charger cable.
> >
> > Not just SUSPEND, but we need to handle RESUME , UPDATE etc.  Also
> > this doesnâ€™t help us to define a standard interface for the charger
> > cable state/properties. IMHO it's not right to provide different
> > interfaces for different cables. This doesn't help us to standardize the
> charger cable interface.
> >
> > This thread has been running for a quite long time. Unfortunately we
> > couldn't make an agreement on the final solution. I would like to
> > recap the overall requirement and would like to propose alternate
> > solutions. The requirements is  to "Provide a generic interface for charger
> cable states and charger cable properties"
> >
> > Even though extcon subsystem handles charger cable states, it's not
> > enough to handle all kind of charger cable states. It can handle just 2 states
> CONNECT/DISCONNECT.
> > But there are scenarios where we need to handle more than 2 states
> > (eg. USB SUSPEND/RESUME/UPDATE etc). Also extcon doesn't have any
> > mechanism to read cable properties in a generic way.  Extcon
> > charger-cable consumer driver implementations (eg charger-manager),
> > defines charger cable properties statically (current in mA) inside the
> > consumer driver. This is not enough, since the charger cable
> > properties may change dynamically
> >
> > In existing form extcon cannot support different charger cable states
> > and their properties in a generic way. Also we couldn't find a final
> > solution on how to modify the extcon to support these requirements.
> > From the whole discussion what I conclude is
> >  * extcon is not designed to support cable properties
> 
> The idea of using union seemed good to me, what happened to it?
> 
> I mean, MyungJoo Ham wrote:
> 
> | We may have:
> |        enum extcon_cable_type {
> |                EXTCON_CT_REGULATOR,
> |                EXTCON_CT_PSY,
> |                EXTCON_CT_CHARGER_CB,
> |                ...
> |        };
> | and have the following included at struct extcon_cable:
> |        union {
> |                struct regulator *reg;
> |                struct power_supply *psy;
> |                struct charger_cable *charger_cb;
> |                ...
> |        } cable data;
> |        enum extcon_cable_type cable_type;
> 
> This sounds good to me...

If I am right, this logic will help the consumer to know who will provide the properties and states.
But currently none of these subsystems are capable of giving the charger cable properties
because the information will be available only to the "provider driver". The provider driver
need not to be in any of these subsystem. For example if the OTG driver need to notify the
cable state (CONNECT/DISCONNECT/SUSPEND/RESUME..) and the properties (current in mA),
it doesn't make sense to register the OTG driver with any of these subsystems. 
But still it make sense to register with extcon since it can give the cable state information. 
I think this is applicable for all cable provider drivers.

If we are fine with union, then can we have the cable properties defined as unions?

struct charger_cable_props {
	unsigned long state;
	int mA;
}
struct extcon_cable {
	.....
	union {
		struct charger_cable_props chrgr_props;
		.....
	} data;
	enum extcon_cable_name cable_name;
};

This way we are not restricting the cable properties just to the charger cable.
We can add other charger cable properties as we identify the properties for them.
We can use the cable_name variable to identify  which cable property to use.

> 
> >  * extcon is not designed to support any cable state other than
> > CONNECT/DISCONNEC
> 
> Dunno for this one. Can we get these additional states via "properties" as
> described above?
> 
> Thanks,
> Anton.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
