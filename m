Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210Ab2LOAQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 19:16:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:6545 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135Ab2LOAQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 19:16:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,285,1355126400"; 
   d="scan'208";a="234345863"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: anish kumar <anish198519851985@gmail.com>
CC: Chanwoo Choi <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: RE: [PATCH] EXTCON: Get and set cable properties
Thread-Topic: [PATCH] EXTCON: Get and set cable properties
Thread-Index: AQHNzLrkDMuiwiRHbU6SrIDfqYZ+tpgF8SMAgABmvWD//+DFAIAQnMsQ
Date: Sat, 15 Dec 2012 00:16:25 +0000
Message-ID: <20ADAB092842284E95860F279283C564E4D554@BGSMSX101.gar.corp.intel.com>
References: <1354052956-3394-1-git-send-email-jenny.tc@intel.com>
	 <50BBFCB8.4080903@samsung.com>
	 <20ADAB092842284E95860F279283C564E29388@BGSMSX101.gar.corp.intel.com>
 <1354512564.1600.117.camel@anish-Inspiron-N5050>
In-Reply-To: <1354512564.1600.117.camel@anish-Inspiron-N5050>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBF0GiNV004266


> > I replied on the thread and pointed out issues that I see with this
> > solution. IMHO It's not fair to register a cable with
> > power_supply/regulator/charger manager just to expose the cable
> properties.
> Don't we do that with already in allmost all drivers?Like if I have a keyboard
> driver and then I register with input framework and if the keyboard driver
> needs clk services then I register with clk framework as well and same with
> other services needed by keyboard driver.I think it makes sense for a cable
> to register with different framework if it supports that functionality as those
> services also would know that we have a cable with so and so property.

IMHO it's not a good choice to register a cable itself with any of the three subsystem
(power_supply/regulator/charger manager)

 For example it cannot register with power_supply subsystem since it's not a 
 power_supply. It's just source for a power_supply.We register either charger/battery with
 power supply. I couldn't find a way to register the cable with power supply subsystem. 

In previous discussion Anton also agreed to this.

Anton,
Could you please confirm?

I think the same case with regulator framework also. A cable doesnâ€™t belong to a regulator framework.
A cable doesnâ€™t expose any control attribute (current control/voltage control). It just have  properties (eg current)
 controlled by external agents (Host machine/wall charger)

And charger manager is a consumer and not a provider. It cannot decide the charger cable capabilities.


> > > As I said, extcon provider driver didn't provide directly charging
> > > current(int
> > > mA) and some state(unsigned long state) because the extcon provider
> > > driver(Micro USB interface controller device or other device related
> > > to external connector) haven't mechanism which detect dynamically
> > > charging current immediately. If you wish to provide charging
> > > current data to extcon consumer driver or framework, you should use
> > > regulator/power_supply framework or other method in extcon provider
> driver.

This information need not to come from the extcon provider. It can come from any driver
Who knows the state of a cable. It may be a platform driver or may be a driver belongs to any
of the three subsystem we discussed above (power_supply/regulator/charger_manager).
Just by having an API like this (extcon_cable_set_data), it's not mandatory to register the cable
with any of the subsystem.

> > > Also if you want to define 'struct extcon_chrgr_cable_props', you
> > > should certainly show how detect dynamically charging current or state.

For USB cables, it's determined by USB enumeration. For USB 3.0 it would be 900mA and
USB 2.0 it's 500mA. Also in un configured  state this would be 150 and 100mA respectively
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
