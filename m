Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab2CEWJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:09:49 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:39089 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756397Ab2CEWJr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:09:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of glikely@secretlab.ca designates 10.182.44.68 as permitted sender) smtp.mail=glikely@secretlab.ca
MIME-Version: 1.0
In-Reply-To: <20120305214747.GA9425@kroah.com>
References: <1330962461-9061-1-git-send-email-grant.likely@secretlab.ca> <20120305214747.GA9425@kroah.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 5 Mar 2012 15:09:27 -0700
X-Google-Sender-Auth: t9Qx5Ud625HgqyyNQWXvi3kF6EY
Message-ID: <CACxGe6samH6-o9Ye7h7Wpj8GztxvFpWDgcEvtx2ey+YRGYm_9g@mail.gmail.com>
Subject: Re: [PATCH] drivercore: Add driver probe deferral mechanism
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>, Dilan Lee <dilee@nvidia.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 2:47 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Mon, Mar 05, 2012 at 08:47:41AM -0700, Grant Likely wrote:
>> --- a/include/linux/device.h
>> +++ b/include/linux/device.h
>> @@ -587,6 +587,10 @@ struct device_dma_parameters {
>>   * @mutex:   Mutex to synchronize calls to its driver.
>>   * @bus:     Type of bus device is on.
>>   * @driver:  Which driver has allocated this
>> + * @deferred_probe: entry in deferred_probe_list which is used to retry the
>> + *           binding of drivers which were unable to get all the resources
>> + *           needed by the device; typically because it depends on another
>> + *           driver getting probed first.
>>   * @platform_data: Platform data specific to the device.
>>   *           Example: For devices on custom boards, as typical of embedded
>>   *           and SOC based hardware, Linux often uses platform_data to point
>> @@ -646,6 +650,7 @@ struct device {
>>       struct bus_type *bus;           /* type of bus device is on */
>>       struct device_driver *driver;   /* which driver has allocated this
>>                                          device */
>> +     struct list_head        deferred_probe;
>>       void            *platform_data; /* Platform specific data, device
>>                                          core doesn't touch it */
>>       struct dev_pm_info      power;
>
> This can go into the "struct device_private" structure instead, right?
> That would be better to ensure that no non-driver-core code ever touches
> this thing.

I don't see any reason why not.  I'll make the change and repost.

g.
