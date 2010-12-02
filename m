Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab0LBCl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 21:41:29 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:65416 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab0LBCl2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 21:41:28 -0500
MIME-Version: 1.0
In-Reply-To: <20101201112515.GC24176@rakim.wolfsonmicro.main>
References: <AANLkTi=E8etAOPTCBw8ccTZ9LMU-Yf=wELn+VQkg2eom@mail.gmail.com>
	<20101201112515.GC24176@rakim.wolfsonmicro.main>
Date: Thu, 2 Dec 2010 10:41:27 +0800
Message-ID: <AANLkTikyNNSbx2hWjWh4WFKbyGcii_QxqpTneVygwJMN@mail.gmail.com>
Subject: Re: [PATCHv2] make mc13783 regulator code generic
From: Yong Shen <yong.shen@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linaro Dev <linaro-dev@lists.linaro.org>,
        List Linux Arm Kernel <linux-arm-kernel@lists.infradead.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

please see inline feedback.

On Wed, Dec 1, 2010 at 7:25 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Dec 01, 2010 at 03:15:55PM +0800, Yong Shen wrote:
>
>>  move some common functions and micros of mc13783 regulaor driver to
>> a seperate file, which makes it possible for mc13892 to share code.
>
> You've done way more than this in the patch - you've also renamed a lot
> of things and done other restructurings.  I'd suggest splitting out the
> big mechanical changes for easier review.  For example, a patch moving
> code from one place to another, another patch renaming things and so on.
>
>> +config REGULATOR_MC13XXX_CORE
>> +     tristate "Support regulators on Freescale MC13xxx PMIC"
>> +
>
> This doesn't need to be user visible - the user only cares about the
> individual regulator drivers.
>
>>       /* Power Gate enable value is 0 */
>> -     if (id == MC13783_REGU_PWGT1SPI ||
>> -         id == MC13783_REGU_PWGT2SPI)
>> +     if (id == MC13783_REG_PWGT1SPI ||
>> +         id == MC13783_REG_PWGT2SPI)
>>               en_val = 0;
>
> I can't tell what the actual change is here?
The macro names changed. And this will go into a separate patch.
>
>> +int mc13xxx_sw_regulator(struct regulator_dev *rdev)
>> +{
>> +     return 0;
>> +}
>> +
>
> Eh?
Confused naming and it is not necessary. it will be removed.
>
>> +MODULE_ALIAS("platform:mc13xxx-regulator-core");
>
> Is there really going to be a platform device for this?
ACKed.
>
>> +++ b/include/linux/regulator/mc13xxx.h
>
> Pretty much everything in this file is internal to the driver and
> shouldn't be in include/linux.
>
ACKed.
