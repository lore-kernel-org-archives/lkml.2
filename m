Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212Ab1L0IFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 03:05:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40318 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1L0IFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 03:05:39 -0500
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <201112262127.30271.rjw@sisk.pl>
References: <1324460205-24683-1-git-send-email-dg77.kim@samsung.com>
	<1324460205-24683-2-git-send-email-dg77.kim@samsung.com>
	<201112262127.30271.rjw@sisk.pl>
Date: Tue, 27 Dec 2011 17:05:38 +0900
X-Google-Sender-Auth: cr42U0KIqJeCHRwCyxQ1E0hhgEo
Message-ID: <CAJ0PZbRA+W12HAzp27Uzq=Cx5-1r08wmR-tamymKiP=V5X6pqw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] power: Charger-Manager: add initial
 Charger-Manager driver
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Donggeun Kim <dg77.kim@samsung.com>, linux-pm@vger.kernel.org,
        len.brown@intel.com, pavel@ucw.cz, rdunlap@xenotime.net,
        cbouatmailru@gmail.com, pali.rohar@gmail.com, prakity@marvell.com,
        broonie@opensource.wolfsonmicro.com, lars@metafoo.de,
        kyungmin.park@samsung.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/12/27 Rafael J. Wysocki <rjw@sisk.pl>:
> That should be called rtc_name and I'm not sure if using the name here is
> very convenient.  Perhaps it's better if the caller is responsible for
> opening the RTC device.

Hi Rafael,

Because struct rtc_device is created at rtc_device_register() call of
rtc device driver, the caller (rtc drivers are not supposed to create
charger manager) needs to call rtc_class_open(rtc_name) in order to
feed struct rtc_device to charger manager. Thus, I think that
enforcing the caller to provide struct rtc_device has no significant
benefit. Besides, it would prohibit statically defining struct
charger_global_desc: cannot define struct charger_global_desc example
= { .rtc_device = rtc_class_open("blahblah") };

>> +#define      CM_JIFFIES_SMALL        (2)
>
> Why do you want to use jiffies instead of ktime?
>

It is based on work schedule, which is based on jiffies. If we define
the "small time" with ktime, it should be translated to jiffies
anyway.

>> +static int charger_manager_probe(struct platform_device *pdev)
>> +{
>> +     struct charger_desc *desc = dev_get_platdata(&pdev->dev);
[]
>> +     if (!desc) {
>> +             dev_err(&pdev->dev, "No platform data (desc) found.\n");
>> +             ret = -ENODEV;
>> +             goto err_alloc;
>> +     }
>
> Is there any way to detect whether dev_get_platdata(&pdev->dev) really points
> to an instance of struct charger_desc ?

We are verifying the member values (whether they are in the proper
ranges) later in this probe function.
Other than that, I don't know a method to detect whether this pointer
is really pointing to struct charger_desc except for simply checking
whether it is NULL or not or enforcing users to add some magic values
in the struct to check (like mutex debug mode).

>> +     /* Basic Values. Unspecified are Null or 0 */
>> +     cm->dev = &pdev->dev;
>> +     cm->desc = desc;

We will let cm->desc to alloc some space and copy contents of desc
into cm->desc because desc may be __initdata.



Donggeun will update and submit patchset v3 mostly based on your
valueable comments.

Thank you so much, Rafael.


Cheers! And happy new year!
MyungJoo

-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
