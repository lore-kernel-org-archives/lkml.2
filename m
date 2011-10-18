Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab1JRLOz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 07:14:55 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55523 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1JRLOy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 07:14:54 -0400
Message-ID: <4E9D5FAB.2080605@linaro.org>
Date: Tue, 18 Oct 2011 12:14:51 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, jamie@jamieiles.com, arnd@arndb.de
Subject: Re: [PATCH 2/6] drivers/base: add bus for System-on-Chip devices
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org> <1318852378-14180-3-git-send-email-lee.jones@linaro.org> <20111017161854.GB5108@suse.de>
In-Reply-To: <20111017161854.GB5108@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/10/11 17:18, Greg KH wrote:
> On Mon, Oct 17, 2011 at 12:52:54PM +0100, Lee Jones wrote:
>> +void soc_device_unregister(struct device *dev)
> 
> Ick, no, pass in the struct soc_device, which the register function
> should return, not a "raw" struct device.

Okay.

>> +{
>> +	struct soc_device *soc_dev =
>> +		container_of(dev, struct soc_device, dev);
>> +
>> +	sysfs_remove_group(&dev->kobj, &soc_attr_group);
>> +
>> +	if (device_is_registered(dev))
>> +		device_unregister(dev);
> 
> Why is this call needed?

To unregister a previously unregistered device?

Is that wrong?

>> +
>> +	bus_unregister(&soc_bus_type);
> 
> What happens if you have more than one SOC device?  I think you just
> oopsed.

I think you're right.

When to you suggest we unregister the bus?

>> +
>> +	kfree(soc_dev->attr);
>> +	kfree(soc_dev);
> 
> Nope, you just failed again.  I can tell you never tried this code path,
> otherwise you would have noticed the HUGE warnings that the kernel spit
> back at you.  Please fix this.

I'll look into it.

Thanks.

Kind regards,
Lee
