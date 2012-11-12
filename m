Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab2KLHbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 02:31:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:34212 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab2KLHbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 02:31:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,759,1344236400"; 
   d="scan'208";a="240535919"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: "Zhang, Rui" <rui.zhang@intel.com>
CC: Amit Kachhap <amit.kachhap@linaro.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "jonghwa3.lee@samsung.com" <jonghwa3.lee@samsung.com>
Subject: RE: [PATCH 1/4] thermal: Add new thermal trend type to support
 quick cooling
Thread-Topic: [PATCH 1/4] thermal: Add new thermal trend type to support
 quick cooling
Thread-Index: AQHNvWlKuI/lwtvFeEqAROZO0ibuK5ffFgeAgAAG54CAAWboAIAAKhGAgAUJ8dD//7BQgIAAbBLA
Date: Mon, 12 Nov 2012 07:31:27 +0000
Message-ID: <4D68720C2E767A4AA6A8796D42C8EB59206162@BGSMSX101.gar.corp.intel.com>
References: <1352348786-24255-1-git-send-email-amit.kachhap@linaro.org>
	 <1352348786-24255-2-git-send-email-amit.kachhap@linaro.org>
	 <1352354503.2190.7.camel@rzhang1-mobl4>
	 <CAK44p22REJpaJiahX7sTofShNB-+OHVsULqHeuxFNu5msLk6vA@mail.gmail.com>
	 <1352433060.2166.3.camel@rzhang1-mobl4>
	 <CAK44p22hHVcL21B1iy1OnECMd5RCRF8DVh-cNj=6Bmvr5n0yyQ@mail.gmail.com>
	 <4D68720C2E767A4AA6A8796D42C8EB59206068@BGSMSX101.gar.corp.intel.com>
 <1352701993.1834.26.camel@rzhang1-mobl4>
In-Reply-To: <1352701993.1834.26.camel@rzhang1-mobl4>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qAC7Vo1w008255



> -----Original Message-----
> From: Zhang, Rui
> Sent: Monday, November 12, 2012 12:03 PM
> To: R, Durgadoss
> Cc: Amit Kachhap; linux-pm@lists.linux-foundation.org; linux-samsung-
> soc@vger.kernel.org; linux-kernel@vger.kernel.org; lenb@kernel.org; linux-
> acpi@vger.kernel.org; jonghwa3.lee@samsung.com
> Subject: RE: [PATCH 1/4] thermal: Add new thermal trend type to support
> quick cooling
> 
> On Sun, 2012-11-11 at 22:55 -0700, R, Durgadoss wrote:
> > Hi Amit/Rui,
> >
> > > -----Original Message-----
> > > From: Amit Kachhap [mailto:amit.kachhap@linaro.org]
> > > Sent: Friday, November 09, 2012 11:52 AM
> > > To: Zhang, Rui
> > > Cc: linux-pm@lists.linux-foundation.org; linux-samsung-
> > > soc@vger.kernel.org; linux-kernel@vger.kernel.org; R, Durgadoss;
> > > lenb@kernel.org; linux-acpi@vger.kernel.org;
> jonghwa3.lee@samsung.com
> > > Subject: Re: [PATCH 1/4] thermal: Add new thermal trend type to
> support
> > > quick cooling
> > >
> > > On 9 November 2012 09:21, Zhang Rui <rui.zhang@intel.com> wrote:
> > > > On Thu, 2012-11-08 at 11:56 +0530, Amit Kachhap wrote:
> > > >> On 8 November 2012 11:31, Zhang Rui <rui.zhang@intel.com> wrote:
> > > >> > On Thu, 2012-11-08 at 09:56 +0530, Amit Daniel Kachhap wrote:
> > > >> >> This modification adds 2 new thermal trend type
> > > THERMAL_TREND_RAISE_FULL
> > > >> >> and THERMAL_TREND_DROP_FULL. This thermal trend can be used
> to
> > > quickly
> > > >> >> jump to the upper or lower cooling level instead of incremental
> > > increase
> > > >> >> or decrease.
> > > >> >
> > > >> > IMO, what we need is a new more aggressive cooling governor
> which
> > > always
> > > >> > uses upper limit when the temperature is raising and lower limit
> when
> > > >> > the temperature is dropping.
> > > >> Yes I agree that a new aggressive governor is the best approach but
> > > >> then i thought adding a new trend type is a simple solution to achieve
> > > >> this and since most of the governor logic might be same as the
> > > >> step-wise governor. I have no objection in doing it through governor.
> > > >> >
> > > > hmmm,
> > > > I think a more proper way is to set the cooling state to upper limit
> > > > when it overheats and reduce the cooling state step by step when the
> > > > temperature drops.
> > >
> > > No actually I was thinking of having a  simple governor with a feature
> > > like it only sets to upper level and lower level. Also since the
> > > temperature sensor is capable of interrupting for both increase in
> > > threshold(say 100C)  and fall in threshold (say 90C), so polling or
> > > step increments is not needed at all.
> > > Currently stepwise governor governor does that so we might change the
> > > macro name as,
> > > THERMAL_TREND_RAISE_STEP,
> > > THERMAL_TREND_DROP_STEP,
> > > THERMAL_TREND_RAISE_MAX,
> > > THERMAL_TREND_DROP_MAX,
> > >
> > > and file step_wise.c can be named as state_wise.c or trend_wise.c.
> >
> > Yes, in this particular case, we neither need to poll nor do step wise
> > operations. But, most of the other sensors need at least one of them.
> >
> > So, I think we can try it this way:
> > 	if (sensor supports interrupt) {
> > 		'always' use RAISE_MAX and DROP_MAX;
> > 	} else {
> > 		Do Step wise operations
> > 	}
> >
> why should the generic thermal layer be aware of this?
> 
> IMO, it is the platform thermal driver that is responsible for returning
> THERMAL_TREND_RAISE_STEP or THERMAL_TREND_RAISE_MAX.
> 
> and the step_wise governor just takes action based on the return value
> of .get_trend() callback.

Yes, agree with the flow ..

Thanks,
Durga
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
