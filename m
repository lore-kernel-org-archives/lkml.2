Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030273Ab2CNCBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 22:01:17 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:36902 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965170Ab2CNCBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 22:01:15 -0400
X-AuditID: cbfee60c-b7c83ae000001e65-8c-4f5ffbe4297b
Date: Wed, 14 Mar 2012 02:01:09 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH 5/5] max17042: Change capacity property to use reported
 SOC register
To: Anton Vorontsov <cbouatmailru@gmail.com>,
        "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Jason.Wortham@maxim-ic.com" <Jason.Wortham@maxim-ic.com>,
        "bruce.e.robertson@intel.com" <bruce.e.robertson@intel.com>,
        Karol Lewandowski <k.lewandowsk@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120314015711115@myungjoo.ham
Msgkey: 20120314015711115@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120314015711115@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <11735275.125381331690467424.JavaMail.weblogic@epml04>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2E21MSw025299

Anton Vorontsov<cbouatmailru@gmail.com>, 2012-03-14 03:34 (GMT+09:00)
> On Tue, Jan 24, 2012 at 09:26:08AM -0800, dirk.brandewie@gmail.com wrote:
> > From: Dirk Brandewie 
> > 
> > The SOC register (0dh) reports the state of charge before empty
> > compensation adjustments are applied.  The max value reported by this
> > register will decrease as the battery ages.
> > 
> > Use the RepSOC register (06h) to report the capacity of the
> > battery. RepSOC contains a filtered version of the battery capacity
> > after empty compensation adjustments have been applied.
> > 
> > Reported-by: Gary Keyes 
> > 
> > Signed-off-by: Dirk Brandewie 
> > ---
> >  drivers/power/max17042_battery.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/power/max17042_battery.c b/drivers/power/max17042_battery.c
> > index 6e96b58..2194278 100644
> > --- a/drivers/power/max17042_battery.c
> > +++ b/drivers/power/max17042_battery.c
> > @@ -160,7 +160,7 @@ static int max17042_get_property(struct power_supply *psy,
> >   break;
> >   case POWER_SUPPLY_PROP_CAPACITY:
> >   val->intval = max17042_read_reg(chip->client,
> > - MAX17042_SOC) / 256;
> > + MAX17042_RepSOC) / 256;
> 
> Applied. But I don't get it: PROP_CAPACITY should report
> percents! And it looks that it reports something very
> different.

The 8 most significant bits show values in percents. The least 8 bits show 1/256 percents.

> 
> Also, if you look down the file, you'll see this:
> 
>         case POWER_SUPPLY_PROP_CHARGE_FULL:

I've just sent a patch to correct this problem: "max17042: fix CHARGE_FULL representation."



Cheers!
MyungJoo

--
MyungJoo Ham (ÇÔ¸íÁÖ), PHD
System S/W Lab, S/W Platform Team, Software Center
Samsung Electronics
Cell: +82-10-6714-2858
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
