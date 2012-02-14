Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab2BNHAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 02:00:53 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:18121 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab2BNHAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 02:00:52 -0500
X-AuditID: cbfee612-b7c09ae0000024ca-85-4f3a06a0ef8b
Date: Tue, 14 Feb 2012 07:00:48 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH v5 5/5] Extcon: adc-jack driver to support 3.5 pi or
 simliar devices
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        NeilBrown <neilb@suse.de>, Randy Dunlap <rdunlap@xenotime.net>,
        Mike Lockwood <lockwood@android.com>,
        =?euc-kr?Q?Arve_Hj=3Fnnevag?= <arve@android.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        =?euc-kr?Q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>,
        Greg KH <gregkh@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        John Stultz <john.stultz@linaro.org>,
        Joerg Roedel <joerg.roedel@amd.com>, myungjoo.ham@gmail.com
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120214064454582@myungjoo.ham
Msgkey: 20120214064454582@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120214064454582@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1724827.104121329202847962.JavaMail.weblogic@epml06>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1E70wAb007796

Mark Brown wrote:
> On Tue, Feb 14, 2012 at 11:22:14AM +0900, MyungJoo Ham wrote:
> > On Sat, Feb 11, 2012 at 1:25 AM, Mark Brown
> > <broonie@opensource.wolfsonmicro.com> wrote:
> > > On Fri, Feb 10, 2012 at 03:40:38PM +0900, MyungJoo Ham wrote:
> > >> External connector devices that decides connection information based on
> > >> ADC values may use adc-jack device driver. The user simply needs to
> > >> provide a table of adc range and connection states. Then, extcon
> > >> framework will automatically notify others.
> 
> > > This really should be done in terms of the IIO in-kernel framework.
> 
> > The ADC part may be done in IIO. However, the intention of this device
> > driver is to provide extcon interface to any ADC drivers, not
> > providing an ADC device driver. If we are going to implement this in
> 
> Right, exactly.
> 
> > the ADC driver in IIO, we will need to write the given code in every
> > ADC driver used for analog ports.
> 
> No, that's not what I'm suggesting - what I'm suggesting is that rather
> than having a callback for implementing the ADC read functionality this
> should work as an in-kernel IIO driver so it'll just automatically work
> with any ADC without needing code to hook things up.  Unless I've not
> understood your comment fully.

Ok. Do you mean that we should give struct iio_dev * and struct iio_chan_spec * instead of a callback?
I thought there was no standard framework for ADC (the reason why this is a simple callback); however, may I regard iio/adc as the standard for ADC? (I see some ADC device drivers in HWMON)

Do I need to make this driver as an iio device driver in order to do this? I guess including iio.h would be enough anyway.


> 
> > >> +     /* Check the length of array and set num_cables */
> > >> +     for (i = 0; data->edev.supported_cable[i]; i++)
> > >> +             ;
> > >> +     if (i == 0 || i > SUPPORTED_CABLE_MAX) {
> 
> > > Can we not avoid the hard limit?
> 
> > Without that limit, we won't be able to easily express binary cable
> > status (u32) with the extcon framework. At least, we will need to
> > forget about setting the status with u32 values.
> 
> > Anyway, I can remove the checking SUPPORT_CABLE_MAX part at probe.
> 
> It might be clearer to make the limit more obviously associated with
> the bitmask - it looks like it's an array thing the way the code is
> written but a limit due to using a bitmask seems reasonable.
> 
> 

Ah.. I'll add a comment or update the error message associated.


Cheers!
MyungJoo.

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
