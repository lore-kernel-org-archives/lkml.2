Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab1DRPdl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:33:41 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33500 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145Ab1DRPde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:33:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=q/oxTXxeKaX1RZ/SSHFfvzsqsO0puNyYeXtyVyX+0fWh4HbTgwJw9suvhe+ny7q0Sv
         823PJZjKKiCFH0nriLsUcgVDSIOfh+3KM2eOKS2FiOvKo2f4we/G+c9VNIjShlC82bOU
         +3/wFMARf41F33PsIpfIE+HDV5jD/dYp0KVQo=
MIME-Version: 1.0
In-Reply-To: <20110418142855.GE2466@opensource.wolfsonmicro.com>
References: <1303135451-26362-14-git-send-email-haojian.zhuang@marvell.com>
	<20110418142855.GE2466@opensource.wolfsonmicro.com>
Date: Mon, 18 Apr 2011 23:33:34 +0800
Message-ID: <BANLkTim1QHe-hpyt0yQxKt2SBwtOAPQ3Bg@mail.gmail.com>
Subject: Re: [PATCH 13/14] regulator: check name in initialization of max8925
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, dmitry.torokhov@gmail.com,
        a.zummo@towertech.it, johnpol@2ka.mipt.ru, cbou@mail.ru,
        dwmw2@infradead.org, lrg@slimlogic.co.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 10:28 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Mon, Apr 18, 2011 at 10:04:10PM +0800, Haojian Zhuang wrote:
>> Check name in initialization of max8925 regulator driver.
>
> What name are we checking and why do we need to check it?  I've no idea
> what the patch is supposed to do which makes it hard to review.
>
Actually, I didn't submit any platform driver before. So I can't
attach the related patch on
platform driver. After 2.6.39, I'll upload patches on platform driver.

In this original design, regulator data is assigned in platform driver
separately with index.
If I missed to define regulator[0] in platform data, the regulator
driver will meet failure
because of checking in max8925-core.c. The regulator[0] always means Buck0.

So I want to avoid to use the index and check regulator[] one by one.
I use a pointer to link
all regulator data together. I just need to check whether the
regulator pointer is valid or not.

>> +++ b/drivers/regulator/max8925-regulator.c
>> @@ -174,7 +174,7 @@ static struct regulator_ops max8925_regulator_ldo_ops = {
>>  #define MAX8925_SDV(_id, min, max, step)                     \
>>  {                                                            \
>>       .desc   = {                                             \
>> -             .name   = "SDV" #_id,                           \
>> +             .name   = "SD" #_id,                            \
>
> The above isn't obviously correct - it changes the name that's assigned
> from matching the macro used to something different.
>

The name isn't used by others. So I change it to SDx in order to
compare regulator name.
