Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab0HJT34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 15:29:56 -0400
Received: from be1ssnxpe2.nxp.com ([57.67.164.70]:47581 "EHLO
	be1ssnxpe2.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab0HJT3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 15:29:54 -0400
X-Greylist: delayed 1282 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Aug 2010 15:29:54 EDT
From: Kevin Wells <kevin.wells@nxp.com>
To: Wan ZongShun <mcuos.com@gmail.com>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Durgesh Pattamatta <durgesh.pattamatta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kevin Wells <wellsk40@gmail.com>
Date: Tue, 10 Aug 2010 21:08:16 +0200
Subject: RE: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver
 	for the LPC32XX SoC
Thread-Topic: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver
 	for the LPC32XX SoC
Thread-Index: Acs4L9xNUR6YLw0PTi+Q/e95sBshCQAhHH2w
Message-ID: <083DF309106F364B939360100EC290F80AC6E5F76D@eu1rdcrdc1wx030.exi.nxp.com>
References: <1281370650-29520-1-git-send-email-wellsk40@gmail.com>
	<1281370650-29520-2-git-send-email-wellsk40@gmail.com>
 <AANLkTimAJj38R7KCfHusfsq+EXDd3fbAm=Az_Osqdgbz@mail.gmail.com>
In-Reply-To: <AANLkTimAJj38R7KCfHusfsq+EXDd3fbAm=Az_Osqdgbz@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000 definitions=2010-08-10_07:2010-08-10,2010-08-10,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7AJU5KF029565

Hi Zongshun,

Thanks for helping review this.

> Subject: Re: [rtc-linux] [PATCH 1/2] rtc: rtc-lpc32xx: Introduce RTC driver
> for the LPC32XX SoC
> 
> Hi Kevin ,
> 
> This is really a natty rtc patch:).

>From the urban dictionary...
"natty"
1) originating from rastafarian culture. meaning 'good','cool' and
most importantly, 'elite'.
2) A slang for Natural Light beer, a favorite of poor college students
the world over.

I hope it's the first one, but I guess the 2nd isn't that bad if
youâ€™re a college student o)
I'll merge both patches into a single patch for v2 and repost in a
few days.

> > + Â  Â  Â  /* Disable alarm during update */
> > + Â  Â  Â  tmp = rtc_readl(rtc, RTC_CTRL);
> > + Â  Â  Â  rtc_writel(rtc, RTC_CTRL, tmp & ~RTC_MATCH0_EN);
> > +
> > + Â  Â  Â  rtc->alarm_enabled = wkalrm->enabled = 1;
> > + Â  Â  Â  if (wkalrm->enabled) {
> > + Â  Â  Â  Â  Â  Â  Â  rtc_writel(rtc, RTC_MATCH0, alarmsecs);
> > + Â  Â  Â  Â  Â  Â  Â  rtc_writel(rtc, RTC_INTSTAT, RTC_MATCH0_INT_STS);
> > + Â  Â  Â  Â  Â  Â  Â  rtc_writel(rtc, RTC_CTRL, tmp | RTC_MATCH0_EN);
> > + Â  Â  Â  }
> 
> I think this 'wkalrm->enabled ' will always be set '1', so 'if'
> condition will be alway true?

Thanks for catching this. The '= 1' assignment shouldn't be there.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
