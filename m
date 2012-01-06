Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758468Ab2AFB44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 20:56:56 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:48215 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372Ab2AFB4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 20:56:54 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 05 Jan 2012 17:44:44 -0800
Message-ID: <4F0654E5.3010400@synaptics.com>
Date: Thu, 5 Jan 2012 17:56:53 -0800
From: Christopher Heiny <cheiny@synaptics.com>
Organization: Synaptics, Inc
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Shubhrajyoti <shubhrajyoti@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jean Delvare <khali@linux-fr.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [RFC PATCH 2/11] input: RMI4 core bus and sensor drivers.
References: <1324519802-23894-1-git-send-email-cheiny@synaptics.com> <1324519802-23894-3-git-send-email-cheiny@synaptics.com> <4F0150D7.2010600@ti.com>
In-Reply-To: <4F0150D7.2010600@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shubhrajyoti,

Thanks for the feedback.  Please see my comments below.


On 01/01/2012 10:38 PM, Shubhrajyoti wrote:
> Hi Christopher,
>
> On Thursday 22 December 2011 07:39 AM, Christopher Heiny wrote:
>> Signed-off-by: Christopher Heiny<cheiny@synaptics.com>
>>
>> Cc: Dmitry Torokhov<dmitry.torokhov@gmail.com>
>> Cc: Linus Walleij<linus.walleij@stericsson.com>
>> Cc: Naveen Kumar Gaddipati<naveen.gaddipati@stericsson.com>
>> Cc: Joeri de Gram<j.de.gram@gmail.com>
>>
>> ---
>>
>>   drivers/input/rmi4/rmi_bus.c    |  436 ++++++++++++
>>   drivers/input/rmi4/rmi_driver.c | 1488 +++++++++++++++++++++++++++++++++++++++
>>   drivers/input/rmi4/rmi_driver.h |   97 +++
>>   3 files changed, 2021 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/input/rmi4/rmi_bus.c b/drivers/input/rmi4/rmi_bus.c

[snip]

>> +#ifdef CONFIG_PM
>> +static int rmi_bus_suspend(struct device *dev)
>> +{
>> +#ifdef GENERIC_SUBSYS_PM_OPS
>> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>> +
>> +	if (pm&&  pm->suspend)
>> +		return pm->suspend(dev);
> If driver-pm- suspend is not there should you not fall back to . suspend ?

I'm looking into using dev->driver->suspend() here.  It wants a 
pm_message_t for the pm state.  We don't have that on entry to 
bus_suspend, though.  Any suggestion as to what we should pass?

				Thanks,
					Chris
