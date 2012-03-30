Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011Ab2C3Idv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 04:33:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39592 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759908Ab2C3Idp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 04:33:45 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <4F74E435.9030101@codeaurora.org>
References: <1328856038-21912-1-git-send-email-myungjoo.ham@samsung.com>
	<1330344939-18394-1-git-send-email-myungjoo.ham@samsung.com>
	<1330344939-18394-3-git-send-email-myungjoo.ham@samsung.com>
	<4F74E435.9030101@codeaurora.org>
Date: Fri, 30 Mar 2012 17:33:44 +0900
X-Google-Sender-Auth: Qy8BoVtNSHUEdEwG1VzGK2TSs5w
Message-ID: <CAJ0PZbR3TLoa+UDM7mZLugjfMR_R-j7dKr7dTk0QFy9WM5etMQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/5] Extcon: support generic GPIO extcon driver
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, NeilBrown <neilb@suse.de>,
        gregkh@linuxfoundation.org, Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        John Stultz <john.stultz@linaro.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnevag?= <arve@android.com>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Morten CHRISTIANSEN <morten.christiansen@stericsson.com>,
        Mike Lockwood <lockwood@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30, 2012 at 7:37 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 02/27/12 04:15, MyungJoo Ham wrote
>> +static irqreturn_t gpio_irq_handler(int irq, void *dev_id)
>> +{
>> +     struct gpio_extcon_data *extcon_data =
>> +         (struct gpio_extcon_data *)dev_id;
>
> Casting from void is unnecessary.
>
>> +
>> +static int gpio_extcon_probe(struct platform_device *pdev)
>
> __devinit?
>
>> +{
>> +     struct gpio_extcon_platform_data *pdata = pdev->dev.platform_data;
>> +     struct gpio_extcon_data *extcon_data;
>> +     int ret = 0;
> [snip]
>> +     return ret;
>> +}
>> +
>> +static int gpio_extcon_remove(struct platform_device *pdev)
>
> __devexit?
>> +{
>> +     struct gpio_extcon_data *extcon_data = platform_get_drvdata(pdev);
> [snip]
>> +static struct platform_driver gpio_extcon = {
>> +     .probe          = gpio_extcon_probe,
>> +     .remove         = gpio_extcon_remove,
>
> __devexit_p()?
>> +     .driver         = {
>> +             .name   = "extcon-gpio",
>> +             .owner  = THIS_MODULE,
>> +     },
>> +};
>> +
>> +module_platform_driver(gpio_extcon);
>> +
>> +MODULE_AUTHOR("Mike Lockwood <lockwood@android.com>");
>> +MODULE_DESCRIPTION("GPIO extcon driver");
>> +MODULE_LICENSE("GPL");
> --
> Sent by an employee of the Qualcomm Innovation Center, Inc.
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
>

Thank you for the comments.

I'll apply it and test on patchset v8.



Cheers!
MyungJoo.

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
