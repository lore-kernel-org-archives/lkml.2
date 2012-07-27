Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab2G0S2i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 14:28:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:13885 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab2G0S2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 14:28:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="187873365"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] power_supply: Added support for power supply
 attribute sources
Thread-Topic: [PATCH v2] power_supply: Added support for power supply
 attribute sources
Thread-Index: AQHNa1EJWIdfvnQDiEGweUQ6FfhnH5c9cnvA
Date: Fri, 27 Jul 2012 18:28:31 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD1C31C9@BGSMSX102.gar.corp.intel.com>
References: <1343315844-18824-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120726170411.GA19112@lizard>
In-Reply-To: <20120726170411.GA19112@lizard>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6RISjXx028090

Hi Anton,

> On Thu, Jul 26, 2012 at 08:47:24PM +0530, Ramakrishna Pallala wrote:
> > On some platforms one driver(or HW chip) may not be able to provide
> > all the necessary attributes of the power supply connected to the
> > platform or may provide very limited info which can be used by core/primary
> drivers.
> >
> > For example a temperature sensor chip placed near the battery can be
> > used to report battery ambient temperature but it does not makes sense
> > to register sensor driver with power supply class. Or even a ADC
> > driver or platform driver may report power supply properties like
> > voltage/current or charging status but registering all those driver
> > with power supply class is not a practical or ideal approach.
> >
> > This patch adds the generic support to register the drivers as power
> > supply attribute(properties) sources and adds an interface to read
> > these attributes from power supply class drivers.
> >
> > If there are multiple attribute sources of the same type then caller
> > has to do source selection by passing the source string in the query struct.
> >
> > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> > ---
> [...]
> > +extern int power_supply_attributes_register(struct device *parent,
> > +				struct power_supply_attr_source *psy_attr);
> 
> Can you please show some user of the new calls? If I understand correctly,
> you're going to call these from sensing (ADC, or some
> other) drivers, which would be very very wrong thing to do.

I have submitted two patches, one on smb347_charger driver and one on max17042_battery driver
to demonstrate the use of these API's.

[PATCH] smb347_charger: Add support for battery power supply attributes registration
[PATCH] max17042_battery: add support for battery STATUS and CHARGE_TYPE

Please review and let me know your comments.

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
