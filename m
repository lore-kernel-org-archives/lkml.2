Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab2JRIH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 04:07:57 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:41464 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab2JRIHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 04:07:52 -0400
MIME-Version: 1.0
In-Reply-To: <CAJLyvQyvMpeYK4PrgEcRwNX74-e5RApX9ZcWJp1+Fgp8jhD9cQ@mail.gmail.com>
References: <1350387889-15324-1-git-send-email-hongbo.zhang@linaro.com>
	<1350387889-15324-6-git-send-email-hongbo.zhang@linaro.com>
	<CAKohpo=Vfq=z8NK6w4_QpwwLniYiwcfGfzWZsoG_zBPYPXrcUw@mail.gmail.com>
	<CAJLyvQyvMpeYK4PrgEcRwNX74-e5RApX9ZcWJp1+Fgp8jhD9cQ@mail.gmail.com>
Date: Thu, 18 Oct 2012 13:37:51 +0530
Message-ID: <CAKohponyeATPdmB7BZGShfaH0ETX8qfBLNM5jSkk6DpQ8vKfZw@mail.gmail.com>
Subject: Re: [PATCH 5/5] Thermal: Add ST-Ericsson db8500 thermal dirver.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Hongbo Zhang <hongbo.zhang@linaro.org>
Cc: linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        kernel@igloocommunity.org, linaro-kernel@lists.linaro.org,
        "hongbo.zhang" <hongbo.zhang@linaro.com>, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18 October 2012 13:05, Hongbo Zhang <hongbo.zhang@linaro.org> wrote:
> On 17 October 2012 23:23, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> On 16 October 2012 17:14, hongbo.zhang <hongbo.zhang@linaro.org> wrote:

>>> +static struct db8500_trip_point db8500_trips_table[] = {
>>> +       [0] = {
>>> +               .temp = 70000,
>>> +               .type = THERMAL_TRIP_ACTIVE,
>>> +               .cooling_dev_name = {
>>> +                       [0] = "thermal-cpufreq-0",
>>
>> If i am not wrong length of cooling_dev_name can't be greater than 8
> You are wrong this time, it is 20
> #define THERMAL_NAME_LENGTH 20

Ahh.. Its the array size fixed to 8.. not length of each element within.

>>>  static void __init mop500_init_machine(void)
>>> @@ -765,6 +834,10 @@ struct of_dev_auxdata u8500_auxdata_lookup[] __initdata = {
>>>                 "ux500-msp-i2s.2", &msp2_platform_data),
>>>         OF_DEV_AUXDATA("stericsson,ux500-msp-i2s", 0x80125000,
>>>                 "ux500-msp-i2s.3", &msp3_platform_data),
>>> +       OF_DEV_AUXDATA("stericsson,db8500-thermal", 0x801573c0,
>>> +                       "db8500-thermal", &db8500_thsens_data),
>>> +       OF_DEV_AUXDATA("stericsson,db8500-cpufreq-cooling", 0,
>>> +                       "db8500-cpufreq-cooling", NULL),
>>>         {},
>>>  };

>> Whatever the case, at-least we should pass data via DT for
>> u8500_auxdata_lookup[].
>> As you are adding the driver for the first time here, it must be able to parse
>> data via DT.
> Yes, for "db8500-thermal", data &db8500_thsens_data is parsed via DT
> but there is really no data for "db8500-cpufreq-cooling".

You didn't get my point. You are not parsing pdata via DT here, but setting
pdata of device node created due to DT.

What i am saying is, you must put in code in thermal driver, which will actually
parse data from DT and create a pdata structure at run time. And there you
would be required to add another file in Documentation with bindings for this
driver.

>>> +static int db8500_cpufreq_cooling_suspend(struct platform_device *pdev,
>>> +               pm_message_t state)
>>> +{
>>> +       return -ENOSYS;
>>> +}
>>> +
>>> +static int db8500_cpufreq_cooling_resume(struct platform_device *pdev)
>>> +{
>>> +       return -ENOSYS;
>>> +}
>>
>> Do you need these? Wouldn't it be same if you don't define them?
> There were not such functions before, I added them after reading
> Documentation/SubmittingDrivers.
> Is the document too old? should I follow it?

Probably the document is correct and i am not :)

--
viresh
