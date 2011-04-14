Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752911Ab1DNLkW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 07:40:22 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:56133
	"EHLO VA3EHSOBE007.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750968Ab1DNLkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 07:40:21 -0400
X-SpamScore: -39
X-BigFish: VPS-39(zzbb2cK936eK9371O1447R98bK542M1432N98dKzz1202hzz8275bh8275dhz32i2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:kcinpunhjhc02.kpit.com;RD:none;EFVD:NLI
From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Gortmaker <p_gortmaker@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 14 Apr 2011 17:09:15 +0530
Subject: RE: [PATCHv1 3/11] RTC: RTC module of DA9052 PMIC driver
Thread-Topic: [PATCHv1 3/11] RTC: RTC module of DA9052 PMIC driver
Thread-Index: Acv5arC8IORi9+Z3TwKJbf3i6lkpZABLLS5w
Message-ID: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B677893@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B4AC209@KCINPUNHJCMS01.kpit.com>
 <20110412163743.1d7353c4.akpm@linux-foundation.org>
In-Reply-To: <20110412163743.1d7353c4.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3EBeUlE019233

Hi Andrew,

Thanks for the review comments. We have addresses most of the comments in the posting done recently. For some of your queries, kindly see our response below. 

Regards,
Ashish J

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Wednesday, April 13, 2011 5:08 AM
> To: Ashish Jangam
> Cc: Paul Gortmaker; linux-kernel@vger.kernel.org
> Subject: Re: [PATCHv1 3/11] RTC: RTC module of DA9052 PMIC driver
> 
> On Wed, 6 Apr 2011 18:47:29 +0530
> Ashish Jangam <Ashish.Jangam@kpitcummins.com> wrote:
> 
> > Hi Paul,
> >
> > RTC Driver for Dialog Semiconductor DA9052 PMICs.
> >
> > Changes made since last submission:
> > . read and write operation moved to MFD
> >
> > Linux Kernel Version: 2.6.37
> 
> The patch looks OK(ish) to me from a quick read.
> 
> > --- orig_linux-2.6.37/drivers/rtc/Kconfig	2011-01-05 05:50:19.000000000
> +0500
> > +++ linux-2.6.37/drivers/rtc/Kconfig	2011-03-31 21:07:39.000000000 +0500
> > @@ -664,6 +664,13 @@
> >  	help
> >  	  If you say yes here you get support for the RTC subsystem of the
> >  	  NUC910/NUC920 used in embedded systems.
> > +
> > +config RTC_DRV_DA9052
> > +	tristate "Dialog DA9052 RTC"
> > +	depends on PMIC_DA9052
> > +	help
> > +	  Say y here to support the RTC driver for
> > +	  Dialog Semiconductor DA9052 PMIC.
> 
> But there's not much I can do with it because PMIC_DA9052 does not
> exist in mainline or in linux-next.
DA9052 RTC has been placed under the "comment "Platform RTC drivers" section of drivers\rtc\Kconfig as the DA9052 MFD supports both the SPI and I2C serial protocols.
> 
> What is a PMIC_DA9052, anyway?  What CPU architectures support it, etc?
The DA9052 are designed to support application processors and associated peripherals. The DA9052 provides 11 LDO's and 4 high efficiency programmable Buck Converters which deliver high efficiency across a wide range of line and load conditions. DA9052 PMIC is widely used in portable navigation devices and other handhelds for efficient power management.
> Have you identified a maintainer who will be merging the main patch
> which enables PMIC_DA9052?
We have  sent the DA9052 MFD patch which will enable the PMIC DA9052 for review comments to Mark Brown and the LKML mailing list community for their views on it.
> 
> 
> Please feed all the patches through scritps/checkpatch.pl if you haven't
> already done so, to clean up lots of trivial errors.
> 
> For example, "MFD: MFD module of DA9052 PMIC driver":
> 
> 	total: 449 errors, 832 warnings, 2326 lines checked
> 
> 
> A couple of minor comments:
> 
> > +static int da9052_rtc_enable_alarm(struct da9052 *da9052, unsigned char
> flag)
> > +{
> > +	int ret = 0;
> > +	if (flag) {
> > +		ret = da9052_set_bits(da9052, DA9052_ALARM_Y_REG,
> > +					DA9052_ALARM_Y_ALARM_ON);
> > +		if (ret != 0)
> > +			dev_err(da9052->dev, "Failed to enable ALM: %d\n", ret);
> > +	} else {
> > +		ret = da9052_clear_bits(da9052, DA9052_ALARM_Y_REG,
> > +					DA9052_ALARM_Y_ALARM_ON);
> > +		if (ret != 0)
> > +			dev_err(da9052->dev, "da9052_rtc_enable_alarm -> \
> > +					da9052_clear_bits error %d\n", ret);
> > +	}
> > +	return ret;
> > +}
> 
> "flag" is a poor identifier - it's largely meaningless.  Perhaps
> "enable" would be a better choice in this case.  Making it have the
> bool type wouild make sense also.
> 
> > +static irqreturn_t da9052_rtc_irq(int irq, void *data)
> > +{
> > +	struct da9052_rtc *rtc = (struct da9052_rtc *)data;
> 
> typecasting a void* like this is unneeded and is in fact undesirable,
> as it will suppress possibly-useful warnings.
> 
> 
> > +	int ret = 0;
> > +
> > +	ret = da9052_reg_read(rtc->da9052, DA9052_ALARM_MI_REG);
> > +	if (ret < 0) {
> > +		dev_err(rtc->da9052->dev, "da9052_rtc_notifier -> \
> > +					da9052_reg_read error %d\n", ret);
> > +		return IRQ_NONE;
> > +	}
> > +	if (ret & DA9052_ALARMMI_ALARMTYPE)
> > +		da9052_rtc_enable_alarm(rtc->da9052, 0);
> > +
> > +	return IRQ_HANDLED;
> > +}
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
