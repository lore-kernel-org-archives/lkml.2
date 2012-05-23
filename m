Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab2EWERa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 00:17:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48994 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab2EWER2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 00:17:28 -0400
MIME-Version: 1.0
In-Reply-To: <4FBC4255.4040307@samsung.com>
References: <y@samsung.com>
	<4fbb2ada.63de440a.589d.78e2@mx.google.com>
	<4FBC4255.4040307@samsung.com>
Date: Wed, 23 May 2012 09:47:28 +0530
Message-ID: <CAKew6eVXhg9RscZFM1_go3bjvvn_99zqaDRQ1ZjG_BUWCYR0YQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] regulator: Add support for MAX77686.
From: Yadwinder Singh Brar <yadi.brar01@gmail.com>
To: jonghwa3.lee@samsung.com
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 23, 2012 at 7:20 AM,  <jonghwa3.lee@samsung.com> wrote:
> Hi, again.
> On 2012년 05월 22일 14:57, yadi.brar01@gmail.com wrote:
>
>
>> +static __devinit int max77686_pmic_probe(struct platform_device *pdev)
>> +{
>
>> +
>> +     for (i = 0; i < pdata->num_regulators; i++) {
>> +             config.dev = max77686->dev;
>> +             config.init_data = pdata->regulators[i].init_data;
>> +             config.driver_data = max77686;
>> +             config.regmap = iodev->regmap;
>> +
>> +             rdev[i] = regulator_register(&regulators[i], &config);
>
>
> I'm sorry that i missed one. You have to register all regulators
> unconditionally. Mark brown commented about this to my former patch.
>
> 'No, you should unconditionally register all regulators the device
> physically has.  This is useful for debug and simplifies the code.'
>                                                - from Mark Brown
>

Yes, we are registering all regulators here.
As pdata->num_regulators will be equal to ARRAY_SIZE(regulators)

Thanks,
Yadwinder.
