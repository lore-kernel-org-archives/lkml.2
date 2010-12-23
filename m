Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab0LWIRn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 03:17:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:23406 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab0LWIRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 03:17:42 -0500
Date: Thu, 23 Dec 2010 08:17:39 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [PATCH v2 5/6] MFD MAX8998/LP3974: Charger Support
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Alessandro Zummo <a.zummo@towertech.it>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        =?euc-kr?Q?=BD=C9=C1=D8=BF=B5?= <jy0922.shim@samsung.com>,
        Lukasz Majewski <l.majewski@samsung.com>, myungjoo.ham@gmail.com
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20101223080813603@myungjoo.ham
Msgkey: 20101223080813603@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20101223080813603@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <11010626.33361293092258636.JavaMail.weblogic@epv6ml06>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oBN8HrU5022550

Sender : Mark Brown<broonie@opensource.wolfsonmicro.com>
> On Thu, Dec 23, 2010 at 11:10:41AM +0900, MyungJoo Ham wrote:
> > On Wed, Dec 22, 2010 at 10:33 PM, Mark Brown
> > > On Wed, Dec 22, 2010 at 03:23:10PM +0900, MyungJoo Ham wrote:
> 
> > > Normally I'd expect a battery charger to be exposed via the power supply
> > > API - I'd at least expect to see a consumer in the power supply API
> 
> > The "CHARGER" regulator is to give the charger control to the user,
> > which consists of switching (turn on/off) and current limit, which is
> > what a current regulator does. On the contrary, when the charger
> > control is implemented by power supply API, we do not have explicit
> > control over such features (current limit and turn on/off).
> 
> Sure, like I say I'd just expect to see some power supply API visibility
> - that could be a driver that provides the control that's needed to
> userspace by controlling a current regulator, for example.

Alright. In the next patch release, I'll use power supply API with MAX8998
driver to show some status values. It appears that it's easier for me to
write charger controllers with it. :)

> 
> > Furthermore, a board may need to support multiple types of
> > charger(USB, ACDC-5V-2A, ACDC-5V-1A, ...), which have various current
> > limits. Thus, we need to adjust charger current limit out of PMIC
> > driver unless the PMIC can detect every type of supported chargers,
> > which MAX8998/LP3974 cannot.
> 
> Interesting system design - I've not seen that before.  With the system
> designs I usually look at the current limiting from the wall/charger
> supply is done on the primary system power rail which supplies both
> thehcarger and the rest of the system (since the current drains from the
> rest of the system also needs to be limited).  Similarly for the
> temperature monitoring, I've usually seen that managed by hardware.

Yes.. I'd be haapy if they design boards like that for me, too. :D
But, somehow, they attached a thermistor directly to an ADC port of CPU
and CPU needs to determine charge current.

> 
> > That's why I have implemented charger in regulator framework. In the
> > environment described above, the power supply consumer is going to be
> > implemented over PMIC driver, USB/TA select driver (e.g., FSA9480),
> > and Thermistor driver (e.g., NTC Thermistor). It appears that such a
> > consumer driver is going to be a board or policy specification; (or
> > full or callbacks that is going to be filled by a mach/board file)
> 
> I agree - it'd be a bit like the current GPIO power supply driver, I
> think.  It'd probably also specify things like callbacks for voltage
> monitoring via auxiliary ADCs in the PMIC or CPU.  My main point was
> that it was surprising that the regulator driver for the charger didn't
> come along with such a consuner driver, the split does make sense.

Thanks!

 MyungJoo Ham (ÇÔ¸íÁÖ)
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
