Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab2KTLYm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 06:24:42 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:36457 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab2KTLYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 06:24:41 -0500
Date: Tue, 20 Nov 2012 03:21:29 -0800
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>,
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
Subject: Re: [PATCH] extcon : callback function to read cable property
Message-ID: <20121120112129.GA5759@lizard>
References: <1352521082.1526.230.camel@anish-Inspiron-N5050>
 <20ADAB092842284E95860F279283C56442034B@BGSMSX101.gar.corp.intel.com>
 <CAK7N6vpEbVrM-w+zLytf8BWmwt5j68py4Q64HEy9maCW2OMDjg@mail.gmail.com>
 <20ADAB092842284E95860F279283C56444A584@BGSMSX101.gar.corp.intel.com>
 <50AAEB15.6000703@samsung.com>
 <20ADAB092842284E95860F279283C56444A6A1@BGSMSX101.gar.corp.intel.com>
 <50AB1ECA.5020005@samsung.com>
 <20ADAB092842284E95860F279283C56444C915@BGSMSX101.gar.corp.intel.com>
 <20121120092419.GA27280@lizard>
 <20ADAB092842284E95860F279283C56444CB72@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20ADAB092842284E95860F279283C56444CB72@BGSMSX101.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 11:08:54AM +0000, Tc, Jenny wrote:
[...]
> > | We may have:
> > |        enum extcon_cable_type {
> > |                EXTCON_CT_REGULATOR,
> > |                EXTCON_CT_PSY,
> > |                EXTCON_CT_CHARGER_CB,
> > |                ...
> > |        };
> > | and have the following included at struct extcon_cable:
> > |        union {
> > |                struct regulator *reg;
> > |                struct power_supply *psy;
> > |                struct charger_cable *charger_cb;
> > |                ...
> > |        } cable data;
> > |        enum extcon_cable_type cable_type;
[...]
> struct charger_cable_props {
> 	unsigned long state;
> 	int mA;
> }
> struct extcon_cable {
> 	.....
> 	union {
> 		struct charger_cable_props chrgr_props;
> 		.....
> 	} data;
> 	enum extcon_cable_name cable_name;
> };
> 
> This way we are not restricting the cable properties just to the charger cable.
> We can add other charger cable properties as we identify the properties for them.

Well, to me, it seems that if we have cable *type*, then having properties
of the cable is the next logical step.

So, personally I see nothing wrong with it.

But you can look at this at the different angle: the type is just another
property of the cable. Would it be better to have power_supply-like API
for extcon? :)

if (extcon->get_prop(extcon, EXC_PROP_TYPE) == EXC_TYPE_CHARGER)) {
	int max_uA = extcon->get_prop(extcon, EXC_PROP_MAX_CURRENT;
	...
}

> We can use the cable_name variable to identify  which cable property to use.

This I didn't get, tho. Why would 'cable_name' tell us which property to
use?. The type of the cable defines a set of its properties -- this I can
understand.

Thanks,
Anton.
