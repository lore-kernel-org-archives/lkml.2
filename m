Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab1IYFaV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 01:30:21 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:52961 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751109Ab1IYFaU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 01:30:20 -0400
MIME-Version: 1.0
In-Reply-To: <20110925040836.GP24631@ponder.secretlab.ca>
References: <1316730422-20027-1-git-send-email-mturquette@ti.com>
 <1316730422-20027-7-git-send-email-mturquette@ti.com> <20110925040836.GP24631@ponder.secretlab.ca>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sat, 24 Sep 2011 22:29:59 -0700
Message-ID: <CAJOA=zOf6LjHjsZKYvyurSoRNo3Kb35TJqjNsZbauox4TBtsFg@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] clk: Add initial WM831x clock driver
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jeremy.kerr@canonical.com, broonie@opensource.wolfsonmicro.com,
        tglx@linutronix.de, linus.walleij@stericsson.com,
        amit.kucheria@linaro.org, dsaxena@linaro.org, patches@linaro.org,
        linaro-dev@lists.linaro.org, paul@pwsan.com, sboyd@quiinc.com,
        shawn.guo@freescale.com, skannan@quicinc.com, magnus.damm@gmail.com,
        arnd.bergmann@linaro.org, linux@arm.linux.org.uk, eric.miao@linaro.org,
        richard.zhao@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 24, 2011 at 9:08 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, Sep 22, 2011 at 03:27:01PM -0700, Mike Turquette wrote:
>> From: Mark Brown <broonie@opensource.wolfsonmicro.com>
>>
>> The WM831x and WM832x series of PMICs contain a flexible clocking
>> subsystem intended to provide always on and system core clocks.  It
>> features:
>>
>> - A 32.768kHz crystal oscillator which can optionally be used to pass
>>   through an externally generated clock.
>> - A FLL which can be clocked from either the 32.768kHz oscillator or
>>   the CLKIN pin.
>> - A CLKOUT pin which can bring out either the oscillator or the FLL
>>   output.
>> - The 32.768kHz clock can also optionally be brought out on the GPIO
>>   pins of the device.
>>
>> This driver fully supports the 32.768kHz oscillator and CLKOUT.  The FLL
>> is supported only in AUTO mode, the full flexibility of the FLL cannot
>> currently be used.  The use of clock references other than the internal
>> oscillator is not currently supported, and since clk_set_parent() is not
>> implemented in the generic clock API the clock tree configuration cannot
>> be changed at runtime.
>>
>> Due to a lack of access to systems where the core SoC has been converted
>> to use the generic clock API this driver has been compile tested only.
>>
>> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> Signed-off-by: Mike Turquette <mturquette@ti.com>
>
> A few minor comments below.  Otherwise looks fine to me.
>
>> +static __devinit int wm831x_clk_probe(struct platform_device *pdev)
>> +{
>> +     struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
>> +     struct wm831x_clk *clkdata;
>> +     int ret;
>> +
>> +     clkdata = kzalloc(sizeof(*clkdata), GFP_KERNEL);
>
> If devm_kzalloc() is used, then all the kfree unwinding can be
> dropped.
>
>> +static int __init wm831x_clk_init(void)
>> +{
>> +     int ret;
>> +
>> +     ret = platform_driver_register(&wm831x_clk_driver);
>> +     if (ret != 0)
>> +             pr_err("Failed to register WM831x clock driver: %d\n", ret);
>> +
>> +     return ret;
>
> No need for this song-and-dance.  The driver core is pretty well
> debugged.  Just use "return platform_driver_register(...);"

Grant,

Thanks for the review.

Mark,

I know you're not carrying this whole set of patches but do you want
to rework this and resend or do you just want me to fix it up?
Changes are trivial if you don't want to touch it.

Regards,
Mike

> g.
>
