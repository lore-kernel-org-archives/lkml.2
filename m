Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab1CHBuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 20:50:10 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55837 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab1CHBuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 20:50:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hnov6OBAlDKkxc1NMXGQit9xNuVLm6fR2slUROz5iUuFiH/h5IEmEEA1vO4TLlRrZv
         EiMJngjYCg9CmbKelyh7c3I6ZPvV+zpjj2Ev8VCVM83Q1BGqyKKDJdywikJ7P2WlPK4N
         wet/DQ+sCsLq3fHmBTk4qNMoVVPt9k4nfGYZI=
MIME-Version: 1.0
In-Reply-To: <20110305120302.GC30187@opensource.wolfsonmicro.com>
References: <1299221427-4726-1-git-send-email-myungjoo.ham@samsung.com>
	<1299221427-4726-3-git-send-email-myungjoo.ham@samsung.com>
	<20110305120302.GC30187@opensource.wolfsonmicro.com>
Date: Tue, 8 Mar 2011 10:50:04 +0900
X-Google-Sender-Auth: eOSZDoeBKGq0ShbE0U7b4ucrVPk
Message-ID: <AANLkTik4cT3fbsCLFcsUcNMtia1Ymnhe8JFzzO+N+9sq@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] MAX8997/8966 PMIC Regulator Driver Initial Release
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>, kyungmin.park@samsung.com,
        MyungJoo Ham <myungjoo.ham@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 5, 2011 at 9:03 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Fri, Mar 04, 2011 at 03:50:27PM +0900, MyungJoo Ham wrote:

[]

>
>> +static int max8997_reg_enable_suspend(struct regulator_dev *rdev)
>> +{
>> +     return 0;
>> +}
>> +
>
> This looks odd, especially since you have a disable operation?

The intention is to keep it enabled if it was enabled before entering
sleep and not to enable if it has not been using while the system is
running. Probably, we need three states for suspend-prepare for
regulators: disable, enable, keep_state?

>

[]

>
>> +static int max8997_resume(struct device *dev)
>> +{
>> +     struct platform_device *pdev = container_of(dev,
>> +                     struct platform_device, dev);
>> +     struct max8997_data *max8997 = platform_get_drvdata(pdev);
>> +     struct i2c_client *i2c = max8997->iodev->i2c;
>> +     struct regulator_dev *rdev;
>> +     int ret, reg, mask, pattern;
>> +     int i;
>> +     u8 val;
>> +
>> +     /* Show Error/Warning Messages for Inconsistency */
>> +     for (i = 0; i < MAX8997_REG_MAX; i++) {
>> +             if (max8997->saved_rdev[i]) {
>
> We should put this into the regulator core rather than doing it in
> drivers - it's not really driver specific and other regulators that
> can't preserve state over suspend and resume will need it.
>

This part was sort of "debug and test" part of the driver and removed
in the recent version of the patch.
However, the regulator core depends on calling
regulator_suspend_prepare by machine/architecture pm code and the core
does not have resume-related support. For that matter, I've made and
been using "regulator_suspend_finish" locally. I will post that patch
soon.



Thanks.


- MyungJoo
-- 
MyungJoo Ham (함명주), Ph.D.
Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: 82-10-6714-2858
