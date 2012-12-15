Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab2LOCzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 21:55:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:11754 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547Ab2LOCzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 21:55:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,285,1355126400"; 
   d="scan'208";a="264335853"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "'Anton Vorontsov'" <cbouatmailru@gmail.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'Chanwoo Choi'" <cw00.choi@samsung.com>,
        "'myungjoo.ham@samsung.com'" <myungjoo.ham@samsung.com>,
        "'anish kumar'" <anish198519851985@gmail.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: RE: [PATCH] EXTCON: Get and set cable properties
Thread-Topic: [PATCH] EXTCON: Get and set cable properties
Thread-Index: AQHNzLrkDMuiwiRHbU6SrIDfqYZ+tpgFGRSggADcegCAAGMxgIAS7LqA
Date: Sat, 15 Dec 2012 02:55:43 +0000
Message-ID: <20ADAB092842284E95860F279283C564E4D674@BGSMSX101.gar.corp.intel.com>
References: <1354052956-3394-1-git-send-email-jenny.tc@intel.com>
 <20ADAB092842284E95860F279283C564E2754F@BGSMSX101.gar.corp.intel.com>
 <20121203012916.GA7330@lizard.sbx05977.paloaca.wayport.net>
 <20ADAB092842284E95860F279283C564E293C9@BGSMSX101.gar.corp.intel.com>
In-Reply-To: <20ADAB092842284E95860F279283C564E293C9@BGSMSX101.gar.corp.intel.com>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBF2tvkl004664

Anton,

Could you please have a look at my comments below?

-jtc

> > While I see nothing wrong with the patch itself, I beg you to send
> > some users for the new calls. Don't be obsessed with the extcon
> > internals too much, think more about how things will interact (i.e. I
> > really really want to see how you use these calls from the power supply
> drivers).
> 
> The usage of extcon cable property is captured in patch
> https://lkml.org/lkml/2012/10/18/219
> This patch uses a extcon_dev  callback function get_cable_properties() to get
> the cable properties. As discussed in the previous mail thread, it may not be
> good to have a extcon call back function since the extcon provider may not
> be aware of the cable properties. This patch replaces the callback function
> with an API, so that whoever knows the cable property, can set the property
> using the extcon API extcon_cable_set_data().
> 
> The usage flow would be
> 1)Consumer gets a notification from the extcon 2)consumer reads the
> property using the API extcon_cable_get_data
> 
> This way it doesn't mandatory for the extcon provider to give the cable
> property.
> Anyone who is aware of the cable property can set the cable property using
> the API.
> It makes the consumer and provider implementations very simple.
> 
> With this new API, the callback function in patch
> https://lkml.org/lkml/2012/10/18/219 can be replaced by the API
> extcon_cable_set_data().
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
