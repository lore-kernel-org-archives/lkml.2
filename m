Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758383Ab2JKKhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 06:37:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:46127 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758310Ab2JKKhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 06:37:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,571,1344236400"; 
   d="scan'208";a="233440223"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        ??? <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "myungjoo.ham@gmail.com" <myungjoo.ham@gmail.com>
Subject: RE: [PATCH] extcon : register for cable interest by cable name
Thread-Topic: [PATCH] extcon : register for cable interest by cable name
Thread-Index: AQHNprPN0OTqRJdBZE+YLN391rLe55ez5XeQ
Date: Thu, 11 Oct 2012 10:37:25 +0000
Message-ID: <20ADAB092842284E95860F279283C56439C8F5@BGSMSX101.gar.corp.intel.com>
References: <7103095.833841349851943826.JavaMail.weblogic@epml02>
In-Reply-To: <7103095.833841349851943826.JavaMail.weblogic@epml02>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9BAbd54010147



> Subject: Re: [PATCH] extcon : register for cable interest by cable name
> 
> > There are some scnearios where a driver/framework needs to register
> > interest for a particular cable without specifying the extcon device
> > name. One such scenario is charger notifications. The platform will
> > have charger cabel which will be bound to any extcon device. It's not
> > mandatory for the charger driver to know which extcon device it should
> > use. This patch enables the support for registering interest for a
> > cable just by cable name wihtout specifying the extcon device name
> >
> > Signed-off-by: Jenny TC <jenny.tc@intel.com>
> > ---
> []
> > +extern struct extcon_dev *register_interest_cable_byname
> > +		(struct extcon_specific_cable_nb *extcon_dev,
> > +		const char *cable_name, struct notifier_block *nb);
> 
> What about allowing extcon_register_interest() to support the functionality?
> 
register_interest_cable_byname  internally uses extcon_register_interest   function.
If we want to use  extcon_register_interest()  in both scenarios,  then we need to define
two local functions 

 extcon_register_interest__ and  register_interest_cable_byname. 

Then the code would be

int extcon_register_interest(struct extcon_specific_cable_nb *obj,
		 const char *extcon_name, const char *cable_name,
                             	struct notifier_block *nb) {

	if (extcon_name == NULL)
		return register_interest_cable_byname(obj,cable_name,nb);
	else
		return extcon_register_interest__(obj,extcon_name,cable_name,nb);
}

Is that fine?

> I.e., allowing extcon_register_interest() to accept NULL extcon_name.
> 
> 
> ps. anyway, usually, the "platforms" have the list of node paths, don't they?
>
My intention is to make it generic and less dependent on platform data. This way the same consumer
driver can work on any platform without looking for extcon dev name in the platform data. 
For example a charger driver can work on any platform without knowing the extcon provider name for
The charger cable.

 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
