Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932834Ab2AEUtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:49:40 -0500
Received: from us-mx3.synaptics.com ([12.239.217.85]:28118 "EHLO
	us-mx3.synaptics.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2AEUti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:49:38 -0500
X-PGP-Universal: processed;
	by securemail.synaptics.com on Thu, 05 Jan 2012 12:37:30 -0800
Message-ID: <4F060CE2.5090705@synaptics.com>
Date: Thu, 5 Jan 2012 12:49:38 -0800
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

On 01/01/2012 10:38 PM, Shubhrajyoti wrote:
> Hi Christopher,
>
> On Thursday 22 December 2011 07:39 AM, Christopher Heiny wrote:
>> Signed-off-by: Christopher Heiny<cheiny@synaptics.com>
>>
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

You're thinking of dev->driver->suspend here, right?  If so, that sounds 
good to me.


>
>> +#endif
>> +
>> +	return 0;
>> +}
>> +
>> +static int rmi_bus_resume(struct device *dev)
>> +{
>> +#ifdef GENERIC_SUBSYS_PM_OPS
>> +	const struct dev_pm_ops *pm = dev->driver ? dev->driver->pm : NULL;
>> +
>> +	if (pm&&  pm->resume)
>> +		return pm->resume(dev);
> same here?
>> +#endif
>> +
>> +	return 0;
>> +}
>> +#endif
