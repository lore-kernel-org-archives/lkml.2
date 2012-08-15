Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab2HOC2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 22:28:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:48674 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753203Ab2HOC2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 22:28:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,770,1336374000"; 
   d="scan'208";a="208554465"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] max17042_battery: add support for battery STATUS and
 CHARGE_TYPE
Thread-Topic: [PATCH] max17042_battery: add support for battery STATUS and
 CHARGE_TYPE
Thread-Index: AQHNdUn+gL445xu300ubXjvWlDtWJpdaME/g
Date: Wed, 15 Aug 2012 02:28:41 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD22482D@BGSMSX102.gar.corp.intel.com>
References: <1343408181-21988-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120808093857.GA1402@lizard>
In-Reply-To: <20120808093857.GA1402@lizard>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q7F2SqIj019234

> On Fri, Jul 27, 2012 at 10:26:21PM +0530, Ramakrishna Pallala wrote:
> > This patch adds the support to report the battery power supply
> > attributes STATUS and CHARGE_TYPE. This patch makes use of
> > power_supply_get_external_attr() API to get these attributes through power
> supply core.
> >
> > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> > ---
> [...]
> >  	switch (psp) {
> > +	case POWER_SUPPLY_PROP_STATUS:
> > +		ret = power_supply_get_external_attr(&query);
> > +		if (ret < 0)
> > +			return ret;
> > +		val->intval = query.res.intval;
> > +		break;
> 
> First of, thanks a lot for your work. And sorry that it took me quite a while to
> review it, but these are fundamental changes, so I had to thoughtfully consider
> all this.
> 
> This exact code clearly shows that it is not battery's property. Battery itself
> cannot report it, right? OK, here is what
> Documentation/power/power_supply_class.txt says:
> 
> A: Most likely, no. This class is designed to export properties which are
>    directly measurable by the specific hardware available.
> 
>    Inferring not available properties using some heuristics or mathematical
>    model is not subject of work for a battery driver. Such functionality
>    should be factored out
> 
> So, you basically try to infer battery's properties from the charger hw.
> This is surely doable, but no, I think we should not do this. Instead, what we
> want is to make use of "supplied_to" mechanism of the power supply class, and
> export it via sysfs. Then userland can see all the power supply hierarchy, and
> thus see which hardware provides which data.
> 
> See my thoughts about exporting "supplied_to" to the sysfs:
> 
> 	http://lkml.org/lkml/2011/6/22/258
> 
> So, we'll have:
> 
> /sys/
>    class/
>       power_supply/
>          charger/
>             supplied_to/battery -> ../../battery
>          battery/
> 
> Sure, we'll have to teach userland to operate on this scheme, i.e.
> it must be aware that batteries might be connected to an external charger, and
> if so, userland must query* charging status from the charger.
> 
> Do you see any problem with this approach?
> 
> Thanks!

Got your point. I will try this approach.
Thanks for your time :-)

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
